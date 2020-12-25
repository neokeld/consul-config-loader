#!/bin/bash

# To use outside of docker, set the following environment variables
# export INIT_SLEEP_SECONDS=0;export CONFIG_DIR=config/;export CONSUL_URL=localhost;export CONSUL_PORT=8500
sleep $INIT_SLEEP_SECONDS

echo "----------------------------------------------------------------------
  Starting Consul Config Loader"

function loadPropertiesFilesIntoConsul {
  for file in $CONFIG_DIR/*."${CONFIG_FORMAT:-yml}"
	do
	  /upload-consul-file.sh $file
	done
  echo "   Consul Config reloaded"
}

echo "----------------------------------------------------------------------
  Loading config files in Consul K/V Store from the filesystem
  Add or edit properties files in '$CONFIG_DIR' to have them
  automatically reloaded into Consul
  Consul UI: http://$CONSUL_URL:$CONSUL_PORT/ui/#/dc1/kv/config/
----------------------------------------------------------------------"

# Wait until the consul agent is up
until $(curl --output /dev/null --silent --fail http://$CONSUL_URL:$CONSUL_PORT/v1/health/state/critical); do
  echo 'Trying to contact the consul agent...'
	sleep 1
done

# Load the files for the first time
loadPropertiesFilesIntoConsul
