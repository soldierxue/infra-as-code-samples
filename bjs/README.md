Samples for AWS infra as a code
===============================

- **aws-cli**: frequent aws cli sample commands
- **[AWS-BJS](#aws-bjs)**
  - [**BJS-LAB1**](#bjs-lab1):*phpdemo-full* Build a full PHP Demo stack from zero in AWS BJS(China) region
  - [**BJS-LAB2**](#bjs-lab2):*vpcfull-s3backend* Here we demo how to build a solid vpc environment with HA NAT instances in AWS BJS(China) region, besides, we will show a new way to store terraform state(terraform managed aws resource state) in AWS s3 bucket
  - [**BJS-LAB3**](#bjs-lab3): This lab demos you a situation that, you have built a VPC environment just like [BJS-LAB2](#bjs-lab2), then you want to creat a PHP/MySQL app within it, then you can get the vpc details from stored S3 terraform state file

Architect Overview
------------------
- **[Network Architect](#network-architect)**: Architect for BJS Networking with HA NAT Instances
- **[PHP Demo Architect](#php-demo-architect)**: Architect for BJS PHP Web Demo


AWS-BJS
---------
For BJS(China) region samples, we build a sample for managing BJS :

- VPC : how to create a VPC
- Subnets: Public & Private subnets
- Routes : how to create & update routes
- IAM : how to create and use IAM roles
- IGW : internet gateway for instances in public subnets access internet
- NAT Instances(ec2): because BJS region has no managed NAT Gateway service, so this sample demos how to create a HA NAT instances for two private subnets
- PHP Demo: php website with a db call to backend mysql , use this website to verify the VPC resources are created correctly

Prerequisite:
-------------

**准备好 Terraform 的环境：**

1. 下载 [Terraform 0.9+](https://www.terraform.io/downloads.html)
2. 对于 Linux 操作系统, 解压 terraform 命令创建文件链接
```sh
unzip [PATH]/terraform*.zip
cd /usr/bin
sudo ln -s [PATH]/terraform
```
3. 验证你的 [Terraform 环境](https://www.terraform.io/intro/getting-started/install.html)

**准备好 AWS 环境** 

- 一种方式是在 Terraform 的配置文件中 provider 模块显式注明 AWS access_key & secret_key
```hcl
provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

```
- 另外一种方式是在 AWS 上通过给EC2 Instance 绑定合适的 IAM 角色（推荐）

- 还需要准备一个 Keypair （密钥对）用来绑定到新启动的 EC2 实例上，进行后续的登陆和操作

运行 Terraform BJS Sample:
-------------------------

参考以下步骤来体验 BJS 的 Terraform 样例：

BJS-LAB1
--------

在 AWS BJS 创建一个完整的 PHP stack（包括VPC，Subnet，NAT Instances& PHPdemo），只需按照以下步骤执行：

```sh
sudo git clone https://github.com/soldierxue/infra-as-code-samples
cd ./infra-as-code-samples/bjs/phpdemo-full

sudo cp [PATH]/bjskey.pem /home/ec2-user/
sudo chmod 600 /home/ec2-user/bjsMyKey.pem
sudo terraform get --update
sudo terraform plan 
sudo terraform apply
```

该实验的部分样例代码（创建一个网络基础设施）如下，用户只需要关注准备的必要参数，通过 *stack_name* 和 *environment* 参数设置，用户可以创建不同的环境比如生产环境、测试环境，预生产环境等等。

```hcl
module "bjs-vpc" {
  source          = "github.com/soldierxue/terraformlib/bjs-infra"
  region          = "cn-north-1"
  base_cidr_block = "10.0.0.0/16"
  stack_name = "bjsdemo"
  environment = "test"
  ec2keyname = "bjsMyKey"
  keyfile = "~/bjsMyKey.pem"
  subnet_private_cidrs = ["10.0.48.0/20","10.0.112.0/20"]
  subnet_public_cidrs = ["10.0.0.0/20","10.0.16.0/20"]
}
```

通过 Terraform 销毁整个 Terraform 管理的环境：

```sh
sudo terraform destroy
```
BJS-LAB2
--------
运行该样例之前请准备好：
- BJS 区域的一个存储桶：默认名字为 terraform
- BJS 一个keypair，默认是 bjsMyKey.pem

根据以上信息，检查样例代码里面的参数配置是否一致：

```sh
vi ./infra-as-code-samples/bjs/vpcfull-s3backend/main.tf
```

```hcl
terraform {
  backend "s3" {
    bucket = "terraform"  ## 重点检查
    key    = "network/terraform.tfstate"
    region = "cn-north-1"
  }
}

module "bjs-vpc" {
  source          = "github.com/soldierxue/terraformlib/bjs-infra"
  region          = "cn-north-1"
  base_cidr_block = "10.0.0.0/16"
  stack_name = "bjsdemo" 
  environment = "test" 
  ec2keyname = "bjsMyKey" ## 重点检查
  keyfile = "~/bjsMyKey.pem" ## 重点检查
  subnet_private_cidrs = ["10.0.48.0/20","10.0.112.0/20"]
  subnet_public_cidrs = ["10.0.0.0/20","10.0.16.0/20"]
}
```
```sh
cd ./infra-as-code-samples/bjs/vpcfull-s3backend

sudo terraform get --update
sudo terraform init 
sudo terraform plan
sudo terraform apply
```

BJS-LAB3
--------
运行该样例之前请准备好：
- 你已经成功执行 [BJS-LAB2](#bjs-lab2)
- 检查 S3 bucket名字和 keypair 名字

根据以上信息，检查样例代码里面的参数配置是否一致：

```sh
vi ./infra-as-code-samples/bjs/phpdemo-s3backend/main.tf
```

```hcl
data "terraform_remote_state" "bjs" {
  backend = "s3"
  config {
    bucket = "terraform" ## 重点检查， 和lab2一致
    key    = "network/terraform.tfstate"
    region = "cn-north-1"
  }
}

module "demophp" {
    source = "github.com/soldierxue/terraformlib/bjs-infra/demo-php"
    name ="${data.terraform_remote_state.bjs.stack_name}"
    environment = "${data.terraform_remote_state.bjs.environment}"
    vpc_id          = "${data.terraform_remote_state.bjs.vpc_id}"
    public_subnet_id = "${data.terraform_remote_state.bjs.subnet_public_ids[0]}"
    fronend_web_sgid = "${data.terraform_remote_state.bjs.sg_frontend_id}"

    private_subnet_id = "${data.terraform_remote_state.bjs.subnet_private_ids[0]}"
    database_sgid = "${data.terraform_remote_state.bjs.sg_database_id}"

    ec2keyname = "bjsMyKey"  ## 重点检查
}
```
```sh
cd ./infra-as-code-samples/bjs/phpdemo-s3backend

sudo terraform get --update
sudo terraform init
sudo terraform plan 
sudo terraform apply
```

Samples for AWS infra as a code
Network Architect
-----------------

![NAT HA Architect](../images/bjs-nat.jpg)

- 假定我们有两个 NAT 实例，NAT#1 和 NAT#2；两个私有子网，private subnet#1和private subnet#2；两个子网路由route1 和route2，route1 关联到private subnet#1，route2关联到private subnet#2；
- 初始化route1的外网路由，0.0.0.0/0 转发到 NAT#1；
- 初始化route2的外网路由，0.0.0.0/0 转发到 NAT#2；
- 两个 NAT 实例中配置运行 nat_monitor.sh 脚本；该脚本定时检查另一个 NAT 实例状态；如果发现另外一个NAT实例不工作，那么就会修改本来路由到该NAT（不工作的NAT实例）的路由表记录指向健康的NAT实例（自己）；如果该脚本发现自己恢复了，就会重置关联到自己的私网转发路由记录重新指向自己；

PHP Demo Architect
------------------

![PHP Demo Architect](../images/php-arch.png)

- 通过 Terraform 分别在公有子网和私有子网创建两台EC2
- 通过 EC2 的 User Data 配置好 PHP 和 MySQL 环境
- calldb.php 测试和 私有子网的 MySQL 实例的联通性