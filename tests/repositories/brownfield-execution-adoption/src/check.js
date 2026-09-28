'use strict';

const SERVICE_NAME = 'brownfield-adoption-app';
const API_VERSION = 'v1';

function describe() {
  return `${SERVICE_NAME} (${API_VERSION})`;
}

module.exports = { SERVICE_NAME, API_VERSION, describe };
