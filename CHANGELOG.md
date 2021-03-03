# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

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
