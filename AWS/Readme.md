# STEPS : 
- Create RDS Postgresql
- Create EKS 
- Create node-group 
- Create Security Group for EFS (butuh vpc-id, dll) [cek link](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)
- EFS Create 5 EFS per PV
- apply nfs-pvc.yaml --> file_id ambil dari step "create 5 EFS"
- apply pod.yaml --> cek status pvc
- apply nginx-deployment.yaml
- apply odoo-deployment.yaml
- TBA 
- Odoo service 
- nginx service
- LoadBalancer 

# NOTES

```
aws configure 
```
AWS Access Key ID [****************MWW3]:
AWS Secret Access Key [****************nMt8]:
Default region name [ap-southeast-3]:
Default output format [None]:

gunakan user yang punya akses ke cluster sebagai clusteradmin


```
aws eks --region ap-southeast-3 update-kubeconfig --name cluster-dev
aws eks --region ap-southeast-3 update-kubeconfig --name cluster-poc

kubectl config set-context --current --namespace=development
```


#postgressql 
postgres:CLS.1234

jdbc:postgresql://odoo.cjg8hpqydwuv.ap-southeast-3.rds.amazonaws.com:5432/odoo
odoo.cjg8hpqydwuv.ap-southeast-3.rds.amazonaws.com
odoo:odoo


aws sts get-caller-identity
{
    "UserId": "946524579141",
    "Account": "946524579141",
    "Arn": "arn:aws:iam::946524579141:root"
}

fs-0818ea83458842b6d
aws efs create-mount-target --file-system-id fs-0818ea83458842b6d --subnet-id subnet-0836ac1dd53f266d4 --region ap-southeast-3 --security-groups $security_group_id

aws iam create-role   --role-name AmazonEKS_EFS_CSI_DriverRole   --assume-role-policy-document file://"trust-policy.json"

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::946524579141:policy/AmazonEKS_EFS_CSI_Driver_Policy \
  --role-name AmazonEKS_EFS_CSI_DriverRole

  
aws ec2 describe-subnets \
--filters "Name=vpc-id,Values=vpc-08175da7d5ec4c801" \
--query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
--output table

security_group_id=$(aws ec2 create-security-group \
    --group-name MyEfsSecurityGroup \
    --description "My EFS security group" \
    --vpc-id vpc-08175da7d5ec4c801 \
    --output text)
sg-03b7bc8171dc3849b

aws efs create-mount-target \
    --file-system-id fs-0818ea83458842b6d \
    --subnet-id subnet-0ae7788793517fd3b  \
    --security-groups $security_group_id

vpc_id=$(aws eks describe-cluster \
    --name cluster-dev \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)

cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids vpc-08175da7d5ec4c801 \
    --query "Vpcs[].CidrBlock" \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id sg-03b7bc8171dc3849b \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range


sg-03b7bc8171dc3849b

file_system_id=$(aws efs create-file-system \
    --region ap-southeast-3 \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)

aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-08175da7d5ec4c801" --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' --region ap-southeast-3 --output table
--------------------------------------------------------------------
|                          DescribeSubnets                         |
+------------------+------------------+----------------------------+
| AvailabilityZone |    CidrBlock     |         SubnetId           |
+------------------+------------------+----------------------------+
|  ap-southeast-3c |  172.31.16.0/20  |  subnet-0ae7788793517fd3b  |
|  ap-southeast-3a |  172.31.0.0/20   |  subnet-0836ac1dd53f266d4  |
|  ap-southeast-3b |  172.31.32.0/20  |  subnet-02627c6a8bd1ab035  |
+------------------+------------------+----------------------------+

 aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --region ap-southeast-3 --output text
 fs-0818ea83458842b6d

 
 sudo mount -t efs -o tls fs-0818ea83458842b6d:/ /mnt/efs
 sudo mount -t efs -o tls,accesspoint=fsap-0a4bf8aec1aca8809 fs-0818ea83458842b6d /mnt/efs

 arn:aws:elasticfilesystem:ap-southeast-3:946524579141:access-point/fsap-0a4bf8aec1aca8809


 eksctl delete nodegroup --cluster=cluster-dev --name=node-gr-dev


