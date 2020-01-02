# deploy-ansible-nonprod
# README file for deploy playbook

#### PLAYBOOKS
deploy.sh - this is the main deployment playbook.  Point it to an inventory file:
ansible-playbook deploy.sh -i inventory
standard-config.yml - this playbook will take an already deployed system (not deployed through deploy.yml) and finish the deployment process bringing it into compliance with cspire standards
test.yml - this playbook is for testing roles when expanding funtionality

#### INVENTORY FILE LAYOUT
## Group [nodes] can be anything, [all], etc you can have multiple groups and deploy one group at a time
## i.e. - ansible-playbook deploy.yml -i inventory-file -l nodes
## VARS - each var is a variable that can be specified.  if not specified defaults will be used which can ## be found at /usr/local/ansible/deploy/roles/vm_deploy/defaults/main.yml
## EXAMPLE
[nodes]
sl-testserv2t ansible_host=10.180.112.89
sl-testserv3t ansible_host=10.180.112.91
sl-testserv4t ansible_host=10.180.112.92
sl-testserv5t ansible_host=10.180.112.94

[nodes:vars]
Group=Billing
NumCPU=4
Memory=8192
Annotation="This is a test billing server"

#### VARIABLES NOTES
## VARS FILES
/usr/local/ansible/deploy/vars
/usr/local/ansible/deploy/roles/vm_deploy/default/main.yml
inventory-file under [GROUPNAME:vars]
## Variables specified in inventory will override the ones in vm_deploy defaults
