# Player Image Converter Script
# This script extracts base64 images from player_profiles.json and saves them as separate files

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Player Image Converter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if player_profiles.json exists
if (-not (Test-Path "results\player_profiles.json")) {
    Write-Host "Error: results\player_profiles.json not found!" -ForegroundColor Red
    exit 1
}

# Create images/players directory if it doesn't exist
$imagesDir = "images\players"
if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
    Write-Host "Created directory: $imagesDir" -ForegroundColor Green
}

# Load the JSON
Write-Host "Loading player_profiles.json..." -ForegroundColor Yellow
$jsonContent = Get-Content "results\player_profiles.json" -Raw
$players = $jsonContent | ConvertFrom-Json

$originalSize = (Get-Item "results\player_profiles.json").Length
Write-Host "Original file size: $([math]::Round($originalSize/1024/1024, 2)) MB" -ForegroundColor Yellow
Write-Host ""

# Process each player
$processedCount = 0
foreach ($player in $players) {
    $playerName = $player.name
    
    if ($player.imageBase64 -and $player.imageBase64 -ne "") {
        Write-Host "Processing: $playerName" -ForegroundColor Cyan
        
        # Create filename from player name (lowercase, replace spaces with hyphens)
        $filename = $playerName.ToLower() -replace '[^a-z0-9\s]', '' -replace '\s+', '-'
        $filename = "$filename.png"
        
        # Extract base64 data (remove data:image/png;base64, prefix)
        $base64Data = $player.imageBase64 -replace '^data:image/[^;]+;base64,', ''
        
        # Convert base64 to bytes and save as PNG
        try {
            $imageBytes = [Convert]::FromBase64String($base64Data)
            $imagePath = Join-Path $imagesDir $filename
            [System.IO.File]::WriteAllBytes($imagePath, $imageBytes)
            
            $imageSize = (Get-Item $imagePath).Length
            Write-Host "  * Saved: $filename ($([math]::Round($imageSize/1024, 2)) KB)" -ForegroundColor Green
            
            # Update player object to use filename instead of base64
            $player.imageBase64 = $filename
            $processedCount++
            
        } catch {
            Write-Host "  x Failed to convert image for $playerName" -ForegroundColor Red
            Write-Host "    Error: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Skipping: $playerName (no image)" -ForegroundColor Gray
    }
}

# Save updated JSON
Write-Host ""
Write-Host "Saving updated player_profiles.json..." -ForegroundColor Yellow
$updatedJson = $players | ConvertTo-Json -Depth 10
Set-Content "results\player_profiles.json" -Value $updatedJson -Encoding UTF8

$newSize = (Get-Item "results\player_profiles.json").Length
Write-Host "New file size: $([math]::Round($newSize/1024, 2)) KB" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Conversion Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Images processed: $processedCount" -ForegroundColor White
Write-Host "Size reduction: $([math]::Round(($originalSize - $newSize)/1024/1024, 2)) MB" -ForegroundColor White
Write-Host "Images saved to: $imagesDir\" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Update display.html to load images from images/players/" -ForegroundColor White
Write-Host "2. Push changes to GitHub: git add .; git commit -m ""Extract player images""; git push" -ForegroundColor White
Write-Host ""
