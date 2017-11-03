alpine-gocd-agent
===============

This image permit run GoCD Agent.

## How use it

The best if you use rancher, it's to add my following rancher catalog: `https://github.com/disaster37/webcenter-catalog.git` with the branch `master`.
Then create GoCD stack from catalog.

Else, you need to GoCD manually.

```bash
docker run -d --name gocd-agent \
  -v $PWD/data/gocd-agent:/data \
  -e "GOCD_CONFIG_agent_key=my_secure_key" \
  -e "GOCD_CONFIG_serverurl=https://gocd:8154/go"
  webcenter/alpine-gocd-agent:latest
```

Or use docker-compose:
```bash
docker-compose up
```

## Certificates

If your git or another versionning tools use https with private PKI, you need to mount your CA certificat in `/usr/local/share/ca-certificates`.


### Parameters

#### Confd

The Minio setting is managed by Confd. So you can custom it:
- **CONFD_BACKEND**: The Confd backend that you should use. Default is `env`.
- **CONFD_NODES**: The array of Confd URL to contact the backend. No default value.
- **CONFD_PREFIX_KEY**: The Confd prefix key. Default is `/gocd`


#### GoCD Agent

The following parameters permit to config GoCD server:
- **GOCD_CONFIG_workdir**: The directory where GoCD store data. Default is `/data`.
- **GOCD_CONFIG_logfile**: The file where GoCD logs stdout. Default is `/data/logs/gocd-agent.log`.
- **GOCD_CONFIG_memory**: The max memory allowed to JVM.
- **GOCD_CONFIG_serverurl**: The URL to join GoCD server. Default is `https://gocd-server:8154/go`.
- **GOCD_CONFIG_agent_key**: The key to auto register with the server.
- **GOCD_CONFIG_agent_resource_X**:  list of resources that this agent should be tagged with.
- **GOCD_CONFIG_agent_environment_X**: list of environments that this agent should be associated with.
- **GOCD_CONFIG_agent_name**: The name of the agent when it is registered with the server.

