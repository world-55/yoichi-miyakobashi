# 夜市のアイコン（ネオン看板風）を icons/ に書き出す
Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $PSScriptRoot
$out = Join-Path $root 'icons'
New-Item -ItemType Directory -Force $out | Out-Null

function Make-Icon([int]$size, [string]$name) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAliasGridFit'
  $g.Clear([System.Drawing.Color]::FromArgb(255, 0x13, 0x0d, 0x10))

  # カウンターの木目（下側）
  $wood = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0x3e, 0x22, 0x13))
  $g.FillRectangle($wood, 0, [int]($size * 0.80), $size, [int]($size * 0.20))
  $edge = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0x8a, 0x52, 0x30))
  $g.FillRectangle($edge, 0, [int]($size * 0.80), $size, [int]($size * 0.03))

  $fam = New-Object System.Drawing.FontFamily 'Yu Mincho'
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'

  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $rect = New-Object System.Drawing.RectangleF 0, ([single]($size * 0.30)), $size, ([single]($size * 0.42))
  $path.AddString('夜市', $fam, [int][System.Drawing.FontStyle]::Bold, [single]($size * 0.34), $rect, $fmt)
  $small = New-Object System.Drawing.Drawing2D.GraphicsPath
  $rect2 = New-Object System.Drawing.RectangleF 0, ([single]($size * 0.13)), $size, ([single]($size * 0.18))
  $small.AddString('BAR', $fam, [int][System.Drawing.FontStyle]::Bold, [single]($size * 0.13), $rect2, $fmt)

  # ネオンのにじみ
  foreach ($w in 0.09, 0.06, 0.035, 0.018) {
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(55, 0xff, 0x5c, 0x93)), ([single]($size * $w))
    $pen.LineJoin = 'Round'
    $g.DrawPath($pen, $path); $g.DrawPath($pen, $small)
  }
  $fill = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0xff, 0xd5, 0xe4))
  $g.FillPath($fill, $path)
  $amber = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0xea, 0xa4, 0x3f))
  $g.FillPath($amber, $small)

  $bmp.Save((Join-Path $out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

Make-Icon 512 'icon-512.png'
Make-Icon 192 'icon-192.png'
Make-Icon 180 'apple-touch-icon.png'
Write-Output 'icons done'
