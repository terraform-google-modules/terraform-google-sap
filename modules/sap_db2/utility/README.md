# GCP Virtual IP extension

Please refer to
https://cloud.google.com/solutions/sap/docs/sap-ibm-db2-ha-deployment-guide for
the primary documentation.

Two versions of the helper script for managing a virtual IP in the context of
IBM Tivoli System Automation for Multi-Platforms:
*  gcp_floating_ip.sh - legacy script that provides basic route or alias IP
   based floating IP support in conjunction with HADR configurations with Db2 on
   Linux in a standard VPC.
*  gcp_floating_ip_svpc.sh - updated version of legacy script that provides
   route or alias IP based floating IP support in conjunction with HADR
   configurations with Db2 on Linux in a Shared VPC configuration on Google
   Cloud.

For Db2 version 11.5.8 or later, customers should instead use IBM's provided
integrated Pacemaker solution for Db2.

## Changelog

10MAY2024: Relocate legacy files. Add version of helper script that also
supports a Shared VPC configuration
25OCT2019: Add additional logging options with inclusion and checking if eth0
alias assignment already exists to avoid RTNETLINK File exists warning.
