# Batch update mobile menu in all HTML files - Fixed version
$ErrorActionPreference = "Continue"

# List of files to update (excluding about-us.html which is already done)
$pagesToUpdate = @(
    "pages\airline-airport-services.html",
    "pages\beach-getaways.html",
    "pages\blog-post.html",
    "pages\blogs.html",
    "pages\car-hire.html",
    "pages\contact-form.html",
    "pages\contact.html",
    "pages\international-destinations.html",
    "pages\job-application.html",
    "pages\job-placement.html",
    "pages\kenyan-safaris.html",
    "pages\themed-packages.html",
    "pages\visa-services.html"
)

# Get all package pages
$packagePages = Get-ChildItem -Path "pages\packages" -Filter "*.html" -ErrorAction SilentlyContinue | ForEach-Object { "pages\packages\$($_.Name)" }
$allPages = $pagesToUpdate + $packagePages

Write-Host "Total files to update: $($allPages.Count)" -ForegroundColor Cyan
$successCount = 0
$errorCount = 0

foreach ($file in $allPages) {
    $fullPath = Join-Path $PSScriptRoot $file
    
    if (-not (Test-Path $fullPath)) {
        Write-Host "  X File not found: $file" -ForegroundColor Red
        $errorCount++
        continue
    }
    
    Write-Host "Processing: $file" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $fullPath -Raw -Encoding UTF8
        $modified = $false
        
        # Step 1: Add ID to mobile menu button
        if ($content -match '<button class="mobile-menu-toggle"' -and $content -notmatch 'id="mobileMenuBtn"') {
            $content = $content -replace '<button class="mobile-menu-toggle"', '<button class="mobile-menu-toggle" id="mobileMenuBtn"'
            $modified = $true
        }
        
        # Step 2: Add ID to nav menu
        if ($content -match '<nav class="nav-menu">' -and $content -notmatch 'id="navMenu"') {
            $content = $content -replace '<nav class="nav-menu">', '<nav class="nav-menu" id="navMenu">'
            $modified = $true
        }
        
        # Step 3: Update mobile CSS - check if already has the enhanced CSS
        if ($content -notmatch 'pointer-events: auto !important') {
            # Find where to insert the new CSS
            $insertPattern = '(\s*\.mobile-menu-toggle span \{[^\}]*\}\s*)(\s*@media \(max-width: 768px\))'
            $newCSS = "`n`n    /* Ensure mobile menu toggle is clickable */`n" +
                      "    .mobile-menu-toggle {`n" +
                      "      position: relative;`n" +
                      "      z-index: 1000 !important;`n" +
                      "      cursor: pointer;`n" +
                      "      -webkit-tap-highlight-color: transparent;`n" +
                      "      pointer-events: auto !important;`n" +
                      "      touch-action: manipulation;`n" +
                      "    }`n`n" +
                      "    .mobile-menu-toggle span {`n" +
                      "      pointer-events: none;`n" +
                      "    }`n"
            
            if ($content -match $insertPattern) {
                $content = $content -replace $insertPattern, "`$1$newCSS`n`$2"
                $modified = $true
            }
        }
        
        # Step 4: Enhance mobile media query CSS
        $oldMediaQuery = '@media \(max-width: 768px\) \{\s*\.nav-menu \{\s*background: white;\s*box-shadow: 0 4px 10px rgba\(0, 0, 0, 0\.1\);\s*\}\s*\}'
        if ($content -match $oldMediaQuery -and $content -notmatch 'color: #14132A !important') {
            $enhancedMediaQuery = "`n    @media (max-width: 768px) {`n" +
                                 "      .nav-menu {`n" +
                                 "        background: white;`n" +
                                 "        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);`n" +
                                 "      }`n`n" +
                                 "      .nav-menu a {`n" +
                                 "        color: #14132A !important;`n" +
                                 "        font-size: 16px !important;`n" +
                                 "        font-weight: 500 !important;`n" +
                                 "        padding: 12px 16px !important;`n" +
                                 "      }`n`n" +
                                 "      .nav-menu a:hover {`n" +
                                 "        color: #FE9900 !important;`n" +
                                 "        background: #f8f8f8;`n" +
                                 "      }`n`n" +
                                 "      .dropdown-menu {`n" +
                                 "        position: static !important;`n" +
                                 "        box-shadow: none !important;`n" +
                                 "        padding-left: 20px !important;`n" +
                                 "      }`n`n" +
                                 "      .dropdown-header {`n" +
                                 "        color: #14132A !important;`n" +
                                 "        font-size: 14px !important;`n" +
                                 "        font-weight: 600 !important;`n" +
                                 "      }`n`n" +
                                 "      .dropdown-item {`n" +
                                 "        color: #333 !important;`n" +
                                 "        font-size: 14px !important;`n" +
                                 "        padding: 8px 16px !important;`n" +
                                 "      }`n`n" +
                                 "      .dropdown-item:hover {`n" +
                                 "        color: #FE9900 !important;`n" +
                                 "        background: #f8f8f8;`n" +
                                 "      }`n`n" +
                                 "      .mobile-menu-toggle {`n" +
                                 "        display: flex !important;`n" +
                                 "        visibility: visible !important;`n" +
                                 "        opacity: 1 !important;`n" +
                                 "      }`n" +
                                 "    }"
            
            $content = $content -replace $oldMediaQuery, $enhancedMediaQuery
            $modified = $true
        }
        
        # Step 5: Add mobile menu JavaScript
        if ($content -notmatch "getElementById\('mobileMenuBtn'\)") {
            $mobileMenuJS = "  <script>`n" +
                           "    // Mobile Menu - Simple and Direct`n" +
                           "    (function() {`n" +
                           "      const menuBtn = document.getElementById('mobileMenuBtn');`n" +
                           "      const navMenu = document.getElementById('navMenu');`n" +
                           "      `n" +
                           "      if (menuBtn && navMenu) {`n" +
                           "        // Click handler`n" +
                           "        menuBtn.onclick = function(e) {`n" +
                           "          e.preventDefault();`n" +
                           "          e.stopPropagation();`n" +
                           "          menuBtn.classList.toggle('active');`n" +
                           "          navMenu.classList.toggle('active');`n" +
                           "        };`n" +
                           "        `n" +
                           "        // Touch handler for mobile`n" +
                           "        menuBtn.addEventListener('touchend', function(e) {`n" +
                           "          e.preventDefault();`n" +
                           "          e.stopPropagation();`n" +
                           "          menuBtn.classList.toggle('active');`n" +
                           "          navMenu.classList.toggle('active');`n" +
                           "        });`n" +
                           "      }`n" +
                           "    })();`n" +
                           "  </script>`n"
            
            # Find the first <script> tag and add our mobile menu script before it
            $content = $content -replace '(\s*<script>)', "$mobileMenuJS`$1"
            $modified = $true
        }
        
        if ($modified) {
            Set-Content -Path $fullPath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  + Updated: $file" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  - Skipped (already updated): $file" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  X Error processing ${file}: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Batch Update Complete!" -ForegroundColor Green
Write-Host "Success: $successCount files" -ForegroundColor Green
Write-Host "Errors: $errorCount files" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Green
