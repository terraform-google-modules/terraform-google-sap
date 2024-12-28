# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1](https://github.com/terraform-google-modules/terraform-google-sap/compare/v2.0.0...v2.0.1) (2024-12-28)


### Bug Fixes

* **deps:** Update Terraform validation to v1.1.3 ([#151](https://github.com/terraform-google-modules/terraform-google-sap/issues/151)) ([c8f2b8e](https://github.com/terraform-google-modules/terraform-google-sap/commit/c8f2b8e6cac9a483a47bde4a4452c610a510135d))

## [2.0.0](https://github.com/terraform-google-modules/terraform-google-sap/compare/v1.1.2...v2.0.0) (2024-11-21)


### Features

* Latest sot ([#147](https://github.com/terraform-google-modules/terraform-google-sap/issues/147)) ([c90e2e2](https://github.com/terraform-google-modules/terraform-google-sap/commit/c90e2e2413e49156a9c32968f4672c385da112b4))
* Latest SOT sync of NW, HANA, and S4 templates.  ([#140](https://github.com/terraform-google-modules/terraform-google-sap/issues/140)) ([d103087](https://github.com/terraform-google-modules/terraform-google-sap/commit/d103087e138e4d213ebedc9f16042ca028826d01))


### Bug Fixes

* **deps:** Update Terraform validation to v1.1.1 ([#143](https://github.com/terraform-google-modules/terraform-google-sap/issues/143)) ([ab274a2](https://github.com/terraform-google-modules/terraform-google-sap/commit/ab274a294136f7e6c29e4ceda5d00ccb86ae95e1))
* **deps:** Update Terraform validation to v1.1.1 ([#149](https://github.com/terraform-google-modules/terraform-google-sap/issues/149)) ([febc30d](https://github.com/terraform-google-modules/terraform-google-sap/commit/febc30daafeaabbd1a2fa790c30ad61d8136d1c0))

## [1.1.2](https://github.com/terraform-google-modules/terraform-google-sap/compare/v1.1.1...v1.1.2) (2024-04-11)


### Bug Fixes

* updates for tflint ([#124](https://github.com/terraform-google-modules/terraform-google-sap/issues/124)) ([97adeec](https://github.com/terraform-google-modules/terraform-google-sap/commit/97adeec924b4e3b54b2da1c0d74673dda93fe04a))
* upgraded versions.tf to include minor bumps from tpg v5 ([#112](https://github.com/terraform-google-modules/terraform-google-sap/issues/112)) ([2aaabe1](https://github.com/terraform-google-modules/terraform-google-sap/commit/2aaabe1f99c43d1e47fd4bae72a22d7add9c103c))

## [1.1.1](https://github.com/terraform-google-modules/terraform-google-sap/compare/v1.1.0...v1.1.1) (2022-12-29)


### Bug Fixes

* fixes lint issues and generated metadata ([#74](https://github.com/terraform-google-modules/terraform-google-sap/issues/74)) ([6df49df](https://github.com/terraform-google-modules/terraform-google-sap/commit/6df49df92fac96b22d224a1fdced29a2b9272345))

## [1.1.0](https://github.com/terraform-google-modules/terraform-google-sap/compare/v1.0.0...v1.1.0) (2022-12-02)


### Features

* makes the sap_hana_scaleout example consistent with the other examples ([#70](https://github.com/terraform-google-modules/terraform-google-sap/issues/70)) ([69dea7b](https://github.com/terraform-google-modules/terraform-google-sap/commit/69dea7b523501885e4b547ddd749a6a8d2c806a1))

## [1.0.0](https://github.com/terraform-google-modules/terraform-google-sap/compare/v0.5.0...v1.0.0) (2022-11-18)


### ⚠ BREAKING CHANGES

* adds sap hana modules and examples (#62)

### Features

* adds sap hana modules and examples ([#62](https://github.com/terraform-google-modules/terraform-google-sap/issues/62)) ([b379c7b](https://github.com/terraform-google-modules/terraform-google-sap/commit/b379c7bd3a244af52539972af2813aefc41338e6))
* changes prepare the repository for the new templates. ([#56](https://github.com/terraform-google-modules/terraform-google-sap/issues/56)) ([9d95c22](https://github.com/terraform-google-modules/terraform-google-sap/commit/9d95c227f61c7f7a0cb6143385c417092bb86cc5))
* updates top level readme for v1.0 ([#65](https://github.com/terraform-google-modules/terraform-google-sap/issues/65)) ([223ce64](https://github.com/terraform-google-modules/terraform-google-sap/commit/223ce64d66a5d8e4ed3fa61285f81d71156ff15b))

## [0.5.0](https://www.github.com/terraform-google-modules/terraform-google-sap/compare/v0.4.0...v0.5.0) (2021-06-18)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#36)

### Features

* add Terraform 0.13 constraint and module attribution ([#36](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/36)) ([f97fce9](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/f97fce90bb4a4ad608d0a648142f62cbe5eefdb3))


### Bug Fixes

* Add support for Terraform 0.13 + deployment validation check for NW ([#34](https://www.github.com/terraform-google-modules/terraform-google-sap/issues/34)) ([969ff19](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/969ff1942b7b01e0964598de104d55e1f9206084))


### Miscellaneous Chores

* release 0.5.0 ([f6a6fc9](https://www.github.com/terraform-google-modules/terraform-google-sap/commit/f6a6fc9d45a7493377badc0df8ac0461655c605f))

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
