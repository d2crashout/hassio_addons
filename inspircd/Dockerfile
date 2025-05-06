FROM inspircd/inspircd-docker:latest

# Copy the run.sh and defaults, setting the exec bit in one go:
COPY --chmod=0755 defaults/ /defaults/
COPY --chmod=0755 run.sh    /run.sh

ENTRYPOINT ["/run.sh"]
