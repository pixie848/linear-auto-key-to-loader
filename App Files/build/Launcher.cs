// Get Loader.exe -- a thin launcher so the loader looks and runs like an app.
// It just opens "App Files\Get Loader.bat" (which lives next to this exe) in its
// own console window, then exits. Compiled as a Windows (no-console) exe so the
// launcher itself never flashes a blank window.
using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

static class Launcher
{
    [STAThread]
    static void Main()
    {
        try
        {
            string dir = AppDomain.CurrentDomain.BaseDirectory;
            string bat = Path.Combine(dir, "App Files", "Get Loader.bat");
            if (!File.Exists(bat))
            {
                MessageBox.Show(
                    "Could not find:\n\n" + bat +
                    "\n\nKeep \"Get Loader.exe\" in the same folder as the \"App Files\" folder.",
                    "Linear Loader",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            var psi = new ProcessStartInfo
            {
                FileName = bat,
                WorkingDirectory = Path.GetDirectoryName(bat),
                UseShellExecute = true,
            };
            Process.Start(psi);
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Linear Loader",
                MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
}
