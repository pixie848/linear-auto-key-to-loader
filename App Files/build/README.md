# Build files for "Get Loader.exe"

You don't need any of this to use Linear Loader — the finished `Get Loader.exe`
is already in the app root. These files are only here so the launcher and its
icon can be rebuilt.

## What's here

- `icon.html` — the linear.pub-styled app icon (blue "L." on a dark tile).
- `render-icon.js` — renders `icon.html` to `icon-512.png` with the project's
  Playwright Chromium.
- `build-ico.ps1` — packs `icon-512.png` into the multi-size `linear.ico`.
- `Launcher.cs` — the tiny launcher: it opens `App Files\Get Loader.bat` and exits.
- `build-exe.bat` — compiles `Launcher.cs` + `linear.ico` into `Get Loader.exe`.

## Rebuild the icon (only if you change icon.html)

```
node render-icon.js
powershell -ExecutionPolicy Bypass -File build-ico.ps1
```

## Rebuild the exe

Double-click `build-exe.bat` (needs the .NET Framework 4.x C# compiler, which
ships with Windows). It writes `Get Loader.exe` to the app root.
