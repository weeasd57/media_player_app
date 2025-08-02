# Simple text analysis for Flutter project
$projectPath = "C:\Users\MR_CODER\Desktop\media_player_app"
$libPath = "$projectPath\lib"

Write-Host "Analyzing text usage..." -ForegroundColor Green

# Extract used texts from code
$usedTexts = @()

Get-ChildItem -Path $libPath -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Find getText('key') patterns
    $matches = [regex]::Matches($content, "getText\([`"']([^`"']+)[`"']\)")
    foreach ($match in $matches) {
        $usedTexts += $match.Groups[1].Value
    }
    
    # Find getTextWithParams('key', patterns  
    $paramMatches = [regex]::Matches($content, "getTextWithParams\([`"']([^`"']+)[`"']\s*,")
    foreach ($match in $paramMatches) {
        $usedTexts += $match.Groups[1].Value
    }
}

$uniqueUsedTexts = $usedTexts | Sort-Object | Get-Unique

Write-Host "Found $($uniqueUsedTexts.Count) unique text keys used in code" -ForegroundColor Yellow

# Count defined texts in TextProvider
$textProviderPath = "$projectPath\lib\presentation\providers\text_provider.dart"
$textProviderContent = Get-Content $textProviderPath -Raw

# Count Arabic text definitions
$arabicMatches = [regex]::Matches($textProviderContent, "'([^']+)':\s*'[^']*',?")
$totalDefinedTexts = $arabicMatches.Count / 2  # Divide by 2 because both AR and EN are counted

Write-Host "Total defined text keys: $totalDefinedTexts" -ForegroundColor Yellow
Write-Host "Used text keys: $($uniqueUsedTexts.Count)" -ForegroundColor Yellow

$usagePercentage = [math]::Round(($uniqueUsedTexts.Count / $totalDefinedTexts) * 100, 1)
Write-Host "Usage percentage: $usagePercentage%" -ForegroundColor Cyan

# Show some sample used texts
Write-Host "`nSample used texts:" -ForegroundColor Green
$uniqueUsedTexts | Select-Object -First 20 | ForEach-Object {
    Write-Host "  - $_" -ForegroundColor White
}

if ($uniqueUsedTexts.Count -gt 20) {
    Write-Host "  ... and $($uniqueUsedTexts.Count - 20) more" -ForegroundColor Gray
}

# Create simple report
$reportContent = @"
# Text Usage Analysis Report

## Summary
- Total text keys used in code: $($uniqueUsedTexts.Count)
- Estimated total defined keys: $totalDefinedTexts
- Usage percentage: $usagePercentage%

## Used Text Keys
$($uniqueUsedTexts | ForEach-Object { "- $_" } | Out-String)

Generated: $(Get-Date)
"@

$reportPath = "$projectPath\text_analysis_report.md"
$reportContent | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "`nReport saved to: $reportPath" -ForegroundColor Green
