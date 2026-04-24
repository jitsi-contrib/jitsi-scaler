# Jitsi Scaler

A highly-available Helm chart for deploying Jitsi Meet with multi-shard
horizontal scaling. This repository builds upon
[jitsi-helm](https://github.com/jitsi-contrib/jitsi-helm) to provide a
coordinated architecture for large-scale deployments.

## Overview

Standard Jitsi deployments typically operate as a single shard. Jitsi Scaler
enables horizontal growth by:

- Orchestrating multiple independent Jitsi shards within a single release.

- Managing meeting-room stickiness via an integrated HAProxy layer.

- Synchronizing session tables across HAProxy replicas to ensure seamless
  failover and state consistency.

## Key Features

- **Horizontal Sharding**\
  Add or remove shards to support thousands of concurrent participants across
  independent stacks.

- **Room-Based Persistence**\
  Automatically extracts `url_param(room)` to ensure all participants for a
  specific meeting land on the same backend shard.

- **Proxy State Synchronization**\
  HAProxy instances run in a mesh via the peers protocol, preventing session
  loss or "shard hopping" during pod restarts.

- **Auxiliary Service Fast-Path**\
  Requests for `/etherpad` or `/excalidraw` bypass the stickiness logic for
  immediate delivery to the auxiliary backend, reducing unnecessary processing
  overhead.

## Architecture

The traffic flow is designed for minimal latency and high reliability:

- **Frontend**\
  HAProxy identifies incoming traffic types (meeting vs. auxiliary service).

- **Stick Table**\
  A shared memory space defined in the frontend that tracks room-to-shard
  mappings.

- **Backends**
  - **jitsi_backend**\
    The primary pool of active Jitsi shards where room stickiness is enforced.

  - **aux_backend**\
    A dedicated backend for auxiliary services that do not require meeting-state
    tracking.

## Installation

```bash
# Clone the repository
git clone https://github.com/jitsi-contrib/jitsi-scaler
cd jitsi-scaler

# Update the jitsi-helm dependency
helm dependency update

# Install the chart
helm install jitsi-deployment . -f values.yaml
```

## Configuration

Shards are defined as top-level keys in your `values.yaml`. Use the
`replicaCount` to scale the HAProxy control plane for redundancy.

```yaml
haproxy:
  enabled: true
  replicaCount: 3

# Shard Definitions
shard0:
  enabled: true
shard1:
  enabled: true
```

## Contributing

Contributions are welcome. If you have technical improvements for the HAProxy
logic, shard orchestration, or scaling efficiency, please open an issue or a
pull request.
