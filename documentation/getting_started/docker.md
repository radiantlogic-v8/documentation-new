---
title: Docker
description: Docs about docker
---

# Docker
Radiant Logic provides preconfigured images of RadiantOne in Docker containers. Once deployed, the product is entirely operable. The containers are preconfigured to interoperate with other containers in the stack. 

## Docker Compose
Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

Compose works in all environments: production, staging, development, testing, as well as CI workflows. Samples can be found in [Radiant Logic's Git Hub Site](https://github.com/radiantlogic-devops/docker-compose).

These samples provide a starting point for how to integrate different services using a Compose file and to manage their deployment with Docker Compose.

<mark>Note: The following samples are intended for use in local development environments such as project setups, tinkering with software stacks, etc. These samples are not supported for production environments.</mark>

### Getting started
These instructions guide you through the bootstrap phase of creating and deploying samples of containerized RadiantOne deployments with Docker Compose.

#### Prerequisites
1. Install Docker and Docker Compose.
   * Windows or macOS: [Install Docker Desktop](https://www.docker.com/get-started)
   * Linux: [Install Docker](https://www.docker.com/get-started) and then [Docker Compose](https://github.com/docker/compose)
2. Download samples from the [Radiant Logic Git Hub](https://github.com/radiantlogic-devops).

#### Running a sample
The root directory of each sample contains the `docker-compose.yaml` which describes the configuration of service components. All samples can be run in a local environment by going into the root directory of each one and executing:

```
docker-compose up -d
```

Check the README.md of each sample to get more details on the structure and what is the expected output. 

To stop and remove all containers of the sample application run:

```
docker-compose down
```

