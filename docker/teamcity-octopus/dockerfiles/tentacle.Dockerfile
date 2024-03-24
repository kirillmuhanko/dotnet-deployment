FROM octopusdeploy/tentacle:8.1.1153

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "-c", "/scripts/configure-tentacle.sh && /scripts/run-tentacle.sh"]

# Multi-container application deployment process:

# 1. TeamCity (TC):
#    - Delivers a ZIP archive containing your ASP.NET 6.0 application to Octopus Deploy.

# 2. Octopus Deploy:
#    - Transfers the ZIP archive to Tentacle.

# 3. Tentacle (**this Dockerfile**):
#    - Unzips the archive to a shared volume.

# 4. ASP.NET 6.0 container:
#    - Mounts the shared volume, gaining access to the unzipped application files.
#    - Runs the ASP.NET 6.0 web application.
