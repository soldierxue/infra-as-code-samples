from boto3.session import Session

import json
import urllib.parse
import boto3
import tempfile
import traceback
import botocore
import zipfile

ecs_client = boto3.client('ecs',region_name='ap-northeast-1')
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
    response = ecs_client.register_task_definition(
       family='spring-hw-demo',
       containerDefinitions=[
          {
            "name": "spring-hw-demo",
            "image": "188869792837.dkr.ecr.us-east-1.amazonaws.com/jasonreg:"+imageTag,
            "cpu": 500,
            "memory": 200,
            "essential": True,
            "portMappings": [
              {
                "containerPort": 8080
              }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "spring-hw-demo",
                    "awslogs-region": "ap-north1-key"
                }
            },
            "environment": [
              { "name": "SERVICE_NAME", "value": "spring-hw-demo"}
            ]
          }      
       ]
    ) 
    print("Task New Response: " + json.dumps(response, indent=2))
    revision = response['taskDefinition']['revision']
    srvUpdatResponse = ecs_client.update_service(
        cluster='ecs-jason-demo',
        service='spring-hw-demo',
        desiredCount=2,
        taskDefinition='spring-hw-demo:'+str(revision)
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
