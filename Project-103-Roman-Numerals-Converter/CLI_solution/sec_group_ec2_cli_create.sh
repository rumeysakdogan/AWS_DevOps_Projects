WARNING!!!
Tüm işlemler öğrencilere bir EC2 oluşturtup onun üzerinde yürütülecektir. Komutlar powershell ya da başka OSlere göre farklılık gösterebiliyor.

- Ok! First of all, we need to launch an instance to execute commands in one hand. Because, commands can change based on operating systems. Well attach security group which allows ssh from anywhere.

- We should update yum package and install AWS CLI v2
```bash
sudo yum update -y
```
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

- Write your credentials using this command
```bash
aws configure
```

1. Security Groupların oluşturulması

```bash
aws ec2 create-security-group \
    --group-name roman_numbers_sec_grp \
    --description "This Sec Group is to allow ssh and http from anywhere"
```

We can check the security Group with these commands
```bash
aws ec2 describe-security-groups --group-names roman_numbers_sec_grp
```

You can check IPs with this command into the EC2
curl https://checkip.amazonaws.com


2. Create Rules
a. roman_numbers_sec_grp Security Group
```bash
aws ec2 authorize-security-group-ingress \
    --group-name roman_numbers_sec_grp \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name roman_numbers_sec_grp \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
```

3. After creating security Groups, Well create our EC2s. Latest AMI id should be used

This command is to get latest AMI ID that we use.
- ilk olarak son ami bilgilerini çekelim
```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1
```
- ikinci aşamada query çalıştırarak son ami numarasını elde edelim 
```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text
```

- sonra bu değeri bir variable a atayalım.
```bash
LATEST_AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)
```

- Now run the instance with CLI command

```bash
aws ec2 run-instances --image-id $LATEST_AMI --count 1 --instance-type t2.micro --key-name serdar --security-groups roman_numbers_sec_grp --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roman_numbers}]' --user-data file:///Users/ODG/Desktop/git_dir/serdar-cw/porfolio_lesson_plan/week_6_romen_numerals/CLI_solution/userdata.sh

or

aws ec2 run-instances \
    --image-id $LATEST_AMI \
    --count 1 \
    --instance-type t2.micro \
    --key-name serdar \
    --security-groups roman_numbers_sec_grp \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roman_numbers}]'
```

- To see the each instances Ip we\'ll use describe instance CLI command
```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers"
```

- You can run the query to find Public IP and instance_id of instances:
```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].PublicIpAddress[]' 
# Try this with "--output text" next time

aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].InstanceId[]'
```
# Try this with "--output text" next time

- To delete instances
```bash
aws ec2 terminate-instances --instance-ids <We can learn this with querry>
```
- To delete security groups
```bash
aws ec2 delete-security-group --group-name roman_numbers_sec_grp
```
