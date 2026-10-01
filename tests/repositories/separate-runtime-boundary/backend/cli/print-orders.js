// Backend-internal CLI — same deployable, so using Application directly
// is legal and must NOT be routed through the wire contract.
import { listOrders } from '../application/list-orders.js';

export function printOrders(repo) {
  for (const row of listOrders(repo)) console.log(`${row.id} ${row.status}`);
}
