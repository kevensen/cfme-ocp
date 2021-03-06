#
# Description: This method updates the service provisioning status
# Required inputs: status
#

prov = $evm.root['service_template_provision_task']
service = prov.destination

# Get status from input field status
status = $evm.inputs['status']

$evm.instantiate("/POC/Containers/Methods/DeleteProject")
service.remove_from_vmdb
# Update Status for on_entry,on_exit
if $evm.root['ae_result'] == 'ok' || $evm.root['ae_result'] == 'error'
  prov.message = status
end

$evm.root['ae_result'] = 'error'
prov.miq_request.deny("admin", prov.message)
exit MIQ_ERROR
