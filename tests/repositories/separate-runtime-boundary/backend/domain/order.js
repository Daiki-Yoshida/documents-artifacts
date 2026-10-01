// Domain — backend internal. Not part of the wire contract.
export class Order {
  constructor({ id, status, placedAt }) {
    this.id = id;
    this.status = status;
    this.placedAt = placedAt; // internal until published on the wire
  }
}
