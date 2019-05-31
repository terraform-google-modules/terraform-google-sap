#! /bin/bash

sudo su -
df -h
sudo su - ${sap_hana_sid}adm
HDB info