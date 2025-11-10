# Add WhatsApp Integration to All Pages
$rootPath = "C:\Users\USER\Desktop\Jetwide-web"

function Add-WhatsAppIntegration {
    param([string]$filePath)
    
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    if ($content -like '*whatsapp.js*') {
        Write-Host "Already has WhatsApp: $filePath" -ForegroundColor Green
        return
    }
    
    $relativePath = $filePath.Replace($rootPath, "").Replace("\", "/")
    $depth = ($relativePath -split "/").Count - 2
    $prefix = if ($depth -eq 0) { "assets/" } 
              elseif ($depth -eq 1) { "../assets/" }
              elseif ($depth -eq 2) { "../../assets/" }
              else { "../../../assets/" }
    
    if ($content -match '<link rel="stylesheet" href="[^"]*styles\.css"[^>]*/>') {
        $stylesLine = $matches[0]
        if ($content -notlike '*whatsapp.css*') {
            $newCssLink = $stylesLine + "`r`n  <link rel=`"stylesheet`" href=`"${prefix}whatsapp.css`" />"
            $content = $content.Replace($stylesLine, $newCssLink)
        }
    }
    
    $bodyTag = [char]60 + '/body' + [char]62
    if ($content.Contains($bodyTag)) {
        $scriptTag = "`r`n  <script src=`"${prefix}whatsapp.js`"></script>`r`n"
        $content = $content.Replace($bodyTag, $scriptTag + $bodyTag)
    }
    
    $content | Set-Content -Path $filePath -Encoding UTF8 -NoNewline
    Write-Host "Added WhatsApp to: $filePath" -ForegroundColor Cyan
}

Write-Host "=== Processing pages folder ===" -ForegroundColor Yellow
Get-ChildItem -Path "$rootPath\pages" -File -Filter "*.html" | ForEach-Object {
    Add-WhatsAppIntegration -filePath $_.FullName
}

Write-Host "=== Processing packages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\pages\packages") {
    Get-ChildItem -Path "$rootPath\pages\packages" -File -Filter "*.html" | ForEach-Object {
        Add-WhatsAppIntegration -filePath $_.FullName
    }
}

Write-Host "Done!" -ForegroundColor Green
