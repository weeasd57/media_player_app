# تحليل استخدام النصوص في مشروع Flutter
$projectPath = "C:\Users\MR_CODER\Desktop\media_player_app"
$libPath = "$projectPath\lib"
$textProviderPath = "$projectPath\lib\presentation\providers\text_provider.dart"

Write-Host "📊 تحليل استخدام النصوص..." -ForegroundColor Green

# استخراج النصوص المستخدمة من الكود
Write-Host "`n🔍 استخراج النصوص المستخدمة من الكود..." -ForegroundColor Yellow
$usedTexts = @()

Get-ChildItem -Path $libPath -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # البحث عن getText('key')
    $getTextMatches = [regex]::Matches($content, "getText\(['\`"]([^'\`"]+)['\`"]\)")
    foreach ($match in $getTextMatches) {
        $usedTexts += $match.Groups[1].Value
    }
    
    # البحث عن getTextWithParams('key',
    $getTextParamsMatches = [regex]::Matches($content, "getTextWithParams\(['\`"]([^'\`"]+)['\`"]\s*,")
    foreach ($match in $getTextParamsMatches) {
        $usedTexts += $match.Groups[1].Value
    }
}

$uniqueUsedTexts = $usedTexts | Sort-Object | Get-Unique
Write-Host "✅ تم العثور على $($uniqueUsedTexts.Count) نص مُستخدم" -ForegroundColor Green

# استخراج النصوص المُعرّفة من TextProvider
Write-Host "`n🔍 استخراج النصوص المُعرّفة..." -ForegroundColor Yellow
$textProviderContent = Get-Content $textProviderPath -Raw

# البحث عن مفاتيح النصوص العربية
$arabicSection = [regex]::Match($textProviderContent, "'ar':\s*\{(.*?)\},", [regex]::RegexOptions::Singleline)
if ($arabicSection.Success) {
    $arabicTexts = [regex]::Matches($arabicSection.Groups[1].Value, "'([^']+)':")
    $definedArabicKeys = @()
    foreach ($match in $arabicTexts) {
        $definedArabicKeys += $match.Groups[1].Value
    }
}

# البحث عن مفاتيح النصوص الإنجليزية
$englishSection = [regex]::Match($textProviderContent, "'en':\s*\{(.*?)\},", [regex]::RegexOptions::Singleline)
if ($englishSection.Success) {
    $englishTexts = [regex]::Matches($englishSection.Groups[1].Value, "'([^']+)':")
    $definedEnglishKeys = @()
    foreach ($match in $englishTexts) {
        $definedEnglishKeys += $match.Groups[1].Value
    }
}

Write-Host "✅ النصوص المُعرّفة - العربية: $($definedArabicKeys.Count)" -ForegroundColor Green
Write-Host "✅ النصوص المُعرّفة - الإنجليزية: $($definedEnglishKeys.Count)" -ForegroundColor Green

# تحليل الاستخدام
$usedArabicTexts = $definedArabicKeys | Where-Object { $uniqueUsedTexts -contains $_ }
$unusedArabicTexts = $definedArabicKeys | Where-Object { $uniqueUsedTexts -notcontains $_ }
$missingTexts = $uniqueUsedTexts | Where-Object { $definedArabicKeys -notcontains $_ }

$usagePercentage = [math]::Round(($usedArabicTexts.Count / $definedArabicKeys.Count) * 100, 1)

Write-Host "`n📈 نتائج التحليل:" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "📊 إجمالي النصوص المُستخدمة في الكود: $($uniqueUsedTexts.Count)" -ForegroundColor White
Write-Host "🔤 النصوص المُعرّفة (عربي): $($definedArabicKeys.Count)" -ForegroundColor White
Write-Host "✅ المُستخدم من العربية: $($usedArabicTexts.Count)" -ForegroundColor Green
Write-Host "❌ غير المُستخدم من العربية: $($unusedArabicTexts.Count)" -ForegroundColor Red
Write-Host "⚠️  نصوص مفقودة: $($missingTexts.Count)" -ForegroundColor Yellow
Write-Host "📊 نسبة الاستخدام: $usagePercentage%" -ForegroundColor Cyan

# إنشاء تقرير
$reportPath = "$projectPath\text_usage_report.md"
$report = @"
# تقرير تحليل استخدام النصوص

## ملخص عام
- إجمالي النصوص المُستخدمة في الكود: $($uniqueUsedTexts.Count)
- النصوص المُعرّفة (عربي): $($definedArabicKeys.Count)
- النصوص المُعرّفة (إنجليزي): $($definedEnglishKeys.Count)
- المُستخدم من العربية: $($usedArabicTexts.Count)
- غير المُستخدم من العربية: $($unusedArabicTexts.Count)
- نسبة الاستخدام: $usagePercentage%

## النصوص المُستخدمة
"@

foreach ($text in ($uniqueUsedTexts | Sort-Object)) {
    $report += "`n- ``$text``"
}

if ($unusedArabicTexts.Count -gt 0) {
    $report += "`n`n## النصوص غير المُستخدمة ($($unusedArabicTexts.Count))"
    foreach ($text in ($unusedArabicTexts | Sort-Object)) {
        $report += "`n- ``$text``"
    }
}

if ($missingTexts.Count -gt 0) {
    $report += "`n`n## النصوص المفقودة من التعريف ($($missingTexts.Count))"
    foreach ($text in ($missingTexts | Sort-Object)) {
        $report += "`n- ``$text``"
    }
}

$report += "`n`n---`n*تم إنشاء هذا التقرير تلقائياً في $(Get-Date)*"

$report | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "`n📝 تم إنشاء التقرير: $reportPath" -ForegroundColor Green

# عرض النصوص غير المُستخدمة إذا كانت قليلة
if ($unusedArabicTexts.Count -le 20 -and $unusedArabicTexts.Count -gt 0) {
    Write-Host "`n❌ أمثلة على النصوص غير المُستخدمة:" -ForegroundColor Red
    $unusedArabicTexts | Select-Object -First 10 | ForEach-Object {
        Write-Host "   - $_" -ForegroundColor DarkRed
    }
    if ($unusedArabicTexts.Count -gt 10) {
        Write-Host "   ... و$($unusedArabicTexts.Count - 10) نصوص أخرى" -ForegroundColor DarkRed
    }
}

# عرض النصوص المفقودة إذا كانت موجودة
if ($missingTexts.Count -gt 0) {
    Write-Host "`n⚠️  النصوص المفقودة من التعريف:" -ForegroundColor Yellow
    $missingTexts | Sort-Object | ForEach-Object {
        Write-Host "   - $_" -ForegroundColor DarkYellow
    }
}

Write-Host "`n✅ تم الانتهاء من التحليل!" -ForegroundColor Green
