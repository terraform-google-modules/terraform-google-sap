#!/bin/bash
curl -s https://storage.googleapis.com/sapdeploy/dm-templates/sap_emptyha/startup_secondary.sh >> startup_secondary.sh
chmod +x startup_secondary.sh
source startup_secondary.sh
