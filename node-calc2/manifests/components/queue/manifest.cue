package queue

import (
  k "kumori.systems/kumori/kmv"
  "strconv"
)

#Manifest : k.#ComponentManifest & {

  ref: {
    domain: "vera.kumori.cloud"
    name: "sad_project_queue"
    version: [0,0,1]
  }

  description: {

    srv: {
      server: {
        queueserver: { protocol: "http", port: 4222 }
      }
      client: {
        evalclient: { protocol: "http"}
      }
    }

    config: {
      // Frontend role configuration parameters
      parameter: {
        appconfig: {
          endpoint: "http://0.evalclient/calc"
        }
      }
      resource: {}
    }

    size: {
      $_memory: "100Mi"
      $_cpu: "100m"
      $_bandwidth: "10M"
    }

    code: {

      queue: {
        name: "queue"

        image: {
          hub: {
            name: "hub.docker.com"
            secret: ""
          }
          tag: "nats:latest"
        }

        mapping: {
          // Filesystem mapping: map the configuration into the JSON file
          // expected by the component
        
          env: {
            HTTP_SERVER_PORT_ENV: value: strconv.FormatUint(srv.server.restapi.port, 10)
          }
        }
      }

    }
  }
}
