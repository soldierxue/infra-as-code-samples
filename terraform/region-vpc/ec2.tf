resource "aws_instance" "phpapp" {
  ami           = "${data.aws_ami.amazonlinux_ami.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${module.public_subnet1.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.frontend.id}"]
  key_name = "${var.ec2keyname}"
  root_block_device  {
     volume_type ="gp2"
     volume_size ="20"
     delete_on_termination="true"
  }
  ebs_block_device {
     device_name = "sda-ebs"
     volume_type ="gp2"
     volume_size ="10"
     delete_on_termination="true"  
  }
  
  tags {
        Name = "phpapp"
        Owner = "Jason"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  yum update -y
  yum install -y httpd24 php56 php56-mysqlnd
  service httpd start
  chkconfig httpd on
  echo "<?php" >> /var/www/html/calldb.php
  echo "\$conn = new mysqli('${var.mysqlPrefix}.$${var.DnsZoneName}', 'root', 'secret', 'test');" >> /var/www/html/calldb.php
  echo "\$sql = 'SELECT * FROM mytable'; " >> /var/www/html/calldb.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/calldb.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'the value is: ' . \$row['mycol'] ;} " >> /var/www/html/calldb.php
  echo "\$conn->close(); " >> /var/www/html/calldb.php
  echo "?>" >> /var/www/html/calldb.php
HEREDOC
}

resource "aws_instance" "database" {
  ami           = "${data.aws_ami.amazonlinux_ami.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  subnet_id = "${module.private_subnet1.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
  key_name = "${var.ec2keyname}"
  tags {
        Name = "mysql-database"
        Owner = "Jason"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  yum update -y
  yum install -y mysql55-server
  service mysqld start
  /usr/bin/mysqladmin -u root password 'secret'
  mysql -u root -psecret -e "create user 'root'@'%' identified by 'secret';" mysql
  mysql -u root -psecret -e 'CREATE TABLE mytable (mycol varchar(255));' test
  mysql -u root -psecret -e "INSERT INTO mytable (mycol) values ('terraform with aws great!') ;" test
HEREDOC
}