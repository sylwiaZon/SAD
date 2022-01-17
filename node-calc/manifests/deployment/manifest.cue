package calculator_deployment

import (
  k "kumori.systems/kumori/kmv"
  s "kumori.systems/examples/calculator/service:calculator"
)

#Manifest: k.#DeploymentManifest & {

  ref: {
    domain: "vera.kumori.cloud"
    name: "sad_project"
    version: [0,0,1]
  }

  description: {

    service: s.#Manifest

    configuration: {
      // Assign the values to the service configuration parameters
      parameter: {
        language: "en"
      }
      resource: {}
    }

    hsize: {
      frontend: {
        $_instances: 1
      }
      worker: {
        $_instances: 2
      }
      queue: {
        $_instance: 1
      }
    }

  }
}

// Exposed to be used by kumorictl tool (mandatory)
deployment: (k.#DoDeploy & {_params:manifest: #Manifest}).deployment
