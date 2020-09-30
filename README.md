# eks-test

***
#### Prerequirements:

This guide assumes that you have installed and configured such tools as
`aws-cli`, `kubectl`, `aws-iam-authenticator`.
If not, you can find use aws guide to install these tools:
 - https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
 - https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
 - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
 
You will also need `teraform` version 0.12  binary installed:
 - https://releases.hashicorp.com/terraform/0.12.29/

As for AWS account this will require admin level privileges.

From the AWS infrastructure perspective, we will only need existing VPC 
with an Internet Gateway attached.
***
#### Description:

This repo contains terraform modules necessary to satisfy this task
requirements: https://trello.com/c/BRZAmGak/2-automate-eks-cluster-setup-on-aws
You can find the modules in `terraform/modules` directory.

The repo also contains 2 separate terraform layers:
 - `terraform/eks-test` to deploy EKS cluster
 - `terraform/deploy-test` to make aws-cli pod running on the cluster

NOTE: you can ignore these layers and create your own if wiling

***

#### How to test:

##### 1. Deploy EKS cluster

First of all you will need to deploy eks cluster.

Clone the repo and configure some of parameters using template file in
existing layer:
```
git clone git@github.com:admssa/eks-test.git

cd eks-test/terraform/eks-test

terraform/eks-test$ cp local.auto.tfvars.template local.auto.tfvars
```
Then **edit** the newly created file to change the variables and 
apply terraform's code

```
terraform/eks-test$ terraform init --upgrade
terraform/eks-test$ terraform apply
```
And get kubeconfig running command:
```
terraform/eks-test$ source ./get_kubeconfig.sh
```

##### 2. Deploy aws-cli pod to the cluster

Go to deploy-test terraform layer and create tfvars file using template
```
cd eks-test/terraform/deploy-test

terraform/deploy-test$ cp local.auto.tfvars.template local.auto.tfvars
```

Most likely you will only need to change one variable there:
 `test_s3_paths` = [ "mybucket.test/*", "mybucket2.test/some_path/*" ]
Then apply terraform the code:
```
terraform/deploy-test$ terraform init --upgrade
terraform/deploy-test$ terraform apply
```

If everything is fine aws-cli container is up and running.
You can check it using command from source file:

```
$ eks-test get pods
NAME                            READY   STATUS    RESTARTS   AGE
aws-cli-test-649788658f-74bbs   1/1     Running   0          3m50s
```

Then you should be able to test that aws role is attached to the pod 
using serviceaccount:
```
 eks-test exec -it $(eks-test get pod -l app.kubernetes.io=aws-cli-test -o jsonpath="{.items[0].metadata.name}") aws sts get-caller-identity
```
or even list your s3 bucket:

```
eks-test exec -it $(eks-test get pod -l app.kubernetes.io=aws-cli-test -o jsonpath="{.items[0].metadata.name}") aws s3 ls s3://your_bucket/
```
***

