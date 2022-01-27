package worker

import (
  k "kumori.systems/kumori/kmv"
  "strconv"
)

#Manifest : k.#ComponentManifest & {

  ref: {
    domain: "vera.kumori.cloud"
    name: "sad_project_worker"
    version: [0,0,1]
  }

  description: {

    srv: {
      client: {
        queueclient: { protocol: "http" }
      }
    }

    config: {
      parameter: {
        // Worker role configuration parameters
        appconfig: {
          language: string | *"en"  // Default value: "en"
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

      worker: {
        name: "worker"

        image: {
          hub: {
            name: "registry.gitlab.com"
            secret: ""
          }
          tag: "kumori-systems/community/image-registry/examples/node-calc-worker:v0.0.1"
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
            HTTP_SERVER_PORT_ENV: value: strconv.FormatUint(srv.server.evalserver.port, 10)
          }
        }
      }

    }
  }
}
