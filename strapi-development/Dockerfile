FROM elestio/strapi-development:v5.12.6

# Copy default config + src into a bootstrap folder
RUN mkdir -p /opt/bootstrap-src /opt/bootstrap-config && \
    cp -r /opt/app/src/* /opt/bootstrap-src/ && \
    cp -r /opt/app/config/* /opt/bootstrap-config/

# Add our own entrypoint wrapper
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]