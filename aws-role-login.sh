#!/bin/bash

if ! [ -f /root/.aws/config ] ; then
    echo "ERROR: ~/.aws/config is missing"
    exit 2
fi

if ! [ -f /root/.aws/credentials ] ; then
    echo "ERROR: ~/.aws/credentials is missing"
    exit 3
fi

if [ -z "$1" ] || [ -z "$2" ] ; then
    echo "Need profile_name and MFA code"
    echo "<profile_name> <mfa_code>"
    echo
    exit 1
else

    TMP1=`mktemp`

    source_profile=$(aws --profile $1 configure get source_profile)
    if [ $? != 0 ] ; then
        exit
    fi

    mfa_arn=$(aws --profile $1 configure get mfa_serial)
    role_arn=$(aws --profile $1 configure get role_arn)
    region=$(aws --profile $1 configure get region)
    username=$(echo $mfa_arn | sed -e 's#.*/##')
    duration=$(aws --profile $1 configure get duration_seconds)

    if ! [ -z "$duration" ] ; then
        D="--duration-seconds $duration"
    fi

    aws \
        --profile $source_profile \
        sts assume-role \
        --role-arn $role_arn \
        --role-session-name $username \
        $D \
        --serial-number $mfa_arn \
        --token-code $2 > $TMP1

    if [ $? = 0 ] ; then

        echo 'export AWS_ACCESS_KEY_ID='$(jq -r '.Credentials.AccessKeyId' $TMP1)
        echo 'export AWS_SECRET_ACCESS_KEY='$(jq -r '.Credentials.SecretAccessKey' $TMP1)
        echo 'export AWS_SESSION_TOKEN='$(jq -r '.Credentials.SessionToken' $TMP1)
        echo 'export AWS_DEFAULT_REGION='$region
        echo '# Expiration: ' $(jq -r '.Credentials.Expiration' $TMP1)

        rm -f $TMP1
    fi
fi
