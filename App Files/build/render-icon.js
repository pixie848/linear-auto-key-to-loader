// Renders icon.html's #tile element to a transparent 512x512 PNG (icon-512.png)
// using the Playwright Chromium already installed for this project.
//
//   node render-icon.js
//
// Then run build-ico.ps1 to pack it into linear.ico.
const path = require("path");
const { chromium } = require(path.join(__dirname, "..", "node_modules", "playwright"));

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({
    viewport: { width: 512, height: 512 },
    deviceScaleFactor: 1,
  });
  const url = "file:///" + path.join(__dirname, "icon.html").replace(/\\/g, "/");
  await page.goto(url, { waitUntil: "networkidle" });
  await page.evaluate(() => document.fonts && document.fonts.ready);
  await page.waitForTimeout(400);
  const el = await page.$("#tile");
  await el.screenshot({
    path: path.join(__dirname, "icon-512.png"),
    omitBackground: true,
  });
  await browser.close();
  console.log("wrote icon-512.png");
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
