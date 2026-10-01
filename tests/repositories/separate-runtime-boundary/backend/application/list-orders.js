// Application use case — maps domain objects to the wire DTO declared
// in contracts/order-api.md.
export function listOrders(repo) {
  return repo.all().map((o) => ({ id: o.id, status: o.status }));
}
