# Fix mobile menu touch issue - Remove touchend handler
$ErrorActionPreference = "Continue"

# List of all pages to update
$pagesToUpdate = @(
    "pages\about-us.html",
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

Write-Host "Fixing mobile touch issue in $($allPages.Count) files..." -ForegroundColor Cyan
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
        
        # Replace the mobile menu script with simplified version (no touchend)
        $oldScript = @'
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

        $newScript = @'
  <script>
    // Mobile Menu - Simple and Direct
    (function() {
      const menuBtn = document.getElementById('mobileMenuBtn');
      const navMenu = document.getElementById('navMenu');
      
      if (menuBtn && navMenu) {
        // Single click handler works for both desktop and mobile
        menuBtn.onclick = function(e) {
          e.preventDefault();
          e.stopPropagation();
          menuBtn.classList.toggle('active');
          navMenu.classList.toggle('active');
        };
      }
    })();
  </script>
'@
        
        if ($content -match [regex]::Escape($oldScript)) {
            $content = $content -replace [regex]::Escape($oldScript), $newScript
            Set-Content -Path $fullPath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  + Fixed: $file" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  - Already fixed or different format: $file" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  X Error processing ${file}: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Touch Issue Fix Complete!" -ForegroundColor Green
Write-Host "Success: $successCount files" -ForegroundColor Green
Write-Host "Errors: $errorCount files" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Green

# Sync to New folder
Write-Host "`nSyncing to New folder..." -ForegroundColor Cyan
robocopy . .\New /E /XD wp node_modules .git /XF *.ps1 /NFL /NDL /R:1 /W:1
Write-Host "Done!" -ForegroundColor Green
