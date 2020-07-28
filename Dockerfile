ARG AWS_VERSION
FROM amazon/aws-cli:${AWS_VERSION}

RUN yum clean metadata \
    && yum install -y jq \
    && yum clean all

COPY aws-role-login.sh /bin/aws-role-login.sh

ENTRYPOINT ["/bin/aws-role-login.sh"]
