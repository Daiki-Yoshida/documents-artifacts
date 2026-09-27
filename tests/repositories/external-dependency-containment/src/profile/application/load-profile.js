'use strict';

// Application use-case: load a profile for the public API.

const acme = require('../../vendor/acme-sdk');

async function loadProfile(userId) {
  const raw = await acme.fetchUser(userId);
  return {
    id: raw.userId,
    displayName: raw.name,
    email: raw.email,
  };
}

module.exports = { loadProfile };
