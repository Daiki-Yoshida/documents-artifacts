// Renders the wire DTO shape declared in contracts/order-api.md.
export function renderOrderList(orders) {
  return orders.map((o) => `${o.id} ${o.status}`);
}
