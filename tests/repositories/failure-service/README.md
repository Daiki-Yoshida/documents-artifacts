# Reservation Service Sample

Small brownfield service that reserves inventory through an external vendor.

The project represents caller-visible outcomes with `src/outcome.js`; reuse it
for new capabilities rather than introducing new result types.

`src/vendor-inventory.js` is the vendor client boundary. Its error types are
vendor-owned implementation detail.
