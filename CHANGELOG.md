# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [0.2.5](https://github.com/skolobov/mkrel/compare/v0.2.4...v0.2.5) (2022-05-26)

### [0.2.4](https://github.com/skolobov/mkrel/compare/v0.2.3...v0.2.4) (2022-05-26)


### Features

* add --skip-backup and --skip-both flags ([6b428c4](https://github.com/skolobov/mkrel/commit/6b428c4980c74c6a79a7f81dc28f92793af59118))


### Bug Fixes

* upgrade standard-version from 9.1.1 to 9.3.1 ([ac0207b](https://github.com/skolobov/mkrel/commit/ac0207bb3952ae071b2484f232a792d5c8bda8d8))

### [0.2.3](https://github.com/skolobov/mkrel/compare/v0.2.2...v0.2.3) (2021-03-03)

### [0.2.2](https://github.com/skolobov/mkrel/compare/v0.2.1...v0.2.2) (2021-03-03)


### Features

* add -s/--start-new to start a new release right away ([003feff](https://github.com/skolobov/mkrel/commit/003fefff5091e67aa533061c639d6da93f617cab))
* add shorter -m version of --skip-migration flag ([1f3376f](https://github.com/skolobov/mkrel/commit/1f3376f0217d9249489fd530552d60d5b3eb0f4a))
* automatically add standard-version as devDependency if needed ([9a65ace](https://github.com/skolobov/mkrel/commit/9a65ace934010a668739d3e4033b50f3590b842d))


### Bug Fixes

* check for any unfinished releases before starting a new one ([e97c8ab](https://github.com/skolobov/mkrel/commit/e97c8abe16081b52a2834418858dc146c29bc774))
* don't try to install standard-version every time we invoke it ([12b83e8](https://github.com/skolobov/mkrel/commit/12b83e84370b93508c9fdcc936deec02f83dba96))
* explicitly specify subcommand as $1 would have different value inside a function ([4b4a6a9](https://github.com/skolobov/mkrel/commit/4b4a6a9adab1673e4527d9dd9c58c1537eef0d03))
* remove local release branch after finishing it ([0692dcd](https://github.com/skolobov/mkrel/commit/0692dcde03e36e9519810c5b16c79c3f59fdf4c7))

### [0.2.1](https://github.com/skolobov/mkrel/compare/v0.2.0...v0.2.1) (2021-03-03)


### Bug Fixes

* remove broken case/esac syntax ([79355f9](https://github.com/skolobov/mkrel/commit/79355f9f7d330268e7b722aee263aa285ff879d0))
* use base script name only in usage messages ([ceb5a74](https://github.com/skolobov/mkrel/commit/ceb5a746ecee052090d569b9584f34bbc09072c1))

## 0.2.0 (2021-03-03)


### Features

* `release start` now creates a release candidate ([6fccf4c](https://github.com/skolobov/mkrel/commit/6fccf4c66c7289c4a35cb3995e00e1bb3352d209))
* implement --skip-migration flag to `hotfix finish` ([8db7a1f](https://github.com/skolobov/mkrel/commit/8db7a1f9a8dcb09db5704b0f250efd57efbed0a0))
* implement --skip-migration flag to `release finish` ([68b4676](https://github.com/skolobov/mkrel/commit/68b4676903bee8b4c406a90069ac50f9bf7b16e2))
* implement -h and --help parameters to `release` ([6dce5d6](https://github.com/skolobov/mkrel/commit/6dce5d6fc437599bc8d5bf5748627dcb1b23e073))
* implement hotfix start/finish using standard-version ([1d37d64](https://github.com/skolobov/mkrel/commit/1d37d643c0cb9e86f6dfdc3176622dcb0d820791))
* replace unleash with standard-version in release start/finish ([cf0f0f8](https://github.com/skolobov/mkrel/commit/cf0f0f8cb9caba464c603ffaa31e2c936b1fc212))
* use --follow-tags when pushing master/develop branches to origin ([86fd9e4](https://github.com/skolobov/mkrel/commit/86fd9e42174112d30c3fe8a9a275a0295f6b0927))


### Bug Fixes

* don't install Unleash anymore ([c62131a](https://github.com/skolobov/mkrel/commit/c62131a0059587e50fa2bd09980a7cce69580252))
* don't try to install Homebrew anymore ([55077ec](https://github.com/skolobov/mkrel/commit/55077ecf8c2684dd99106d85bb9743e5d4767516))
* just exit with error instead of trying to install Git-Flow ourselves ([bfd17a7](https://github.com/skolobov/mkrel/commit/bfd17a77cf4a4a36943a0e77cc0ebfe11baf2891))
* update error messages to match current command-line syntax ([2823a0a](https://github.com/skolobov/mkrel/commit/2823a0a5244df1427c378dd36d40c228eecd15d0))
* update hotfix error messages to match current syntax ([61996e4](https://github.com/skolobov/mkrel/commit/61996e45faed9497d0bb8a452883ca6b8233693e))
