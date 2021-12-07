const fs = require('fs');
const path = require('path');


const content = fs.readFileSync(path.join(__dirname, "../input.txt"), 'utf8').toString();
const crabs = content.split(',').map(a => a * 1);

const difference = (a, b) => Math.abs(a - b);
const integerSum = (n) => n * (n + 1) / 2;

let lowestCost = Number.MAX_VALUE;
let lowestPosition = 0;
for (const i in crabs) {
  let testPosition = crabs[i];
  let cost = 0;
  for (const j in crabs) {
    cost += integerSum(difference(crabs[j], testPosition));
  }
  if (cost < lowestCost) {
    lowestCost = cost;
    lowestPosition = testPosition;
  }
}

console.log("Lowest cost has a position: " + lowestPosition + " with cost: " + lowestCost);
