# terraform-google-sap

This module is a collection of multiple opinionated submodules to deploy SAP Products.
Below is the list of available submodules:

- [SAP HANA](./modules/sap_hana/README.md)
- [SAP HANA SVPC](./modules/sap_hana_svpc/README.md)
- [SAP HANA HA](./modules/sap_hana_ha/README.md)
- [SAP HANA HA SVPC](./modules/sap_hana_ha_svpc/README.md)
- [SAP EMPTYHA](./modules/sap_emptyha/README.md)
- [SAP EMPTYHA SVPC](./modules/sap_emptyha_svpc/README.md)
- [NETWEAVER](./modules/netweaver/README.md)
- [NETWEAVER SVPC](./modules/netweaver_svpc/README.md)

## Usage

Each submodules have their own usage documented in the [modules](./modules) folder.
For example, see the [SAP HANA Usage Section](./modules/sap_hana/README.md#Usage).

Functional examples are included in the
[examples](./examples/) directory.

[^]: (autogen_docs_start)

[^]: (autogen_docs_end)

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.11
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.6.0

### Service Account

A service account with the following roles must be used to provision
the resources of each submodule:

- Compute Admin: `roles/compute.admin`

Please refer to the documentation of specific submodules located in the [modules](./modules/) folder for additional requirements for the service account.

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Compute Engine API: `compute.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
