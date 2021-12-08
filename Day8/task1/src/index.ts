import * as fs from 'fs';

const patterns = [
  (signal: string) => signal.length === 2, // 1
  (signal: string) => signal.length === 3, // 7
  (signal: string) => signal.length === 7, // 8
  (signal: string) => signal.length === 4  // 4
];

let result = 0;
const inputs = fs.readFileSync('..\\input.txt', 'utf8').split(/\r?\n/);
for (let line of inputs) {
  let signals = line.split(' | ')[1].split(' ');
  for (let signal of signals) {
    if (patterns.map(p => p(signal)).some(match => match)) {
      result += 1;
    }
  }
}

console.log('The result: ' + result);
