function New-ModuleOutline {
<#
.Synopsis
Create a new module outline.

.Description
Create a new module outline.

.Example
    PS > new-moduleOutline 
   
Description
-----------
does something

.Parameter ModuleName
Specifies name to be used for the module.

.Parameter Author
Specifies author of the module.

.Parameter Version
Specifies the version of the module.

.Parameter License
Specifies the license to release the module under.

.Parameter MinimumPSVersion
Specifies the minimum version of PowerShell required to load the module.

.Parameter Description
Optional description to include with the module manifest.

.Parameter Path
Specifies the parent path where the module folder and files will be created.
 
.Notes

The MIT License (MIT) 
Copyright (c) 2016 Jim Schell

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


#### Name:       New-ModuleOutline
#### Author:     Jim Schell
#### Version:    0.1.3
#### License:    MIT

### Change Log

###### 2016-06-06::0.1.3
- largely completed first pass of functionality

###### 2016-06-03::0.1.2
- renamed to 'ModuleOutline' from 'Module'

###### 2016-06-03::0.1.1
- added the rest of the help sections (bare). need to go back and fill in examples, synopsis, description

###### 2016-06-01::0.1.0
- initial creation
- building out the rest of scaffolding

#>


    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]
        $ModuleName,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Author,
        
        [Parameter(Mandatory = $false)]
        [System.Version]
        $Version = "0.1.0",
        
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            $licenseDir = "$psScriptRoot\LICENSE"
            $licenseList = @(get-childItem -path $licenseDir -filter "LICENSE_*.psd1")
            $licenseSet = @()
            foreach($license in $licenseList){
                $name = $license.baseName
                $name = $name.trimStart("LICENSE_")
                $licenseSet += @($name)    
            }
            
            if($licenseSet -contains $_ ){
                return $true
            }
            $msgLicenseNotValid = "`'$_`' did not match the expected set of licenses. Please choose " +
                "from one of the following licenses: `n"
            foreach($license in $licenseSet){
                $msgLicenseNotValid += "$($license)`n"
            }
            Throw $msgLicenseNotValid
        })]
        [String]
        $License = "MIT",

        [Parameter(Mandatory = $false)]
        [int]
        $MinimumPSVersion = 3
        
        [Parameter(Mandatory = $false)]
        [String]
        $Description,
        
        [Parameter(Mandatory = $false)]
        $Path = $pwd
    )
    
    $dateYear = get-date -UFormat %Y
    $versionAsString = $version.toString()
    
    $defaultOutFileParam = @{
        Encoding = 'UTF8'
        Force = $false
        NoClobber = $true
    }
    
    $foldersToCreate = @(
        "$path\$moduleName"
        "$path\$moduleName\en-us"
        "$path\$moduleName\docs"
        "$path\$moduleName\build"
        "$path\$moduleName\private"
        "$path\$moduleName\public"
        "$path\$moduleName\tests"
        
    )
    foreach($folder in $foldersToCreate){
        New-Item -Path $folder -ItemType Directory
    }
    
    $templatePath = "$psScriptRoot\templates"
    
    #--- Copy module with appropriate name
    Set-Content -path "$path\$moduleName\$($moduleName).psm1" -Value "$templatePath\ModuleName.psm1" -Encoding UTF8
    
    #--- Getting license details...
    $licenseFull = Import-LocalizedData -baseDirectory "$psScriptRoot\LICENSE" -fileName "LICENSE_$($licence).psd1"
    $licenseContent = $licenseFull.licenseContent
    $licenseContent = $licenseContent -replace '%%YEAR%%',$dateYear
    $licenseContent = $licenseContent -replace '%%AUTHOR%%',$author
    $licenseName = $licenseFull.licenseName
    $licenseURI = $licenseFull.licenseURI
    
    Set-Content -path "$path\$moduleName\LICENSE.txt" -Value $licenseContent -Encoding UTF8
    
    #--- Building About_Help
    $aboutHelpContent = Get-Content -path "$templatePath\about_ModuleName.help.txt"
    $aboutHelpContent = $aboutHelpContent -replace '%%MODULE_NAME%%', $moduleName
    Set-Content -path "$path\$moduleName\en-us\about_$($moduleName).help.txt" -Value $aboutHelpContent -Encoding UTF8
    
    #--- Build ReadMe
    $readmeStart = Get-Content -path "$templatePath\ReadMe.md" -raw
    $readmeStart = $readmeStart -replace '%%ModuleName%%', $moduleName
    $readmeStart = $readmeStart -replace '%%MinimumPSVersion%%', $MinimumPSVersion
    Set-Content -path "$path\$moduleName\ReadMe.md" -Value $readmeStart -Encoding UTF8
    
    #--- Build Changes
    $changesStart = Get-Content -path "$templatePath\Changes.txt" -raw
    $changesStart = $changesStart -replace '%%DATE%%',$dateYMD
    $changesStart = $changesStart -replace '%%Version%%',$version
    Set-Content -path "$path\$moduleName\Changes.txt" -Value $changesStart -Encoding UTF8
    
    #--- Build starter functions
    $functionSkeleton = Get-Content -path "$templatePath\functionSample.ps1" -raw
    Set-Content -path "$path\$moduleName\public\functionToExport.ps1" -Value $functionSkeleton -Encoding UTF8
    Set-Content -path "$path\$moduleName\private\functionNotToExport.ps1" -Value $functionSkeleton -Encoding UTF8
    
    #--- Build starter tests
    $testSkeleton = Get-Content -path "$templatePath\testSample.tests.ps1" -raw
    $testSkeleton = $testSkeleton -replace "%%FUNCTION_NAME%%","Verb-Noun"
    Set-Content -path "$path\$moduleName\tests\functionsToExport.tests.ps1" -Value $testSkeleton -Encoding UTF8
    Set-Content -path "$path\$moduleName\tests\functionsNotToExport.tests.ps1" -Value $testSkeleton -Encoding UTF8
    
    #--- Build empty docs for starter functions
    Set-Content -path "$path\$moduleName\docs\functionToExport.md" -Value "" -Encoding UTF8
    Set-Content -path "$path\$moduleName\docs\functionNotToExport.md" -Value "" -Encoding UTF8
    
    #--- Create manifest
    
    $newGuid = [GUID]::NewGuid().Guid
    $manifestContent = @"
@{
RootModule = '$moduleName.psm1'

ModuleVersion = '$versionAsString'

GUID = '$newGuid'

Author = '$author'

Copyright = '$licenseShort, $dateYear'

PowerShellVersion = '$MinimumPSVersion'

PowerShellHostVersion = '$MinimumPSVersion'

Description = '$description'

FunctionsToExport = @()

PrivateData = @{
    
    PSData = @{
        
        Tags = @('PSModule', 'verb-noun' )
        
        LicenseURI = '$licenseURI'
        
        ProjectURI = ''
        
        ReleaseNotes = `@`'

$changesStart
        
`'`@
    }
    
}

}    
    
"@
        
    Set-Content -path "$path\$moduleName\$moduleName.psd1" -Value $manifestContent -Encoding UTF8

}