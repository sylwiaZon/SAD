/*
* Copyright 2020 Kumori systems S.L.
*
* Licensed under the EUPL, Version 1.2 or – as soon they
* will be approved by the European Commission - subsequent
* versions of the EUPL (the "Licence");
* You may not use this work except in compliance with the
* Licence.
* You may obtain a copy of the Licence at:
*
* https://joinup.ec.europa.eu/software/page/eupl
*
* Unless required by applicable law or agreed to in
* writing, software distributed under the Licence is
* distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied.
* See the Licence for the specific language governing
* permissions and limitations under the Licence.
 */

const fs = require('fs')
const express = require('express')
const bodyParser = require('body-parser')
const parse = require("minimist");
const { connect, StringCodec, headers, credsAuthenticator } = require("nats");

const hostname = '0.0.0.0'
const port = 4222
const configFile = process.env.CONFIG_FILE

readConfig = () => {
    return new Promise((resolve, reject) => {
    fs.readFile(configFile, "utf8", (err, jsonString) => {
      if (err) {
        reject(err)
        return
      }
      try {
        appConfig = JSON.parse(jsonString)
        resolve(appConfig)
      } catch (err) {
        reject(err)
      }
    })
  })
}

createExpressApp = (config) => {
  var app = express()
  app.use(bodyParser.json())

  app.post('/echo', (req, res) => {
    console.log(`Received request ${JSON.stringify(req.body)}`)
    doRequest(JSON.stringify(req.body))
    .then(result => {
      res.send(JSON.parse(result.data))
    })
    .catch(err => {
      res.status(503).send(`Unexpected error: ${err.message}`)
    })
  })

  app.get('/health', (req, res) => {
    console.log('Health request')
    res.send('OK')
  })

  app.use(function(req, res, next) {
    res.status(404).send('Not found')
  })

  return app
}

config = readConfig()
.then((config) => {
  app = createExpressApp(config)
  app.listen(port, () => {
    console.log(`Server running at http://${hostname}:${port}/`)
  })
})
.catch((err) => {
  console.log(`Error initializating component: ${err.message}`)
})

async function doRequest(message) {
  let nc;
  try {
    nc = await connect(opts);
  } catch (err) {
    console.log(`error connecting to nats: ${err.message}`);
    return;
  }
  console.info(`connected ${nc.getServer()}`);
  nc.closed()
    .then((err) => {
      if (err) {
        console.error(`closed with an error: ${err.message}`);
      }
    });

  const hdrs = argv.headers ? headers() : undefined;
  if (hdrs) {
    argv.headers.split(";").map((l) => {
      const [k, v] = l.split("=");
      hdrs.append(k, v);
    });
  }

  await nc.request(
    "outgoing",
    sc.encode(message),
    { timeout: argv.t, headers: hdrs },
  )
    .then((m) => {
      console.log(`[${i}]: ${sc.decode(m.data)}`);
      if (argv.headers && m.headers) {
        const h = [];
        for (const [key, value] of m.headers) {
          h.push(`${key}=${value}`);
        }
        console.log(`\t${h.join(";")}`);
      }
      return m;
    })
    .catch((err) => {
      console.log(`[${i}]: request failed: ${err.message}`);
    });
  if (interval) {
    await delay(interval);
  }
  
  await nc.flush();
  await nc.close();
};