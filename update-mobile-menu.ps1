# PowerShell script to update mobile menu in all HTML files
Write-Host "Starting mobile menu update across all pages..." -ForegroundColor Green

# Define the files to update (excluding wp folder and New folder initially)
$htmlFiles = Get-ChildItem -Path "." -Filter "*.html" -Recurse | 
    Where-Object { $_.FullName -notlike "*\wp\*" -and $_.FullName -notlike "*\New\*" -and $_.FullName -notlike "*\node_modules\*" }

$updatedCount = 0
$skippedCount = 0

foreach ($file in $htmlFiles) {
    Write-Host "`nProcessing: $($file.Name)" -ForegroundColor Cyan
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Step 1: Add IDs to mobile menu button and nav menu if not present
        if ($content -match '<button class="mobile-menu-toggle"[^>]*>') {
            # Add ID to button if not present
            if ($content -notmatch 'id="mobileMenuBtn"') {
                $content = $content -replace '<button class="mobile-menu-toggle"', '<button class="mobile-menu-toggle" id="mobileMenuBtn"'
                Write-Host "  - Added ID to mobile menu button" -ForegroundColor Yellow
            }
        }
        
        if ($content -match '<nav class="nav-menu"[^>]*>') {
            # Add ID to nav if not present
            if ($content -notmatch 'id="navMenu"') {
                $content = $content -replace '<nav class="nav-menu">', '<nav class="nav-menu" id="navMenu">'
                Write-Host "  - Added ID to nav menu" -ForegroundColor Yellow
            }
        }
        
        # Step 2: Update CSS styles in the head
        if ($content -match '@media \(max-width: 768px\) \{[^}]*\.nav-menu \{[^}]*background: white;') {
            # Replace the mobile menu CSS
            $newMobileCSS = @"
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
"@
            
            $pattern = '@media \(max-width: 768px\) \{[^}]*\.nav-menu \{[^}]*\}[^}]*\.mobile-menu-toggle \{[^}]*\}[^}]*\}'
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $newMobileCSS
                Write-Host "  - Updated mobile menu CSS" -ForegroundColor Yellow
            }
        }
        
        # Step 3: Add enhanced mobile toggle CSS if not present
        if ($content -notmatch 'pointer-events: auto !important') {
            $mobileToggleCSS = @"
    
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
"@
            
            # Insert before the @media (max-width: 768px)
            $content = $content -replace '(\s*)(@media \(max-width: 768px\))', "$mobileToggleCSS`r`n`$1`$2"
            Write-Host "  - Added enhanced mobile toggle CSS" -ForegroundColor Yellow
        }
        
        # Step 4: Update JavaScript if needed
        if ($content -match '<script>' -and $content -notmatch 'getElementById\(''mobileMenuBtn''\)') {
            # Add the simple mobile menu script before existing script
            $mobileMenuScript = @"
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

"@
            $content = $content -replace '<script>', $mobileMenuScript
            Write-Host "  - Added mobile menu JavaScript" -ForegroundColor Yellow
        }
        
        # Save if changes were made
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $updatedCount++
            Write-Host "  ✓ Updated successfully" -ForegroundColor Green
        } else {
            $skippedCount++
            Write-Host "  - No changes needed" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Update Complete!" -ForegroundColor Green
Write-Host "Files updated: $updatedCount" -ForegroundColor Yellow
Write-Host "Files skipped: $skippedCount" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nNow syncing to New folder..." -ForegroundColor Cyan

# Copy all updated files to New folder
robocopy . .\New /E /XD wp node_modules .git /XF *.ps1 *.bat *.md /NFL /NDL /NJH /NJS

Write-Host "`n✓ All files synced to New folder!" -ForegroundColor Green
