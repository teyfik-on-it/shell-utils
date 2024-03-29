const [first] = process.argv.slice(2);
const { execSync } = require('child_process');

const url = decodeURIComponent(new URL(first).toString());
const [board, card] = url.split(/\/+/).slice(3);
const [id, ...name] = card.split(/-+/);
let branch = name
  .join('-')
  .substring(0, 50)
  .replace(/-[^-]+$/, '');

let username = execSync('git config user.name')
  .toString('utf-8')
  .trim()
  .split(/\W/);

username = username.length < 2 ? username[0] : username[1];
username = username.toLowerCase();

const charmap = {
  ğ: 'g',
  ü: 'u',
  ş: 's',
  ı: 'i',
  ö: 'o',
  ç: 'c',
  Ğ: 'G',
  Ü: 'U',
  Ş: 'S',
  İ: 'I',
  Ö: 'O',
  Ç: 'C',
};

branch = `${username}/${board}-${id}-${branch}`.replace(
  /[ĞÜŞİÖÇğüşiöç]/g,
  (m) => charmap[m],
);

execSync(`git checkout dev`);
execSync(`git pull -p`);
execSync(`git checkout -b "${branch}"`);
execSync(`git push -u origin "${branch}"`);
