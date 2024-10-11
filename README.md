# AWS North Project

## Prerequisites

1. Install Task:
   - macOS: `brew install go-task`
   - Linux: `sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin`
   - Windows: `choco install go-task`

2. Install Terraform (1.9.x):
   - Visit https://www.terraform.io/downloads.html and follow instructions for your OS

3. Install AWS CLI:
   - Visit https://aws.amazon.com/cli/ and follow instructions for your OS

## Clone the project

```
git clone https://github.com/ASRagab/aws-terraform-project.git
cd aws-terraform-project
```

## Authentication
To authenticate using AWS SSO for the Terraform admin profile, follow these steps:

1. Configure AWS SSO:
   - Run `aws configure sso`
   - Follow the prompts to set up your SSO session (you can get the url and other credential materials from 1Password)
   - When asked for a profile name, enter `north`

2. Use the SSO profile:
   - To use this profile for AWS CLI commands, prefix them with `AWS_PROFILE=north`
   - For Terraform, set the AWS_PROFILE environment variable:
     ```
     export AWS_PROFILE=north
     ```
   - Consider using [direnv](https://direnv.net/) for automatic environment variable loading
   - Also consider a tool like [aws-sso-cli](https://github.com/synfinatic/aws-sso-cli) for easier SSO management

3. Verify the configuration:
   - Run `aws sts get-caller-identity` to confirm you're using the correct profile

Note: Ensure you have the necessary permissions in AWS SSO to perform Terraform operations.

## Setup

Run `task tfp` to initialize and plan the terraform.
