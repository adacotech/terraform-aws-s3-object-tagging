# terraform-aws-s3-object-tagging
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

A terraform module that attaches the specified tag to the object uploaded to the s3 bucket.

## Usage

```hcl
module "s3_object_tagging" {
  source  = "adacotech/s3-object-tagging/aws"
  version = "0.1.0"

  s3_bucket_name                    = "unique-name"
  suffix                            = ".png"
  prefix                            = "images/"
  tags                              = {
    foo = "bar"
  }
}
```


## Roadmap

- TBD


## Contributors

Everybody is welcome to contribute ideas and PRs to this repository. We don't have any strict contribution guidelines. Follow your best common sense and have some patience with us if we take a few days to answer.
