# Dev Instructions

## Setup Terraform Backend Configuration

Update your backend conf for the terraform state. (Update values)
```bash
cp backend.conf.tpl backend.conf
```

Set your environment variables for the slack secrets. (Update values)
```bash
cp .env.tpl .env
```

Install requirements and load environment variables.
```bash
make init
```

Build and Deploy Resources
```bash
make all
```

## Setup A Slack App

1. Create a slack app in your workspace
