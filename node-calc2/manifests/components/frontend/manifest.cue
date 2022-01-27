package frontend

import (
  k "kumori.systems/kumori/kmv"
  "strconv"
)

#Manifest : k.#ComponentManifest & {

  ref: {
    domain: "vera.kumori.cloud"
    name: "sad_project_frontend"
    version: [0,0,1]
  }

  description: {

    srv: {
      server: {
        restapi: { protocol: "http", port: 8080 }
      }
      client: {
        queueclient: { protocol: "http" }
      }
    }

    config: {
      // Frontend role configuration parameters
      parameter: {
        appconfig: {
          endpoint: "http://0.queueclient/calc"
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

      frontend: {
        name: "frontend"

        image: {
          hub: {
            name: "registry.gitlab.com"
            secret: ""
          }
          tag: "kumori-systems/community/image-registry/examples/node-calc-frontend:v0.0.1"
        }

        mapping: {
          // Filesystem mapping: map the configuration into the JSON file
          // expected by the component
          filesystem: [
            {
              path: "/config/config.json"
              data: config.parameter.appconfig
              format: "json"
            }
          ]
          env: {
            CONFIG_FILE: value: "/config/config.json"
            HTTP_SERVER_PORT_ENV: value: strconv.FormatUint(srv.server.restapi.port, 10)
          }
        }
      }

    }
  }
}
