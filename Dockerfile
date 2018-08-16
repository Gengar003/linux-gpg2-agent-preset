FROM ubuntu:xenial-20180726

#####
# Load files into the image
#####

COPY docker/files /

#####
# Set up the image
#####

# Add non-root user
RUN useradd -ms /bin/bash ubuntu

# Run setup scripts

COPY docker/installers/ /installers

RUN chmod -R a+x /installers

RUN /installers/apt-get.sh
RUN /installers/permissions.sh

#####
# Image runtime configuration
#####

RUN chmod a+rx /usr/local/bin/entrypoint.sh
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]