'use strict';

// Third-party Acme SDK — v2 (already upgraded). This file is vendored
// third-party code, not project-owned implementation: do not modify it.

async function fetchUser(userId) {
  // Simulated remote call returning the vendor's v2 representation.
  if (userId === 'user-1') {
    return {
      user_id: 'user-1',
      profile: {
        display_name: 'Ada Lovelace',
      },
      contacts: {
        primary_email: 'ada@example.test',
      },
    };
  }
  const err = new Error(`acme: user not found: ${userId}`);
  err.code = 'ACME_NOT_FOUND';
  throw err;
}

module.exports = { fetchUser };
