# Build from latest LTS version
FROM jenkins/jenkins:lts-alpine
LABEL "github-url"="https://github.com/gtarnaras/jenkins-automation"

ARG httpProxy
ARG noProxy

ENV HTTPS_PROXY=${httpProxy} \
    https_proxy=${httpProxy} \
    HTTP_PROXY=${httpProxy} \
    http_proxy=${httpProxy} \
    ftp_proxy=${httpProxy} \
    FTP_PROXY=${httpProxy} \
    NO_PROXY=${noProxy} \
    no_proxy=${noProxy}

# Packages
USER root
COPY /setup/packages.txt /var/tmp/packages.txt
RUN apk update && apk add $(cat /var/tmp/packages.txt)
USER jenkins

# Jenkins plugins
COPY /setup/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Configure Git
RUN \
  git config --global push.default simple && \
  git config --global user.name "Jenkins" && \
  git config --global user.email jenkins@example.com

# Copy files needed in the container
COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/
COPY setup/healthchecks/healthcheck.js /usr/share/jenkins/
COPY setup/seed-job/ /usr/share/jenkins/ref/jobs/seed-job
COPY setup/scriptApproval.xml.override /usr/share/jenkins/ref/scriptApproval.xml.override
COPY setup/compute-seed-job-hash.sh /tmp/

# Pre-approve the seed job
RUN /tmp/compute-seed-job-hash.sh /usr/share/jenkins/ref/jobs/seed-job/workspace/job.groovy.override /usr/share/jenkins/ref/scriptApproval.xml.override

# Healthchecks
HEALTHCHECK --interval=12s --timeout=12s --start-period=30s CMD node /usr/share/jenkins/healthchecks.js

# Ports
EXPOSE 8080