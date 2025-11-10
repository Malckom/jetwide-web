$ErrorActionPreference = "Stop"

$baseUrl = "https://www.jetwide.org/"
$root = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$outputPath = Join-Path $root "sitemap.xml"

$exclusions = @("\New\", "\node_modules\", "\wp\", "\.git\")

Write-Host "Scanning HTML files..." -ForegroundColor Cyan

$files = Get-ChildItem -Path $root -Filter "*.html" -Recurse |
    Where-Object {
        $fullPath = $_.FullName
        $include = $true
        foreach ($pattern in $exclusions) {
            if ($fullPath -like "*$pattern*") {
                $include = $false
                break
            }
        }
        return $include
    } |
    Sort-Object FullName

if (-not $files) {
    Write-Warning "No HTML files found."
    exit 1
}

$writerSettings = New-Object System.Xml.XmlWriterSettings
$writerSettings.Indent = $true
$writerSettings.Encoding = [System.Text.UTF8Encoding]::new($false)

$writer = [System.Xml.XmlWriter]::Create($outputPath, $writerSettings)

$writer.WriteStartDocument()
$writer.WriteStartElement("urlset", "http://www.sitemaps.org/schemas/sitemap/0.9")

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($root.Length).TrimStart('\\')
    $relativePath = $relativePath -replace "\\", "/"
    if ($relativePath -ieq "index.html") {
        $url = $baseUrl.TrimEnd('/')
    } else {
        $url = $baseUrl.TrimEnd('/') + '/' + $relativePath
    }
    $url = [System.Uri]::EscapeUriString($url)
    $lastModified = $file.LastWriteTime.ToString("yyyy-MM-dd")

    $writer.WriteStartElement("url")
    $writer.WriteElementString("loc", $url)
    $writer.WriteElementString("lastmod", $lastModified)
    $writer.WriteElementString("changefreq", "weekly")
    $priority = if ($relativePath -ieq "index.html") { 1.0 } else { 0.7 }
    $writer.WriteElementString("priority", "{0:F1}" -f $priority)
    $writer.WriteEndElement()
}

$writer.WriteEndElement()
$writer.WriteEndDocument()
$writer.Flush()
$writer.Close()

Write-Host "Sitemap generated at $outputPath" -ForegroundColor Green
