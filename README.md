

Samples for AWS infra as a code
===============================

- **aws-cli**: frequent aws cli sample commands
- **[AWS-BJS](https://github.com/soldierxue/infra-as-code-samples/tree/master/bjs)**
  - [**BJS-LAB1**](#bjs-lab1):*phpdemo-full* Build a full PHP Demo stack from zero in AWS BJS(China) region
  - [**BJS-LAB2**](#bjs-lab2):*vpcfull-s3backend* Here we demo how to build a solid vpc environment with HA NAT instances in AWS BJS(China) region, besides, we will show a new way to store terraform state(terraform managed aws resource state) in AWS s3 bucket
  - [**BJS-LAB3**](#bjs-lab3): This lab demos you a situation that, you have built a VPC environment just like [BJS-LAB2](#bjs-lab2), then you want to creat a PHP/MySQL app within it, then you can get the vpc details from stored S3 terraform state file
- **[ECS-DevOps](https://github.com/soldierxue/infra-as-code-samples/tree/master/ecs-devops)**
  - One HelloWorld service running on ECS cluster 
  - CodePipeline for souce build/deploy , it supports In Place and Canary deployment module
- **[Spring-ECS](https://github.com/soldierxue/infra-as-code-samples/tree/master/spring-ecs)**
  - Total 4 Pet Clinic Micro Services, including Owner, Pet, Vet, Visit services
  - Total 2 supporting services, including Spring Cloud Config and Eureka Service discovery
  - Full supports of ECS cluster, ASG, ALB/Target Group, Route53,etc.


Prerequisite:
-------------
We have tested and completed the whole labs in Amazon Linux, binding with the right instance role for managed AWS resources:

**准备好 AWS 环境** 

- 在 AWS 上通过给EC2 Instance 绑定合适的 IAM 角色（推荐）

- 还需要准备一个 Keypair （密钥对）用来绑定到新启动的 EC2 实例上，进行后续的登陆和操作

**Lab tools: **

- Terraform version 0.9+
- Docker version 17.03.1-ce, build 7392c3b/17.03.1-ce  
- docker-compose version 1.8.0, build f3628c7
- git version 2.7.5
- python 3.x for running boto3 scripts
- maven & java 1.8 runtime to build java projects


**Preparing Terraform runtime：**

1. Download [Terraform 0.9+](https://www.terraform.io/downloads.html)
2. For Linux system, 
```sh
wget https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip
unzip terraform_*.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform
terraform --version
```
3. Varify [Terraform 环境](https://www.terraform.io/intro/getting-started/install.html)


**Prepare Docker & Docker Compose runtime：**

Refer [AWS document](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker) for details.

```sh
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user 
#Log out and log back in again to pick up the new docker group permissions.
docker info

sudo curl -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > docker-compose 
sudo mv docker-compose /usr/local/bin/
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
docker-compose version 1.10.0, build 4bd6f1a

```

**准备好 git 的环境：**

```sh
sudo yum install -y git
```

**Preparing python3.4 runtime：**
Please refer [How do I create an isolated Python 3.4 environment with Boto 3 on Amazon EC2 using virtualenv?](https://aws.amazon.com/cn/premiumsupport/knowledge-center/python-boto3-virtualenv/) for details:

```sh
sudo yum install python34
which python3.4
cd /home/ec2-user
mkdir venv
cd venv
virtualenv -p /usr/bin/python3.4 python34
source /home/ec2-user/venv/python34/bin/activate
which python
pip install boto3

# Add the result to the .bashrc file

vim ~/.bashrc

source /home/ec2-user/venv/python34/bin/activate

```

**Preparing Maven & java 1.8 runtime：**
```sh
sudo yum install -y java-1.8.0-openjdk-devel
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-2.b11.30.amzn1.x86_64/jre/

# Add the JAVA_HOME to the .bashrc file to make it effect next time you logout/login
vim ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-2.b11.30.amzn1.x86_64/jre/

sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version



```

Run the samples:
----------------
- For **Spring ECS Demo** : please follow this [guide](https://github.com/soldierxue/infra-as-code-samples/tree/master/spring-ecs) to continue.
- For **DevOps & ECS HelloWorld Demo ** : please follow this [guide](https://github.com/soldierxue/infra-as-code-samples/tree/master/ecs-devops) to continue.
- For ** BJS Demos ** : please follow this [guide](https://github.com/soldierxue/infra-as-code-samples/tree/master/bjs) to continue.
