# Packs icon-512.png into a multi-resolution 32-bit .ico (classic DIB entries).
#
#   powershell -ExecutionPolicy Bypass -File build-ico.ps1
#
param(
  [string]$SrcPath = "$PSScriptRoot\icon-512.png",
  [string]$OutPath = "$PSScriptRoot\linear.ico"
)
Add-Type -AssemblyName System.Drawing

$sizes = @(256,128,64,48,32,16)
$master = [System.Drawing.Image]::FromFile($SrcPath)
$images = New-Object System.Collections.Generic.List[byte[]]

foreach ($sz in $sizes) {
  $bmp = New-Object System.Drawing.Bitmap($sz, $sz, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.Clear([System.Drawing.Color]::Transparent)
  $g.DrawImage($master, (New-Object System.Drawing.Rectangle(0,0,$sz,$sz)))
  $g.Dispose()

  $rect = New-Object System.Drawing.Rectangle(0,0,$sz,$sz)
  $bits = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $stride = $bits.Stride
  $buf = New-Object byte[] ($stride * $sz)
  [System.Runtime.InteropServices.Marshal]::Copy($bits.Scan0, $buf, 0, $buf.Length)
  $bmp.UnlockBits($bits)
  $bmp.Dispose()

  $ms = New-Object System.IO.MemoryStream
  $mw = New-Object System.IO.BinaryWriter($ms)
  $mw.Write([int]40)              # biSize
  $mw.Write([int]$sz)             # biWidth
  $mw.Write([int]($sz*2))         # biHeight (color + mask)
  $mw.Write([int16]1)             # biPlanes
  $mw.Write([int16]32)            # biBitCount
  $mw.Write([int]0)               # biCompression BI_RGB
  $mw.Write([int]0)               # biSizeImage
  $mw.Write([int]0)               # biXPelsPerMeter
  $mw.Write([int]0)               # biYPelsPerMeter
  $mw.Write([int]0)               # biClrUsed
  $mw.Write([int]0)               # biClrImportant
  for ($y = $sz - 1; $y -ge 0; $y--) {
    $rowBase = $y * $stride
    for ($x = 0; $x -lt $sz; $x++) {
      $p = $rowBase + $x*4
      $mw.Write($buf[$p]); $mw.Write($buf[$p+1]); $mw.Write($buf[$p+2]); $mw.Write($buf[$p+3])
    }
  }
  $maskRowBytes = [int]([math]::Floor(($sz + 31) / 32) * 4)
  $mw.Write((New-Object byte[] ($maskRowBytes * $sz)))
  $mw.Flush()
  $images.Add($ms.ToArray())
  $mw.Dispose(); $ms.Dispose()
}
$master.Dispose()

$icoStream = New-Object System.IO.MemoryStream
$iw = New-Object System.IO.BinaryWriter($icoStream)
$iw.Write([int16]0)                 # reserved
$iw.Write([int16]1)                 # type = icon
$iw.Write([int16]$sizes.Count)      # image count

$offset = 6 + (16 * $sizes.Count)
for ($i = 0; $i -lt $sizes.Count; $i++) {
  $sz = $sizes[$i]
  $len = $images[$i].Length
  $wh = if ($sz -ge 256) { 0 } else { $sz }
  $iw.Write([byte]$wh)             # width  (0 => 256)
  $iw.Write([byte]$wh)             # height (0 => 256)
  $iw.Write([byte]0)               # palette count
  $iw.Write([byte]0)               # reserved
  $iw.Write([int16]1)              # planes
  $iw.Write([int16]32)             # bit count
  $iw.Write([int]$len)             # bytes in resource
  $iw.Write([int]$offset)          # image offset
  $offset += $len
}
foreach ($img in $images) { $iw.Write($img) }
$iw.Flush()
[System.IO.File]::WriteAllBytes($OutPath, $icoStream.ToArray())
$iw.Dispose(); $icoStream.Dispose()
$finalLen = ([System.IO.FileInfo]$OutPath).Length
Write-Host "Wrote $OutPath ($finalLen bytes, $($sizes.Count) sizes)"
