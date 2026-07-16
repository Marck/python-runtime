# python-runtime: a small, reusable multi-arch base image — python:3.12-slim with
# requests + cryptography preinstalled. Intended for scripts / Kubernetes CronJobs that
# make authenticated HTTPS/API calls without a runtime `pip install` (which fails on
# clusters that restrict egress to PyPI). Consumers provide their own script and command.
FROM python:3.12-slim

LABEL org.opencontainers.image.source="https://github.com/Marck/python-runtime" \
      org.opencontainers.image.description="python:3.12-slim with requests + cryptography preinstalled" \
      org.opencontainers.image.licenses="MIT"

RUN pip install --no-cache-dir \
      'requests==2.32.5' \
      'cryptography==49.0.0' \
 && rm -rf /root/.cache

# No ENTRYPOINT/CMD override — inherits the python base default. Consumers set their own
# command (e.g. a chart's `command: ["python", "/scripts/app.py"]`).
