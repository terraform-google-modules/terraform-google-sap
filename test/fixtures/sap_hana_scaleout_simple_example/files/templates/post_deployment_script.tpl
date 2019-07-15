#!/bin/bash
sudo su -
df -h
sudo su - ${sap_hana_sid}adm
HDB info
sapcontrol -nr 10 -function GetSystemInstanceList
