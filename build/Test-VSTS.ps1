# Test-VSTS.ps1

Install-PackageProvider -Name NuGet -Scope CurrentUser -Force
Install-Module -Name PsScriptAnalyzer -Scope CurrentUser -Force
Install-Module -Name Pester -Scope CurrentUser -Force

$ResultsPSSA = Invoke-ScriptAnalyzer -Path $pwd -Recurse -Severity Error -ErrorAction SilentlyContinue
If ($ResultsPSSA) {
    $ResultPSSAString = $ResultsPSSA | Out-String
    Write-Warning $ResultPSSAString
    Throw "$($ResultPSSAString)"
}
Else {
    Return $True
}

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