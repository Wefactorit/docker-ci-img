
![docker-ci-img](https://github.com/Wefactorit/docker-ci-img/workflows/build-workflow/badge.svg)

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
| AWS CLI | 2.0.5 |
| TERRAFORM | 0.12.24 |

# Release

Tag the repo, the CI will do the rest
```
git tag 1.0.0
git push --tags
```

The image name is as follow:
```
<my-org>/<my-repo>/<my-img>:<tag_with_ref>
```