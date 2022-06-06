#!/bin/bash

# if [ "$#" -ne 1 ]; then
#     echo "Illegal number of parameters"
# fi

COMMAND=$1

if [ "$COMMAND" = "apply" ]; then
  echo "Terraform Apply"
  terraform apply -auto-approve -var-file=dev.tfvars.json
elif [ "$COMMAND" = "destroy" ]; then
  echo "Terraform Destroy"
  terraform destroy -auto-approve -var-file=dev.tfvars.json
elif [ "$COMMAND" = "ansible" ]; then
  echo "Apply Ansible Playbook"
  PUBLIC_IP="$(terraform output public-ip-server)"
  ansible-playbook --ssh-extra-args "-F server_ssh_config" -i ,test-server ansible-playbook.yaml
  SSH_KEY_FILE="/home/aldan/Documents/Projects/Training/ionos-training/test-id-rsa"
  #ansible-playbook --private-key $SSH_KEY_FILE -u root -i $PUBLIC_IP, ansible-playbook.yaml
  #echo $PUBLIC_IP
elif [ "$COMMAND" = "connect" ]; then
  ssh -F server_ssh_config test-server
else
  echo "Invalid command \"$COMMAND\". Expected either \"apply\", \"destroy\", \"ansible\" or \"connect\"."
fi

