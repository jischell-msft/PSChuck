# Test-VSTS.ps1

# Whyyyyyyy doesn't this work in VSTS build agent? Pulling down zips like an animal...
# Install-PackageProvider -Name NuGet -Scope CurrentUser -Force
# Install-Module -Name PsScriptAnalyzer -Scope CurrentUser -Force
# Install-Module -Name Pester -Scope CurrentUser -Force




$tempFile = Join-Path $env:TEMP pester.zip 
Invoke-WebRequest https://github.com/pester/Pester/archive/master.zip -OutFile $tempFile 
[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null 
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempFile, $env:TEMP) 
Remove-Item $tempFile
Import-Module $env:TEMP\Pester-master\Pester.psm1

<#
$ResultsPSSA = Invoke-ScriptAnalyzer -Path $pwd -Recurse -Severity Error -ErrorAction SilentlyContinue
If ($ResultsPSSA) {
    $ResultPSSAString = $ResultsPSSA | Out-String
    Write-Warning $ResultPSSAString
    Throw "$($ResultPSSAString)"
}
Else {
    Return $True
}
#>

$ResultsPesterPath = "$env:COMMON_TESTRESULTSDIRECTORY\Test-Pester.xml"
$ResultsPester = Invoke-Pester -PassThru -Outputformat nunitxml -Outputfile $ResultsPesterPath
If ($ResultsPester) {
    $ResultPesterString = $ResultsPester | Out-String
    Write-Warning $ResultPesterString
    Throw "$($ResultPesterString)"
}
Else {
    Return $True
}