# Dev Instructions

## Setup Terraform Backend Configuration

Update your backend conf for the terraform state.

```bash
mv backend.conf.tpl backend.conf
```

Make sure you have an s3 bucket to store your terraform state and update backend.conf to point to this bucket.

Initialize terraform backend
```bash
make tf-init 
```
