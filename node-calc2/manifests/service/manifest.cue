package echo

import (
  k "kumori.systems/kumori/kmv"
  f "vera.kumori.cloud/sad_project/components/frontend"
  w "vera.kumori.cloud/sad_project/components/worker"
  q "vera.kumori.cloud/sad_project/components/queue"
)

#Manifest: k.#ServiceManifest & {

  ref: {
    domain: "vera.kumori.cloud"
    name: "sad_project"
    version: [0,0,1]
  }

  description: {

    //
    // Kumori Component roles and configuration
    //

    // Configuration (parameters and resources) to be provided to the Kumori
    // Service Application.
    config: {
      parameter: {
        language: string
      }
      resource: {}
    }

    // List of Kumori Components of the Kumori Service Application.
    role: {
      frontend: k.#Role
      frontend: artifact: f.#Manifest

      worker: k.#Role
      worker: artifact: w.#Manifest
      
      queue: k.#Role
      queue: artifact: q.#Manifest
    }

    // Configuration spread:
    // Using the configuration service parameters, spread it into each role
    // parameters
    role: {
      frontend: {
        cfg: {
          parameter: {}
          resource: {}
        }
      }

      worker: {
        cfg: {
          parameter: {
            appconfig: {
              language: config.parameter.language
            }
          }
          resource: {}
        }
      }
      
      queue: {
        cfg: {
            parameter: {}
            resources: {}
        }
      }
    }

    //
    // Kumori Service topology: how roles are interconnected
    //

    // Connectivity of a service application: the set of channels it exposes.
    srv: {
      server: {
        calc: { protocol: "http", port: 80 }
      }
    }

    // Connectors, providing specific patterns of communication among channels.
    connector: {
      serviceconnector: { kind: "lb" }
      evalconnector: { kind: "lb" }
    }

    // Links specify the topology graph.
    link: {

      // Outside -> FrontEnd (LB connector)
			self: calc: to: "serviceconnector"
      serviceconnector: to: frontend: "restapi"

      // FrontEnd -> Queue (LB connector)
      frontend: evalclient: to: "evalconnector"
      evalconnector: to: queue: "queueserver"

      // Worker -> Queue
      worker: workerclient: to: "evalconnector"

    }
  }
}

