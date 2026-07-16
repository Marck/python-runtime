# python-runtime

A small, reusable **multi-arch** container image: `python:3.12-slim` with
[`requests`](https://pypi.org/project/requests/) and
[`cryptography`](https://pypi.org/project/cryptography/) preinstalled.

Intended as a runtime for scripts and Kubernetes CronJobs that make authenticated
HTTPS / API calls **without a runtime `pip install`** — which is slow on every start and
fails outright on clusters that restrict egress to PyPI.

## Image

- `ghcr.io/marck/python-runtime:1.0.0` (and `:latest`) — **public**, no pull secret needed
- Platforms: `linux/amd64`, `linux/arm64`

## Contents

| package | version |
|---|---|
| python | 3.12-slim |
| requests | 2.32.5 |
| cryptography | 49.0.0 |

## Usage

Run a script mounted at runtime (e.g. from a Kubernetes ConfigMap):

```yaml
image: ghcr.io/marck/python-runtime:1.0.0
command: ["python", "/scripts/app.py"]
```

Or extend it in your own image:

```dockerfile
FROM ghcr.io/marck/python-runtime:1.0.0
COPY app.py /app/app.py
CMD ["python", "/app/app.py"]
```

## Build / publish

CI ([`.github/workflows/build.yml`](.github/workflows/build.yml)) builds and pushes both
architectures on any change to the `Dockerfile`, and on manual dispatch. To bump a
dependency, edit the pinned versions in the [`Dockerfile`](Dockerfile) and push to `main`.

Locally (podman, multi-arch):

```bash
podman build --platform linux/amd64,linux/arm64 \
  --manifest ghcr.io/marck/python-runtime:1.0.0 -f Dockerfile .
podman manifest push --all ghcr.io/marck/python-runtime:1.0.0 \
  docker://ghcr.io/marck/python-runtime:1.0.0
```
