const fs = require("fs");

const EXCLUDE_DOMAINS = new Set([
  // Used by the Google Ads Manager too
  "ads.google.com",
]);

async function main() {
  const res = await fetch(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
  );

  const text = await res.text();

  const lines = text
    .trim()
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => {
      if (!line.startsWith("#")) {
        const domain = line.split(" ")[1];
        if (EXCLUDE_DOMAINS.has(domain)) {
          console.log(`Skipped line "${line}"`);
          return false;
        }
      }
      return true;
    });

  const hosts = lines.join("\n");

  fs.writeFileSync("/etc/hosts", hosts);

  console.log(`Updated hosts file (${lines.length} lines)`);
}

main();
