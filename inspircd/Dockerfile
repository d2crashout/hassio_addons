# 1. Base from the official InspIRCd image
FROM inspircd/inspircd-docker:latest

# 2. Copy in your default config and startup script
COPY defaults/ /defaults/
COPY run.sh /run.sh
RUN chmod +x /run.sh

# 3. Use your run.sh as the container entrypoint
ENTRYPOINT [ "/run.sh" ]