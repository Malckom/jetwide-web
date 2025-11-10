# Add WhatsApp Integration to All Pages
# This script adds the WhatsApp CSS and JS to all HTML files

$rootPath = "C:\Users\USER\Desktop\Jetwide-web"

# Function to add WhatsApp integration to HTML file
function Add-WhatsAppIntegration {
    param(
        [string]$filePath
    )
    
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    # Skip if already has whatsapp.js
    if ($content -like '*whatsapp.js*') {
        Write-Host "✓ Already has WhatsApp integration: $filePath" -ForegroundColor Green
        return
    }
    
    # Determine the correct path prefix based on file location
    $relativePath = $filePath.Replace($rootPath, "").Replace("\", "/")
    $depth = ($relativePath -split "/").Count - 2
    $prefix = if ($depth -eq 0) { "assets/" } 
              elseif ($depth -eq 1) { "../assets/" }
              elseif ($depth -eq 2) { "../../assets/" }
              else { "../../../assets/" }
    
    # Add CSS link if not present
    if ($content -match '<link rel="stylesheet" href="[^"]*styles\.css"[^>]*/>') {
        $stylesLine = $matches[0]
        if ($content -notlike '*whatsapp.css*') {
            $newCssLink = $stylesLine + "`r`n  <link rel=`"stylesheet`" href=`"${prefix}whatsapp.css`" />"
            $content = $content.Replace($stylesLine, $newCssLink)
        }
    }
    
    # Add JS script before </body> tag
    $bodyCloseTag = '</body>'
    if ($content.Contains($bodyCloseTag)) {
        $scriptTag = "`r`n  <script src=`"${prefix}whatsapp.js`"></script>`r`n"
        $content = $content.Replace($bodyCloseTag, $scriptTag + $bodyCloseTag)
    }
    
    # Save the file
    $content | Set-Content -Path $filePath -Encoding UTF8 -NoNewline
    Write-Host "✓ Added WhatsApp integration: $filePath" -ForegroundColor Cyan
}

# Process main pages folder
Write-Host "`n=== Processing pages folder ===" -ForegroundColor Yellow
Get-ChildItem -Path "$rootPath\pages" -File -Filter "*.html" | ForEach-Object {
    Add-WhatsAppIntegration -filePath $_.FullName
}

# Process packages folder
Write-Host "`n=== Processing pages/packages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\pages\packages") {
    Get-ChildItem -Path "$rootPath\pages\packages" -File -Filter "*.html" | ForEach-Object {
        Add-WhatsAppIntegration -filePath $_.FullName
    }
}

# Process New/pages folder
Write-Host "`n=== Processing New/pages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\New\pages") {
    Get-ChildItem -Path "$rootPath\New\pages" -File -Filter "*.html" | ForEach-Object {
        Add-WhatsAppIntegration -filePath $_.FullName
    }
}

# Process New/pages/packages folder
Write-Host "`n=== Processing New/pages/packages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\New\pages\packages") {
    Get-ChildItem -Path "$rootPath\New\pages\packages" -File -Filter "*.html" | ForEach-Object {
        Add-WhatsAppIntegration -filePath $_.FullName
    }
}

Write-Host "`n✅ WhatsApp integration added to all pages!" -ForegroundColor Green
Write-Host "Files updated with:" -ForegroundColor White
Write-Host "  - whatsapp.css stylesheet link" -ForegroundColor White
Write-Host "  - whatsapp.js script before closing body tag" -ForegroundColor White
