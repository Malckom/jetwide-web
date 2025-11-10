# Add Google Analytics to all HTML pages
$rootPath = "C:\Users\USER\Desktop\Jetwide-web"

$googleTag = @"
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-HZF7VP4WRV"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-HZF7VP4WRV');
</script>
"@

function Add-GoogleAnalytics {
    param([string]$filePath)
    
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    # Skip if already has Google tag
    if ($content -like '*gtag.js*' -or $content -like '*G-HZF7VP4WRV*') {
        Write-Host "Already has Google Analytics: $filePath" -ForegroundColor Green
        return
    }
    
    # Add after <head> tag
    $headTag = '<head>'
    if ($content.Contains($headTag)) {
        $replacement = $headTag + "`r`n" + $googleTag
        $content = $content.Replace($headTag, $replacement)
        
        $content | Set-Content -Path $filePath -Encoding UTF8 -NoNewline
        Write-Host "Added Google Analytics to: $filePath" -ForegroundColor Cyan
    } else {
        Write-Host "No <head> tag found in: $filePath" -ForegroundColor Yellow
    }
}

# Process root index.html
Write-Host "`n=== Processing root index.html ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\index.html") {
    Add-GoogleAnalytics -filePath "$rootPath\index.html"
}

# Process root pages folder
Write-Host "`n=== Processing pages folder ===" -ForegroundColor Yellow
Get-ChildItem -Path "$rootPath\pages" -File -Filter "*.html" -ErrorAction SilentlyContinue | ForEach-Object {
    Add-GoogleAnalytics -filePath $_.FullName
}

# Process packages folder
Write-Host "`n=== Processing pages/packages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\pages\packages") {
    Get-ChildItem -Path "$rootPath\pages\packages" -File -Filter "*.html" | ForEach-Object {
        Add-GoogleAnalytics -filePath $_.FullName
    }
}

# Process New/index.html
Write-Host "`n=== Processing New/index.html ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\New\index.html") {
    Add-GoogleAnalytics -filePath "$rootPath\New\index.html"
}

# Process New/pages folder
Write-Host "`n=== Processing New/pages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\New\pages") {
    Get-ChildItem -Path "$rootPath\New\pages" -File -Filter "*.html" | ForEach-Object {
        Add-GoogleAnalytics -filePath $_.FullName
    }
}

# Process New/pages/packages folder
Write-Host "`n=== Processing New/pages/packages folder ===" -ForegroundColor Yellow
if (Test-Path "$rootPath\New\pages\packages") {
    Get-ChildItem -Path "$rootPath\New\pages\packages" -File -Filter "*.html" | ForEach-Object {
        Add-GoogleAnalytics -filePath $_.FullName
    }
}

Write-Host "`n✅ Google Analytics tag added to all pages!" -ForegroundColor Green
Write-Host "Tag ID: G-HZF7VP4WRV" -ForegroundColor White
