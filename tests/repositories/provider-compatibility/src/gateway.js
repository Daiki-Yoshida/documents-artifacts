'use strict';

// Consumer side: routes messages through the injected Provider.
function createGateway(provider) {
  return {
    notify(message) {
      return provider.send(message);
    },
  };
}

module.exports = { createGateway };
