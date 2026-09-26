'use strict';

/**
 * Build the owner report for a list of records.
 *
 * @param {Array<{id: string, ownerId: string, amount: number}>} records
 * @param {Array<{id: string, name: string}>} owners unique by id
 * @returns {Array<{id: string, ownerId: string, ownerName: string|null, amount: number}>}
 *   Array in input record order. `ownerName` is null when no owner matches.
 */
function buildReport(records, owners) {
  return records.map((record) => {
    const owner = owners.find((o) => o.id === record.ownerId);
    return {
      id: record.id,
      ownerId: record.ownerId,
      ownerName: owner ? owner.name : null,
      amount: record.amount,
    };
  });
}

module.exports = { buildReport };
