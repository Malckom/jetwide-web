# Batch update mobile menu in all HTML files
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
$packagePages = Get-ChildItem -Path "pages\packages" -Filter "*.html" | ForEach-Object { "pages\packages\$($_.Name)" }
$allPages = $pagesToUpdate + $packagePages

Write-Host "Total files to update: $($allPages.Count)" -ForegroundColor Cyan
$successCount = 0
$errorCount = 0

foreach ($file in $allPages) {
    $fullPath = Join-Path $PSScriptRoot $file
    
    if (-not (Test-Path $fullPath)) {
        Write-Host "  ✗ File not found: $file" -ForegroundColor Red
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
        
        # Step 3: Update mobile CSS
        $oldCSS = '@media \(max-width: 768px\) \{\s*\.nav-menu \{\s*background: white;\s*box-shadow: 0 4px 10px rgba\(0, 0, 0, 0\.1\);\s*\}\s*\}'
        
        $newCSS = @'
    /* Ensure mobile menu toggle is clickable */
    .mobile-menu-toggle {
      position: relative;
      z-index: 1000 !important;
      cursor: pointer;
      -webkit-tap-highlight-color: transparent;
      pointer-events: auto !important;
      touch-action: manipulation;
    }
    
    .mobile-menu-toggle span {
      pointer-events: none;
    }
    
    @media (max-width: 768px) {
      .nav-menu {
        background: white;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      }
      
      .nav-menu a {
        color: #14132A !important;
        font-size: 16px !important;
        font-weight: 500 !important;
        padding: 12px 16px !important;
      }
      
      .nav-menu a:hover {
        color: #FE9900 !important;
        background: #f8f8f8;
      }
      
      .dropdown-menu {
        position: static !important;
        box-shadow: none !important;
        padding-left: 20px !important;
      }
      
      .dropdown-header {
        color: #14132A !important;
        font-size: 14px !important;
        font-weight: 600 !important;
      }
      
      .dropdown-item {
        color: #333 !important;
        font-size: 14px !important;
        padding: 8px 16px !important;
      }
      
      .dropdown-item:hover {
        color: #FE9900 !important;
        background: #f8f8f8;
      }
      
      .mobile-menu-toggle {
        display: flex !important;
        visibility: visible !important;
        opacity: 1 !important;
      }
    }
'@
        
        if ($content -match $oldCSS) {
            $content = $content -replace $oldCSS, $newCSS
            $modified = $true
        } elseif ($content -notmatch 'pointer-events: auto !important') {
            # Find the mobile menu toggle span CSS and add new CSS after it
            $content = $content -replace '(\s*\.mobile-menu-toggle span \{\s*background: #14132A;\s*\}\s*)(\s*@media)', "`$1`n$newCSS`n`$2"
            $modified = $true
        }
        
        # Step 4: Add mobile menu JavaScript
        $mobileMenuJS = @'
  <script>
    // Mobile Menu - Simple and Direct
    (function() {
      const menuBtn = document.getElementById('mobileMenuBtn');
      const navMenu = document.getElementById('navMenu');
      
      if (menuBtn && navMenu) {
        // Click handler
        menuBtn.onclick = function(e) {
          e.preventDefault();
          e.stopPropagation();
          menuBtn.classList.toggle('active');
          navMenu.classList.toggle('active');
        };
        
        // Touch handler for mobile
        menuBtn.addEventListener('touchend', function(e) {
          e.preventDefault();
          e.stopPropagation();
          menuBtn.classList.toggle('active');
          navMenu.classList.toggle('active');
        });
      }
    })();
  </script>
'@
        
        if ($content -notmatch "getElementById\('mobileMenuBtn'\)") {
            # Find the first <script> tag and add our mobile menu script before it
            $content = $content -replace '(\s*<script>)', "$mobileMenuJS`n`$1"
            $modified = $true
        }
        
        if ($modified) {
            Set-Content -Path $fullPath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  ✓ Updated: $file" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  - Skipped (already updated): $file" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  ✗ Error processing $file : $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n========================================"  -ForegroundColor Green
Write-Host "Batch Update Complete!" -ForegroundColor Green
Write-Host "Success: $successCount files" -ForegroundColor Green
Write-Host "Errors: $errorCount files" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Green
