#!/bin/bash

if [ -z "$2" ] ; then
    echo "Need profile_name and MFA code"
    echo "<profile_name> <mfa_code>"
    echo
else

    TMP1=`mktemp`

    source_profile=$(aws --profile $1 configure get source_profile)
    mfa_arn=$(aws --profile $1 configure get mfa_serial)
    role_arn=$(aws --profile $1 configure get role_arn)
    region=$(aws --profile $1 configure get region)
    username=$(echo $mfa_arn | sed -e 's#.*/##')

    aws --profile $source_profile sts get-session-token --serial-number $mfa_arn --token-code $2 > $TMP1
    if [ $? != 0 ] ; then
        exit 1
    fi

    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $TMP1)
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $TMP1)
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $TMP1)

    TMP2=`mktemp`
    aws sts assume-role --role-arn $role_arn --role-session-name $username --duration-seconds 3600 > $TMP2
    if [ $? != 0 ] ; then
        exit 1
    fi

    echo 'export AWS_ACCESS_KEY_ID='$(jq -r '.Credentials.AccessKeyId' $TMP2)
    echo 'export AWS_SECRET_ACCESS_KEY='$(jq -r '.Credentials.SecretAccessKey' $TMP2)
    echo 'export AWS_SESSION_TOKEN='$(jq -r '.Credentials.SessionToken' $TMP2)
    echo 'export AWS_DEFAULT_REGION='$region

    rm -f $TMP1 $TMP2
fi
