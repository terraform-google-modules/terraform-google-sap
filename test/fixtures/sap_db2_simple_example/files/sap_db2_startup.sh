#!/bin/bash
curl -s https://storage.googleapis.com/sapdeploy/dm-templates/sap_db2/startup.sh >> startup.sh
chmod +x startup.sh
source startup.sh
