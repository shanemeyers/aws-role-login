# AWS Role Login Helper

This tool is to help do the AWS Role dance to assume a role in a different
AWS account. Basically this is a container that is based on the AWS CLI image
and includes a helper script do the right role work.

This assumes you already have your `.aws/config` and `.aws/credentials` set
up appropriately on your local machine.

## Usage

An actual usage script is in `wrapper.sh`, passing in two arguments:

*   Profile name
*   MFA code

`wrapper.sh` script is available at: [https://github.com/shanemeyers/aws-role-login/blob/master/wrapper.sh](https://github.com/shanemeyers/aws-role-login/blob/master/wrapper.sh)

NOTE: Make sure to include the leading period (`source`) to enable the script
to loads the final credentials into your current environment. If you don't,
you'll need to copy/paste from the `export` lines that were printed.

```bash
. ./wrapper.sh <profile_name> <mfa_code>
```

### Example

```bash
$ . ./wrapper.sh example 123456
export AWS_ACCESS_KEY_ID=ASIA...
export AWS_SECRET_ACCESS_KEY=Hp...
export AWS_SESSION_TOKEN=IQo...
export AWS_DEFAULT_REGION=us-east-1
```

You can verify the new identity is loaded using the
`aws sts get-caller-identity` command.

Or using the AWS CLI container image:

```bash
docker run \
    --rm \
    -it \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
    -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
    amazon/aws-cli \
    sts get-caller-identity
```

