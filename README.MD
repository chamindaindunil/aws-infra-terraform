# Terraform aws stack    

Provision AWS stack including k8s cluster using terraform HCL. VPC module supports both public and private subnet mode.   

* EKS
* RDS
* ElastiCache *
* S3
* ACM
* Cloudfront

## Usage

* Make sure AWS credentials are config using aws cli.
* Fill with necessary variables in `tfvars` file.
* Estimate cost calculation using infracost.
```sh
make infracost
```
* Run the terraform to create aws stack using Make.
```sh
make plan
make auto_apply
```
* OR Using reguler terraform cli.
```
terraform init
terraform apply
```

* To append kubeconfig file default path
```
aws eks update-kubeconfig --name <CLUSTER_NAME>
```


* vpc endpoint
* Protect cloudfront to alb (https://aws.amazon.com/blogs/security/how-to-automatically-update-your-security-groups-for-amazon-cloudfront-and-aws-waf-by-using-aws-lambda/)  
* Use API Gateway http with private link 
* CF -> /* api

## Dev allocated subnet 

* Public-subnet (ALB) | 172.29.159.224/27
* EKS-Private-subnet01 | 172.29.128.0/25
* DB-Private-subnet01 | 172.29.128.128/27


## Changeset

Changes the approch assuming VPC & subnet are created manually

* Get the current id (vpc & subnet)
* remap the outputs with new subnet
* remap vpc private endpoint with new subnet
* update the secgroup with new cidr
 