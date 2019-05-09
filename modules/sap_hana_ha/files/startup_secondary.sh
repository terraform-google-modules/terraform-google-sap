#!/bin/bash

curl -s https://storage.googleapis.com/sapdeploy/dm-templates/sap_hana_ha/startup_secondary.sh >> startup_secondary.sh
chmod +x startup_secondary.sh
source startup_secondary.sh

# Verifying HANA HA deployment

df -h

#su - [SID]adm

HDB info
