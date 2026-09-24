'use strict';

const { ok } = require('./outcome');

const reservations = new Map();
let nextReservationId = 1;

async function listReservations() {
  return ok([...reservations.values()]);
}

module.exports = { listReservations };
