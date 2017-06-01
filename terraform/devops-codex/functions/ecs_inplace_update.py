from boto3.session import Session

import json
import urllib.parse
import boto3
import tempfile
import traceback
import botocore
import zipfile
import os

ECS_REGION = os.environ.get("ECS_REGION")
ECR_REGION = os.environ.get("ECR_REGION")
ECR_REPO = os.environ.get("ECR_REPO")
ECS_CLUSTER = os.environ.get("ECS_CLUSTER")
SERVICE_NAME = os.environ.get("SERVICE_NAME")
FAMILY_NAME = os.environ.get("FAMILY_NAME")
ECS_TASK_CPU = int(os.environ.get("ECS_TASK_CPU"))
ECS_TASK_MEMORY = int(os.environ.get("ECS_TASK_MEMORY"))
ECS_TASK_PORT = int(os.environ.get("ECS_TASK_PORT"))
DESIRED_COUNT = int(os.environ.get("DESIRED_COUNT"))
MAX_HEALTHY_PERCENT = int(os.environ.get("MAX_HEALTHY_PERCENT"))
MIN_HEALTH_PERCENT = int(os.environ.get("MIN_HEALTH_PERCENT"))

ecs_client = boto3.client('ecs',region_name=ECS_REGION)
code_pipeline = boto3.client('codepipeline')

def setup_s3_client(job_data):
    """Creates an S3 client
    
    Uses the credentials passed in the event by CodePipeline. These
    credentials can be used to access the artifact bucket.
    
    Args:
        job_data: The job data structure
        
    Returns:
        An S3 client with the appropriate credentials
        
    """
    key_id = job_data['artifactCredentials']['accessKeyId']
    key_secret = job_data['artifactCredentials']['secretAccessKey']
    session_token = job_data['artifactCredentials']['sessionToken']
    
    session = Session(aws_access_key_id=key_id,
        aws_secret_access_key=key_secret,
        aws_session_token=session_token)
    return session.client('s3', config=botocore.client.Config(signature_version='s3v4'))

def updateECService(imageTag):
    # Get the latest task definition
    response = ecs_client.describe_task_definition(
        taskDefinition=FAMILY_NAME
    )
    familyName = response['taskDefinition']['family']
    revision = response['taskDefinition']['revision']
    task_def = response['taskDefinition']['containerDefinitions'][0]
    preImage = task_def['image']
    tagStart = preImage.find(':')+1
    tagEnd = len(preImage)
    tag = preImage[tagStart:tagEnd]
    imageRepo = preImage[:tagStart]
    print("Image Old Tag:"+tag+",Image New Tag:"+imageTag)
    print("imageRepo:"+imageRepo)
    task_def['image']=imageRepo+imageTag
    
    response = ecs_client.register_task_definition(
       family=familyName,
       containerDefinitions=[
          task_def     
       ]
    ) 
    print("Register Task Response: " + json.dumps(response, indent=2))
    revision = response['taskDefinition']['revision']
    srvUpdatResponse = ecs_client.update_service(
        cluster=ECS_CLUSTER,
        service=SERVICE_NAME,
        desiredCount=DESIRED_COUNT,
        taskDefinition=FAMILY_NAME+':'+str(revision),
        deploymentConfiguration={
          'maximumPercent': MAX_HEALTHY_PERCENT,
          'minimumHealthyPercent': MIN_HEALTH_PERCENT
        }
    )

def put_job_success(job, message):
    """Notify CodePipeline of a successful job
    
    Args:
        job: The CodePipeline job ID
        message: A message to be logged relating to the job status
        
    Raises:
        Exception: Any exception thrown by .put_job_success_result()
    
    """
    print('Putting job success')
    print(message)
    code_pipeline.put_job_success_result(jobId=job)
  
def put_job_failure(job, message):
    """Notify CodePipeline of a failed job
    
    Args:
        job: The CodePipeline job ID
        message: A message to be logged relating to the job status
        
    Raises:
        Exception: Any exception thrown by .put_job_failure_result()
    
    """
    print('Putting job failure')
    print(message)
    code_pipeline.put_job_failure_result(jobId=job, failureDetails={'message': message, 'type': 'JobFailed'})

def lambda_handler(event, context):
    """
     Args:
        event: The event passed from code pipeline
    """    
    print("Received event: " + json.dumps(event, indent=2))
    ACCOUNT_ID = context.invoked_function_arn.split(":")[4]
    
    try:
        # Extract the Job ID
        job_id = event['CodePipeline.job']['id']
        # Extract the Job Data 
        job_data = event['CodePipeline.job']['data']
         # Get the list of artifacts passed to the function
        artifacts = job_data['inputArtifacts']
        imageTabArtifact = artifacts[0]
        imageTagData = {}
        
        if 'continuationToken' in job_data:
            # If we're continuing then the update ecs service has already been triggered
            # we will do nothing.
            put_job_success(job_id, 'There were ongoing ecs service updates')
        else:
            s3 = setup_s3_client(job_data)
            tmp_file = tempfile.NamedTemporaryFile()
            bucket = imageTabArtifact['location']['s3Location']['bucketName']
            key = imageTabArtifact['location']['s3Location']['objectKey']
            with tempfile.NamedTemporaryFile() as tmp_file:
                s3.download_file(bucket, key, tmp_file.name)
                with zipfile.ZipFile(tmp_file.name, 'r') as zip:
                    imageTagData = json.loads(zip.read('build.json').decode())
                    
            print("Downloaded Image Tab  : " + json.dumps(imageTagData, indent=2))
            imageTag = imageTagData['tag']
            updateECService(imageTag)
            put_job_success(job_id, 'Update ecs serivce using the new docker image tag'+imageTag)
            
    except Exception as e:
        # If any other exceptions which we didn't expect are raised
        # then fail the job and log the exception message.
        print('Function failed due to exception.') 
        print(e)
        traceback.print_exc()
        put_job_failure(job_id, 'Function exception: ' + str(e))
       
     
   
    print('Function complete.') 
    return "Complete."
