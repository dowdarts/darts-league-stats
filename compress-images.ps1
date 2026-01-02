# Compress player images using .NET Image class
Add-Type -AssemblyName System.Drawing

$sourceFolder = "results\images\players"
$quality = 75 # Compression quality (0-100)

Get-ChildItem "$sourceFolder\*.png" | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    
    # Calculate new dimensions (reduce to 300x300 max while maintaining aspect ratio)
    $maxSize = 300
    $width = $img.Width
    $height = $img.Height
    
    if ($width -gt $maxSize -or $height -gt $maxSize) {
        $ratio = [Math]::Min($maxSize / $width, $maxSize / $height)
        $newWidth = [int]($width * $ratio)
        $newHeight = [int]($height * $ratio)
    } else {
        $newWidth = $width
        $newHeight = $height
    }
    
    # Create new image with smaller dimensions
    $newImg = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($newImg)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)
    
    # Save with compression
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/png' }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $quality)
    
    $tempFile = "$($_.FullName).tmp"
    $newImg.Save($tempFile, $encoder, $encoderParams)
    
    # Clean up
    $graphics.Dispose()
    $newImg.Dispose()
    $img.Dispose()
    
    # Replace original
    Move-Item -Path $tempFile -Destination $_.FullName -Force
    
    Write-Host "Compressed: $($_.Name)"
}

Write-Host "`nDone! Check new file sizes."
