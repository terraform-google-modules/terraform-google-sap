#! /bin/bash
#
#
#

#stdlib::info 'Starting custom startup script'

# Verifying file systems
#stdlib::cmd df -h
df -h

#stdlib::cmd su - ${sap_hana_sid}adm

#stdlib::cmd HDB info

#stdlib::info 'Finishing custom startup script'