'use strict';

function neighbors(grid, x, y) {
  const candidates = [
    [x + 1, y],
    [x - 1, y],
    [x, y + 1],
    [x, y - 1],
  ];

  return candidates.filter(([nx, ny]) =>
    ny >= 0 &&
    ny < grid.length &&
    nx >= 0 &&
    nx < grid[ny].length &&
    grid[ny][nx] !== '#'
  );
}

module.exports = { neighbors };
