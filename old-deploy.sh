#!/bin/bash
START=$(date)
# DUMMY - will become deploy script

# Source Files - main environment and errors
test -f '/var/www/html/pub/templates/environment-files/main-environment-file-template' && . '/var/www/html/pub/templates/environment-files/main-environment-file-template'
. "${SCRIPTSDIR}"/errors.sh
############ FUNCTIONS ############
logger()
{
echo $1 >> ${VMLOG}
}
usage()
{
"${SCRIPTSDIR}"/usage.sh 
}
runStep()
{
"${SCRIPTSDIR}"/$1 -f "${VM_ENV_FILE}"
if [ "${?}" == 0 ]; then
  logger "$(date) - ${1} for ${VMNAME} completed successfully"; else
  logger "$(date) - ${1} for ${VMNAME} failed"
  abort
  exit 1
fi
}
list_groups()
{
"${SCRIPTSDIR}"/listgroups.sh
}
abort()
{
"${SCRIPTSDIR}"/abort-clean.sh -n "${VMNAME}"
}
deploy()
{
ansible-playbook "${PLAYBOOK}"
}
finish()
{
echo "ansible-playbook ${RECONFIGUREPLAYBOOK}" > "/var/www/html/pub/workdir/reconfigure-${VMNAME}"
echo 'ansible-playbook /usr/local/ansible/finish-deployment.yml -l "'${VMNAME}'"' >> "/var/www/html/pub/workdir/reconfigure-${VMNAME}"
echo "rm -f /var/www/html/pub/workdir/reconfigure-${VMNAME}" >> "/var/www/html/pub/workdir/reconfigure-${VMNAME}"
'/bin/at' now +30 minutes -f "/var/www/html/pub/workdir/reconfigure-${VMNAME}"
}
# Display usage if no options or help chosen
if [ $# -eq 0 ] || [ $(echo "${1}" | egrep -i "(\-h|help)" | wc -l) -gt 0 ]; then
  usage
  exit 0
fi

if [ $(echo "${1}" | egrep -i "(\-l|legacy)" | wc -l) -gt 0 ]; then
. /usr/bin/deploy-redhat-vm-legacy
exit 0
fi

# Exit if required parameters are not met
validate()
{
if [ -z "${VMNAME}" ]; then
no-name
abort
fi

if [ -z "${ANNOTATION}" ]; then
no-annotation
abort
fi

if [ -z "${SECONDARYSUPPORTGROUP}" ]; then
no-group
abort
fi
}
################################### Main Steps ###################################
# Set Environment and then Log whether it was successful or not
. "${SCRIPTSDIR}"/set-env.sh
if [ "${?}" == 0 ]; then
  logger "$(date) - Set Environment for ${VMNAME} completed successfully"; else
  logger "$(date) - Set Environment for ${VMNAME} failed"
  exit 1
fi
# Validate required options are set
validate
# Check that the name of VM is valid
runStep "check-vm-name.sh"
# Get an IP address from subnet and assign to VM in ENV file
runStep "get-network.sh"
# Verify settings and confirm
runStep "verify.sh"
# Create certificates
#runStep "makecert.sh"
test -f "${VM_ENV_FILE}" && . "${VM_ENV_FILE}"
/var/www/html/pub/scripts/make-csr-with-alt-names -n ${VMNAME} -A "${VMNAME}.corp.wan" -a ${VMNAME}
if [ "${?}" == 0 ]; then
  logger "$(date) - Make Cert for ${VMNAME} completed successfully"; else
  logger "$(date) - Make Cert for ${VMNAME} failed"
  exit 1
fi
# Make the Firstboot Script
runStep "make-firstboot-script.sh"
# Build the Firstboot RPM
runStep "build-firstboot-rpm.sh"
# Create the kickstart file
. "${SCRIPTSDIR}"/create-kickstart.sh
# Create the ISO
runStep "create-iso.sh"
# Launch Playbook to deploy system
deploy
# Schedule at job to reconfigure and run finish-deploy in 30 minutes
finish
# Setting to Success temporarily
SUCCESS="Yes"
echo ${VMNAME} >> ${ANSIBLE_HOST_FILE}${ANSIBLE_ENV_FILE}
echo '#!/bin/bash' > "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
echo '' >> "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
echo 'echo "'${VMNAME}'" >> "'${ANSIBLE_HOST_FILE}'""'${ANSIBLE_ENV_FILE}'"' >> "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
echo 'exit 0' >> "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
echo '' >> "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
cat "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}" | ssh -q sl-uansible1t /bin/bash
rm -f "/var/www/html/pub/workdir/update-ansible-hosts-file-${VMNAME}"
logger "Finished Successfully"
# If the whole build is not successful than run the abort script
if [ -z "${SUCCESS}" ]; then
abort
fi

# If for some reason the script has not exited, exit now
exit 0
