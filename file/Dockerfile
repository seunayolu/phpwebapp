FROM docker:latest
RUN mkdir -p /home/jenkins/.docker
RUN adduser -D -u 1000 jenkins
RUN chown -R jenkins:jenkins /home/jenkins/.docker
USER jenkins