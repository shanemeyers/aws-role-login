#!/bin/bash
AWS_VERSION="2.11.1"

docker build --build-arg AWS_VERSION=${AWS_VERSION} -t shanemeyers/aws-role-login:latest .
docker push shanemeyers/aws-role-login:latest
docker tag shanemeyers/aws-role-login:latest shanemeyers/aws-role-login:$AWS_VERSION
docker push shanemeyers/aws-role-login:$AWS_VERSION
