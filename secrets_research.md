#### Managing secrets on Kubernetes
#### Task:
https://trello.com/b/P5pkQiy0/opsfleet-exampletasks
#### Research:

Here are two most obvious options for storing kubernetes secrets for EKS clusters:
 1. [Bitnami sealed secrets](https://github.com/bitnami-labs/sealed-secrets)
 2. [Godaddy kubernetes-external-secrets](https://github.com/godaddy/kubernetes-external-secrets)

Both of them require controller deployed to your kubernetes cluster. 
It's easy to install and support any of these applications. 
Each of the application uses Custom Resource to follow it and create a secret object. 
It similar to kubernetes operators which use rules described in Custom Resources 
to create kubernetes resources.
However, the applications are completely different and have different 
ideologies for storing and managing secrets.


Let's consider each of them closer.

##### Sealed Secrets

You store encrypted secrets(sealed secrets) in your *git repository*.
Obviously this is the best option if you follow GitOps methodology and use Flux,
for example. 
Secret may be decrypted  using the key stored in your cluster.

Pros:
 1. Built-in key rotation system
 2. Fits perfectly into the GitOps methodology as store secrets in git repo.
 3. It has scopes, it's possible to limit using secrets by namespaces.
 (it won't be possible to reuse the same secret in another namespace if you limit the scope)
 

Cons: 
 1. Requires `kubeeseal` binary installed
 2. If you didn't store all rotated keys, you would have to seal secrets again 
 in case you redeployed cluster (take it into account developing disaster recovery plan) 
 3. To differentiate access to secrets for access groups, you would have to create different git repositories
 4. Requires additional actions in case of secret updated.
 (requires pod restart if a secret isn't mounted as a file). It's easy to implement 
 pod restart changing some ENV variable, SECRET_UPDATE_DATE, for example. 


Pros/Cons(Facts): 
 1. The maximum scope level - cluster-wide, those you can't use the same secrets on different clusters.
 2.  Secrets can't be changed by someone w/o access to your cluster.(You can't seal secret w/o access to kubeseal server)
 
 
##### Kubernetes External Secrets

Pros: 
 1. Store secrets using AWS System Manager (Fits perfectly for terraform)
 2. AWS System Manager is perfect to  differentiate access by environments, as 
 it allows you using access policies with different depth to ARNs of AWS SM 
 objects( `arn:aws:secretsmanager:*:*:secret:/qa/*`
 or `arn:aws:secretsmanager:*:*:secret:/qa/databases/*` )
 3. You don't need to perform additional actions to apply  secret that updated
  to your cluster, as controller constantly polls AWS SM 

 
Cons:
 1. It's necessary to maintain key rotation separately using AWS KMS
 2. Requires additional actions in case of secret updated.
 (requires pod restart if a secret isn't mounted as a file)
 
 
Pros/Cons(Facts):  
 1. You are able to use the same secrets for any cluster/ec2 instance/lambda/any 
 other service which has access to it. It's awesome if you are willing to have 
 the only source of truth for all you terraform layers. 
 
 
##### Alternatives
Here are two simple options to don't store plain text data in git repos:

1. If you use ansible jinja2 as a template engine for your YAMLs, you 
will also be able to use ansible-vault to store your secrets encrypted in a git repo.

2. It's also possible to use (`pass`)[https://www.passwordstore.org/] 
to store encrypted secrets in a git repo. It allows you to share access to these secrets
using GPG keys. 


##### Conclusion:


There is no one correct answer in choosing the best way to manage kubernetes secrets.
Each case is individual and it may happen some benefits is more suitable in one case
but doesn't match  criteria for another case. 
For me, the choice comes down to the only one condition for this particular test case:
if you implement GitOps go with Sealed Secrets, if not, use External Secrets.
