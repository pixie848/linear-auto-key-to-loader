# auto linear key

Automates the tedious part of getting the loader from `launcher.linear.pub`:
it reads your **current** key from `keys.txt`, opens the site, enters the key,
clicks through, and **saves the downloaded loader** into the `downloads/` folder.

After downloading, it launches the downloaded `.exe` automatically.

## One-time setup

Run:

```
Install Dependencies.bat
```

It installs Node.js if needed, then installs `node_modules` and Playwright
Chromium. If something is already installed, it skips that step.

`Get Loader.bat` will also run this setup automatically if Node.js or
`node_modules` are missing.

## Add your key

Open `keys.txt` and put exactly one line in it: `*` followed immediately by
your real 50-character letters/numbers key.

Do not add comments, examples, or extra old keys.

If `keys.txt` is empty or missing, the script asks for your key once, saves it
as the current `*` key, and then future runs are automatic. Invalid text is
rejected until a real 50-character key is entered.


## Run it

Double-click `Get Loader.bat`, or run:

```
node get-loader.js
```

or pass the same 50-character key directly on the command line.

When it finishes, it launches the downloaded `.exe` automatically.
