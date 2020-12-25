# Consul Config Loader

[![Azure DevOps Build Status][azure-devops-image]][azure-devops-url-main] [![Build Status][travis-image]][travis-url] [![Docker Pulls](https://img.shields.io/docker/pulls/neokeld/consul-config-loader.svg)](https://hub.docker.com/r/neokeld/consul-config-loader/)

A small docker based tool to load Spring Boot and/or Micronaut property files into Consul K/V Store.

## Enabling Spring Boot and Micronaut support

Both Spring Boot and Micronaut frameworks are supported, and by default only Spring Boot is enabled.
To control the compatibility for each framework you should use the following environnement variables: `ENABLE_SPRING` and `ENABLE_MICRONAUT`, with values `true` or `false`.

## Push configuration to Consul

The **consul-config-loader** agent pushes all YAML properties files in the `config/` directory to consul K/V store. It automatically detects when files are added or edited to reload them into Consul.

To use this mode, configure those properties in `bootstrap.yml`:
```
spring:
    cloud:
        consul:
            config:
                format: yaml
                profile-separator: "-"
```
Then run `docker-compose up` to start a Consul server on localhost and and its agent.
You can then access [http://localhost:8500/ui/#/dc1/kv/config/](http://localhost:8500/ui/#/dc1/kv/config/) and watch as your Consul K/V store is synchronised with property files in the `config/` directory.

# ACL security

To maintain security for KV access and service discovery, this config loader expects consul running with ACL enabled, which leads to the presence of a master ACL token (refered to the loader by environment variable MASTER_ACL_TOKEN). This token is used, to **create** a client ACL token (provided by CLIENT_ACL_TOKEN variable), with a default policy and for writing config changes.
The default policy for the client ACL is to permit read to KV and write to service discovery. This policy can be changed using the [HTTP API for ACL](https://www.consul.io/docs/agent/http/acl.html) for custom policies. It is strongly recommended to use some random strings (like UUID) for the token values. MASTER_ACL_TOKEN and CLIENT_ACL_TOKEN must not be equal.

To make JHipster or Spring Cloud applications registering to consul using the ACL, just add the client ACL token to bootstrap.yml:

```
consul:
    token: my-client-acl-token

```

- [Spring Cloud Consul docs](https://cloud.spring.io/spring-cloud-consul/#spring-cloud-consul-config)
- [Consul K/V store API docs](https://www.consul.io/docs/agent/http/kv.html)

[azure-devops-image]: https://dev.azure.com/neokeld/consul-config-loader/_apis/build/status/jhipster.consul-config-loader?branchName=main
[azure-devops-url-main]: https://dev.azure.com/neokeld/consul-config-loader/_build

[travis-image]: https://travis-ci.org/neokeld/consul-config-loader.svg?branch=main
[travis-url]: https://travis-ci.org/neokeld/consul-config-loader
