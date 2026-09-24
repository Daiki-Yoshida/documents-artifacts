'use strict';

const users = new Map([
  ['001', { id: '001', name: 'Ada' }],
  ['010', { id: '010', name: 'Lin' }],
]);

function findUserById(id) {
  return users.get(id) || null;
}

module.exports = { findUserById };
