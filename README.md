# Linear Loader

Automates the tedious part of getting the loader from `launcher.linear.pub`:
it reads your **current** key, opens the site, enters the key, clicks through,
and **saves the downloaded loader**, then launches it automatically.

## What's in this folder

| Item | What it is |
| --- | --- |
| **`Get Loader.exe`** | Double-click this to run the loader. It just opens the launcher in its own window. |
| **`Switch Type.bat`** | Change the saved spoofer type (BE or none). |
| **`Uninstall\`** | Contains the uninstaller. |
| **`App Files\`** | Everything the app needs (scripts, `node_modules`, your saved key, downloads). You can ignore it. |

## Run it

Double-click **`Get Loader.exe`**.

The first launch installs anything missing (Node.js, `node_modules`, the
Playwright browser), then starts the loader. Later launches skip straight to the
loader once those checks pass.

## Add your key

The first run asks for your key once and saves it. To edit it by hand later,
open `App Files\keys.txt` and put exactly one line in it: your real
50-character letters/numbers key. No leading `*`, no comments, no extra keys.

After the key is ready, the first run asks for spoofer type: press `1` for BE
or `2` for none. That choice is saved, and later runs simply show the spoofer
type being used. When the saved spoofer is BE, BE is only used once per Windows
boot; later runs in the same boot use none temporarily, and the status board
shows whether BE has already been used. The next Windows restart enables BE once
again.

## Switch the spoofer type

Double-click **`Switch Type.bat`** and press `1` for BE or `2` for none — a
single key press, no Enter needed.

It refuses to open while the loader is running, so close `Get Loader.exe` first.
Switching the type does not clear the per-boot BE-used status; once BE has run,
it stays used until the next Windows restart.

You can also run it from a terminal inside `App Files`:

```
node set-exe-type.js          asks 1 or 2
node set-exe-type.js be        sets BE
node set-exe-type.js none      sets none
```

Or run the loader directly from `App Files`:

```
node get-loader.js
```

(optionally pass the same 50-character key on the command line).

## Uninstall

Open the **`Uninstall\`** folder and double-click
`Uninstall Linear Loader.bat`. It removes old Startup warmup entries, downloaded
loaders, saved setup files, your saved key, and the whole Linear Loader folder.

## Rebuilding `Get Loader.exe`

You don't need to — the finished exe is included. If you want to change the
launcher or its icon, see `App Files\build\README.md`.
