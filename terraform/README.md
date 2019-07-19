# Terraform

> Terraform enables you to safely and predictably create, change, and improve infrastructure.   

* https://www.terraform.io/ 

Terraform breaks down to 4 major concepts: writing infrastucture as code, planning changes to the environment, applying those changes in a repeatable way, and the ability to also delete and cleanup what it created.

Outside of pure exploritory testing, we will be using Terraform to track and manage all AWS infrastructure for this project. 

In theory this is how simple Terraform is:  

```
$ terraform init # run this once per provider/environment on your computer
# make changes to .tf file(s)
$ terraform plan # goes out to AWS/cloud and creates the tfstate file of the "actual" environment
$ terraform apply # applys changes to the environment based on the plan
$ terraform destroy # if you are done verifying changes or don't need the environment any more, destroy it
```

## Modules
There are many different ways to organize terraform code, but generally it is recommended to use the Modules approach. [Here is a video on different organization structures for terraform.](https://www.youtube.com/watch?v=wgzgVm7Sqlk) 

Modules are logical or technical pieces of a technology "stack" that one can import into thier environment so that the same core functionality is the same in dev and production, while allowing each environment to define key variables to keep scope, cost, and efficincy under tight control.

For example one could have a module for [lamdba](modules/lambda/lambda.tf) or one could have a module for setting up a network, compute cluster, and RDS server for a specific function. It's all in hwo the team understands and views each component of the overall infrasucuture. It can be as complicated or as simple as the team desires. 

we use environments like ['dev'](dev/) or ['prod'](prod/) to import each desired module and set the variables specific to the environmnet within. This can expand or shrink as we see fit. Think of modules like classes in Python and we are building a framework from which any combination of these services can be used in a repeatable way.


## tfstate file and terraform plan
When one executes `terraform plan` it creates a terraform.tfstate file which contains a breakdown of the current environment + changes to be applied. By default this is created locally, but what can happen is as more hands begin to work on the environment is that tfstate can drift and what "you" are planning may not be what another person is able to see. Yes one can play git ping/pong with this file, but what is most recommended is keeping the tfstate file in a shared S3 bucket that can be updated centrally on demand.

Probably one of those things we don't have to solve now, but if we would add more people, it might be necesaary.
[See more here](https://www.terraform.io/docs/backends/)



