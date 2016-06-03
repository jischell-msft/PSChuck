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
#### Version:    0.1.2
#### License:    MIT

### Change Log

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
        mkdir $folder
    }
    
    $templatePath = "$psScriptRoot\templates"
    
    #--- Getting license details...
    $licenseFull = Import-LocalizedData -baseDirectory "$psScriptRoot\LICENSE" -fileName "LICENSE_$($licence).psd1"
    $licenseContent = $licenseFull.licenseContent
    $licenseContent = $licenseContent -replace '%%YEAR%%',$dateYear
    $licenseContent = $licenseContent -replace '%%AUTHOR%%',$author
    $licenseName = $licenseFull.licenseName
    $licenseURI = $licenseFull.licenseURI
    
    New-Item -path "$path\$moduleName\LICENSE.txt" -ItemType File -Value $licenseContent
    
    #--- Building About_Help
    $aboutHelpContent = Get-Content -path "$templatePath\about_ModuleName.help.txt"
    $aboutHelpContent = $aboutHelpContent -replace '%%MODULE_NAME%%', $moduleName
    
    $aboutHelpFileName = "about_$($moduleName).help.txt"
    $aboutHelpOutParam = $defaultOutFileParam
    $aboutHelpOutParam += @{
        inputObject = $aboutHelpContent
        filePath = "$path\$moduleName\en-us\$aboutHelpFileName"
    }
    
    Out-File @aboutHelpOutParam
    #--- Done with About_Help
    
    #--- Copy module with appropriate name
    Copy-Item -path "$templatePath\ModuleName.psm1" -destination "$path\$moduleName\$($moduleName).psm1"
    
    #---
    
    $readmeStart = Get-Content -path "$templatePath\ReadMe.md" -raw
    $readmeStart = $readmeStart -replace '%%ModuleName%%', $moduleName
    
    New-Item -path "$path\$moduleName\ReadMe.md" -ItemType File -Value $readmeStart
    
    $changesStart = Get-Content -path "$templatePath\Changes.txt" -raw
    $changesStart = $changesStart -replace '%%DATE%%',$dateYMD
    $changesStart = $changesStart -replace '%%Version%%',$version
    
    New-Item -path "$path\$moduleName\Changes.txt" -ItemType File -Value $changesStart
    
    
    
    <#
    folder/ file out:
    
    .\ModuleName
        .\en-us
            about_ModuleName.help.txt
        .\public
            functionToExport.ps1
        .\private
            functionToNotExport.ps1
        .\tests
            functionToExport.tests.ps1
            ...
        .\docs
            functionToExport.md
            functionToNotExport.md
        .\build
            (build latest version for... nuget? psgallery?)
        
        ModuleName.psm1
        ModuleName.psd1
        Readme.md
        License.txt
        Changes.txt
    #---
    moduleManifest:
    
rootModule

# old - moduleToProcess

description
moduleVersion


guid
author
copyright $licenseShort

powershellVersion
powershellHostVersion

functionsToExport
cmdletsToExport
AliasesToExport

PrivateData
    PSData
        Tags
        LicenseURI
        ProjectURI
        ReleaseNotes

    #>
    
}