# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0](https://www.github.com/terraform-google-modules/terraform-google-sap/compare/v0.3.0...v0.4.0) (2020-07-27)


### Features

* Adding the option public_ip that will allow to disable the external IP ([#16](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/16)) ([52ef304](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/52ef304cb583f64fedf13749ecd37467af4ac01d))
* Adding the option to create instance with a static private IP ([#25](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/25)) ([d8a5752](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/d8a57529bab3caa004cb2017c34e077f56b0d344))


### Bug Fixes

* Repair wrong disk sizes for HANA VMs issue [#18](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/18) ([#23](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/23)) ([9bb69ed](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/9bb69ed3abaafbc069eb18ad0382d9975e499a21))

## [0.3.0](https://www.github.com/terraform-google-modules/terraform-google-sap/compare/v0.2.0...v0.3.0) (2020-05-04)


### Features

* add CMEK support in persistent disks attached to the instances ([#12](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/12)) ([90d2cc6](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/90d2cc644d43c876ddc8a07e3826c6edf7cc816b))


### Bug Fixes

* Avoid instance metadata conflicts after instance setup ([#11](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/11)) ([a5592c2](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/a5592c2f9d56181f3c60df1fd9d138440e7c542a))

## [Unreleased]

### Added

- Added support for [Customer Managed Encryption Keys](https://cloud.google.com/compute/docs/disks/customer-managed-encryption) in persistent disks attached to the instances.

### Changed

- Updated for Terraform 0.12. [#11]
- Updated tests and examples to Google provider 3.13.

### Fixed

- Avoid metadata conflicts after SAP startup script completes. [#11]

## [0.2.0] - 2019-09-10

### Added

- Submodule to deploy NetWeaver. [#2]

### Fixed

- Required VM instance service account roles added to the submodule READMEs. [#4]

## [0.1.0] - 2019-07-04

### Added

- Initial release

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-sap/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-sap/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-sap/releases/tag/v0.1.0
[#2]: https://github.com/terraform-google-modules/terraform-google-sap/pull/2
[#4]: https://github.com/terraform-google-modules/terraform-google-sap/issues/4
[#11]: https://github.com/terraform-google-modules/terraform-google-sap/pull/11
