import * as fs from 'fs';

const intersection: <T>(a: Set<T>, b: Set<T>) => Set<T> = (a, b) => {
  return new Set([...a].filter(x => b.has(x)));
}

const equals: <T>(a: Set<T>, b: Set<T>) => boolean = (a, b) => {
  if (a.size !== b.size) return false;
  for (let x of a) if (!b.has(x)) return false;
  return true;
}

// Unique
const one = (perms: Set<string>[]) => perms.find((p) => p.size === 2)!;
const seven = (perms: Set<string>[]) => perms.find((p) => p.size === 3)!;
const eight = (perms: Set<string>[]) => perms.find((p) => p.size === 7)!;
const four = (perms: Set<string>[]) => perms.find((p) => p.size === 4)!;
// Derived
const nine = (perms: Set<string>[]) => perms.find((p) => p.size === 6 && intersection(p, four(perms)).size === 4)!;
const zero = (perms: Set<string>[]) => perms.find((p) => p.size === 6 && intersection(p, seven(perms)).size === 3 && p !== nine(perms))!;
const six = (perms: Set<string>[]) => perms.find((p) => p.size === 6 && p !== nine(perms) && p !== zero(perms))!;
const five = (perms: Set<string>[]) => perms.find((p) => p.size === 5 && intersection(p, six(perms)).size === 5)!;
const three = (perms: Set<string>[]) => perms.find((p) => p.size === 5 && intersection(p, four(perms)).size === 3 && p !== five(perms))!;
const two = (perms: Set<string>[]) => perms.find((p) => p.size === 5 && p !== five(perms) && p !== three(perms))!;
// In order (index = digit)
const patterns = [
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
];

let result = 0;
const inputs = fs.readFileSync('..\\input.txt', 'utf8').split(/\r?\n/);
for (let line of inputs) {
  const [permutations, signals] = line.split('|');
  const perms = permutations.trim().split(' ').map((s) => new Set([...s]));

  const parsed = signals
    .trim()
    .split(' ')
    .map((s) => new Set([...s]))

  const digits = parsed
    .map((p) => patterns.findIndex((p2) => equals(p, p2(perms))))
    .join('');

  result += parseInt(digits);
}

console.log('The result: ' + result);
