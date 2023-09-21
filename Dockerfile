FROM amazon/aws-cli:latest

RUN yum clean metadata \
    && yum install -y jq \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY aws-role-login.sh /bin/aws-role-login.sh

ENTRYPOINT ["/bin/aws-role-login.sh"]
