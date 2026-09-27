'use strict';

// Behavior checks for the app module. Node built-ins only.
const assert = require('node:assert');
const { createServer, PORT } = require('../src/app');

assert.strictEqual(PORT, Number(process.env.APP_PORT || 3000));
assert.strictEqual(typeof createServer, 'function');

const server = createServer();
server.listen(0, '127.0.0.1', () => {
  const { port } = server.address();
  http_get(port, (body) => {
    server.close();
    const parsed = JSON.parse(body);
    assert.strictEqual(parsed.status, 'ok');
    assert.strictEqual(parsed.service, 'work-runtime-resources');
    console.log('test: ok');
  });
});

function http_get(port, done) {
  require('node:http')
    .get({ host: '127.0.0.1', port, path: '/' }, (res) => {
      let body = '';
      res.on('data', (c) => (body += c));
      res.on('end', () => done(body));
    })
    .on('error', (e) => {
      server.close();
      throw e;
    });
}
