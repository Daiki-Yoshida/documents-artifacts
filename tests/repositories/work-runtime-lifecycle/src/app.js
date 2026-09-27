'use strict';

// Minimal service used by the runtime-resource fixture.
const http = require('node:http');

const PORT = Number(process.env.APP_PORT || 3000);

function createServer() {
  return http.createServer((req, res) => {
    res.writeHead(200, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', service: 'work-runtime-lifecycle' }));
  });
}

if (require.main === module) {
  createServer().listen(PORT);
}

module.exports = { createServer, PORT };
