
![build-status](https://github.com/Wefactorit/docker-ci-img/workflows/build-workflow/badge.svg)  ![publish-status](https://github.com/Wefactorit/docker-ci-img/workflows/publish-workflow/badge.svg)

# Local development

Use `make` command to build a local `test` version of the container
```
make build
```

# Tools versions and upgrades

All tools' version are managed in the `Makefile` file. Change accordingly.
The `FROM` image version is **pinned** (in the `Dockerfile`) to ensure being able to have consistent builds.

# Default tools versions

----------------------
| Name | Description |
|------|:-------------:|
| ANSIBLE | 2.9.6 |
| TERRAFORM | 0.12.24 |
| AWS CLI | 1.18.46 |
| AZ CLI | 2.5.1 |

# Container security

Containers security checks are made by [trivy](https://github.com/aquasecurity/trivy)

Currently pipeline will failed only if a CRITICAL issue is raised by [trivy](https://github.com/aquasecurity/trivy)

# Release

Tag the repo, the CI will do the rest
```
git tag 1.0.0
git push --tags
```