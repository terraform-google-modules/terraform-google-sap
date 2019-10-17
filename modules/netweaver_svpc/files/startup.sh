#!/bin/bash
curl -s https://storage.googleapis.com/sapdeploy/dm-templates/sap_nw/startup.sh >> startup.sh
chmod +x startup.sh
source startup.sh
