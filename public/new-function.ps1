function New-Function {
<#
.Synopsis
Create a new function, with comment based help.

.Description
Create a new function, including checking approved verbs, comment based help (with license, author information, change log, links), parameters, and the capability to include a separate file that includes the license.

.Example
    PS > new-function -verb notAVerb -noun doesntMatter...

    new-function : Cannot validate argument on parameter 'verb'. 'notAVerb' did not match the expected set of approved verbs.

Description
-----------
Validation occurs at parameter ingestion, for the 'verb' parameter. Parameter must be found with 'get-verb -verb $_'.

.Example
    PS > $newFunctionParams = @{ 
    verb = "test" 
    noun = "grammar"
    author = "Raoul Breton"
    functionParam = @("Being","Understanding","Signifying")
    license = "MIT"
    licenseToFile = $true 
    }

    PS > new-function @newFunctionParams

Description
-----------
Creates a new .PS1 file named 'test-grammar.ps1', containing a function named 'test-grammar' with parameters 'being','understanding','signifying', and also creates a new 'license.txt' file with the selected license as contents.

.Parameter Verb
Specifies the verb to use for the function name, in the verb-noun convention. Verb must be found in the approved list of verbs - 'get-verb' will output this list.

.Parameter Noun
Specifies the noun to use for the function name, in the verb-noun convention. Currently there is not checking to validate singular form is used ('computer' instead of 'computers'), although this is checked by PSScriptAnalyzer.

.Parameter Author
Specifies the name of the author writing the function.

.Parameter Version
Specifies the version of the function to begin from.

.Parameter FunctionParam
Specifies an array of string values to use as parameter names.

.Parameter Link
Specifies an array of links that will be added to the comment based help.

.Parameter License
Specifies the license to use, from the set of licenses available and formated in the 'LICENSE' directory.

.Parameter LicenseToFile
Outputs the content of the license to a file in the same directory as the function.

.Parameter PassThru
Returns the content of the newly created function. By default, this cmdlet will not generate output to the console.

.Parameter Force
By default, existing files with the same name will not be over written. This forces the update.

.Parameter NoTest
By default, all functions will be provisioned with two tests - one that tests for complete help, and one 'starter' test skeleton. This forces no test files to be created.

.Parameter Path
Specifies the location where the file(s) should be created. Defaults to the present working directory.

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


#### Name:       new-function
#### Author:     Jim Schell
#### Version:    0.1.9
#### License:    MIT

### Change Log

###### 2016-06-06::0.1.9
- moved creating new tests (not the boilerplate help test) to separate function 'New-FunctionTest'

###### 2016-06-06::0.1.8
- updated to include two tests by default, and added 'noTest' switch to override behavior

###### 2016-06-06::0.1.7
- updated to have verb, noun and parameters capitalize the first letter

###### 2016-06-02::0.1.6
- updated how licenses are loaded, from within the function to reading psd1 files in a folder named 'LICENSE'. New method includes license name (full and short) as well as the URI for the license.

###### 2016-06-02::0.1.5
- update out-file parameters to match intent on 'force' switch - updated to include 'noClobber' option (default = true, force = false)
- updated example where invalid verb used, error message has been improved with the 'throw' behavior
- updated formatting of notes section to simplify rendering of external help/ help as markdown (hurrah for platyPS!)

###### 2016-05-31::0.1.4
- update error handling of parameter validation for 'verb' parameter

###### 2016-05-31::0.1.3
- updated 'overWrite' to 'force'

###### 2016-05-27::0.1.2
- updated 'outToConsole' to 'passThru'

###### 2016-05-27::0.1.1
- after fighting with throw/ trap/ debug, realized that parameter names need to *match* in order to be processed (as expected). Future-Self: Take notes. Spell-check wouldn't be bad either.

###### 2016-05-27::0.1.0
- initial creation after months (?years) of having the idea
#>


    [CmdletBinding()]
    Param(    
        [Parameter(Mandatory = $true)]
        [ValidateScript({ if(get-verb -verb $_){
            return $true }
            Throw "`'$_`' did not match the expected set of approved verbs."
        })]
        [String]
        $Verb,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Noun,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Author,
        
        [Parameter(Mandatory = $false)]
        [System.Version]
        $Version = "0.1.0",
        
        [Parameter(Mandatory = $false)]
        [Array]
        $FunctionParam,
        
        [Parameter(Mandatory = $false)]
        [Array]
        $Link = @("http://example.com"),
        
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
        [switch]
        $LicenseToFile,
        
        [Parameter(Mandatory = $false)]
        [switch]
        $PassThru,

        [Parameter(Mandatory = $false)]
        [switch]
        $Force,
        
        [Parameter(Mandatory = $false)]
        [switch]
        $noTest,

        [Parameter(Mandatory = $false)]
        $Path = $pwd
        
    )
    
    $dateYMD = get-date -UFormat %Y-%m-%d
    $dateYear = get-date -UFormat %Y
    
    $versionAsString = $version.toString()
    
    $verb = "$($verb.Substring(0,1).ToUpper())$($verb.Substring(1).ToLower())"
    $noun = "$($noun.Substring(0,1).ToUpper())$($noun.Substring(1).ToLower())"
    $functionName = "$($verb)-$($noun)"
    $fileName = "$($verb)-$($noun).ps1"
    if( !($functionParam) ){
        $functionParam = @("param1","param2")
    }
    foreach($param in $functionParam){
        $param = $param = "$($param.Substring(0,1).ToUpper())$($param.Substring(1).ToLower())"
        $functionParamUpper += @($param)
    }
    $functionParam = $functionParamUpper
    
    $functionOpen = @"
fuction $($verb)-$($noun){
"@

    
    $commentBasedHelp = @'
    
<#
.Synopsis
Brief overview of the function.

.Description
Detailed description of function.

%%LINK%%

.Example
PS > %%VERB%%-%%NOUN%% 

##Results

Description
-----------
Should describe what just happened.

%%PARAMETER%%

.Notes

%%LICENSE_FULL%%


#### Name:       %%VERB%%-%%NOUN%%
#### Author:     %%AUTHOR%%
#### Version:    %%VERSION%%
#### License:    %%LICENSE_NAME%%

### Change Log

##### %%DATE%%::%%VERSION%%
- initial creation

#>


'@
      
    $functionPreamble = @'

    [CmdletBinding()]
    Param(
    %%PARAM_VALUES%%
    )

'@

    $functionBody = @'

    Begin {
    
    }
    
    Process {
    
    }

    End {
    
    }

}
'@

    $linkForComments = $null
    foreach($uri in $link){
        $newLink = @"

.Link
$uri

"@
        $linkForComments += $newLink
    }
    
    $paramComments = $null
    $paramValues = $null
    foreach($param in $functionParam){
        $newParamComment = @"

.Parameter $param
        
"@
        $paramComments += $newParamComment

        $newParam = @"

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    `$$param,

"@
        $paramValues += $newParam
    }
    
    $licenceFull = Import-LocalizedData -baseDirectory "$psScriptRoot\LICENSE" -fileName "LICENSE_$($licence).psd1"
    $licenseContent = $licenceFull.licenseContent
    $licenseContent = $licenseContent -replace '%%YEAR%%',$dateYear
    $licenseContent = $licenseContent -replace '%%AUTHOR%%',$author
    $licenseName = $licenceFull.licenseName
    
    $commentBasedHelp = $commentBasedHelp -replace '%%LINK%%',$linkForComments
    $commentBasedHelp = $commentBasedHelp -replace '%%VERB%%',$verb
    $commentBasedHelp = $commentBasedHelp -replace '%%NOUN%%',$noun
    $commentBasedHelp = $commentBasedHelp -replace '%%PARAMETER%%',$paramComments
    $commentBasedHelp = $commentBasedHelp -replace '%%LICENSE_FULL%%',$licenseContent
    $commentBasedHelp = $commentBasedHelp -replace '%%AUTHOR%%',$author
    $commentBasedHelp = $commentBasedHelp -replace '%%VERSION%%',$versionAsString
    $commentBasedHelp = $commentBasedHelp -replace '%%LICENSE_NAME%%',$licenseName
    $commentBasedHelp = $commentBasedHelp -replace '%%DATE%%',$dateYMD

    $functionOutput = $null
    $functionOutput += $functionOpen
    $functionOutput += $commentBasedHelp
    $functionOutput += $functionPreamble -replace '%%PARAM_VALUES%%',$paramValues
    $functionOutput += $functionBody
    
    
    
    if( !($noTest) ){
        if( !(Test-Path "$($path)\Tests") ){
            New-Item -Path $path -Name "Tests" -ItemType Directory
        }
        $testPath = "$($path)\Tests"
        
        $helpTestContent = get-content -path "$psScriptRoot\Templates\help.FunctionName.tests.ps1" -raw
        $helpTestContent = $helpTestContent -replace "%%FUNCTION_NAME%%", $functionName
        $helpTestFile = "help.$($functionName).tests.ps1"
        Set-Content -Path "$($testPath)\$($helpTestFile)" -value $helpTestContent -encoding UTF8
        
        $startTestContent = New-FunctionTest -path "$($path)" -FunctionName $functionName
        $startHelpFile = "$($functionName).tests.ps1"
        Set-Content -Path "$($testPath)\$($startHelpFile)" -value $startHelpFile -encoding UTF8
    }
    
    $writeFunctionParam = @{
        InputObject = $functionOutput 
        FilePath = "$($path)\$($fileName)"
        Encoding = "UTF8"
        Force = $false
        NoClobber = $true
    }
    if($Force){
        $writeFunctionParam.Force = $true 
        $writeFunctionParam.NoClobber = $false
    }
    
    out-file @writeFunctionParam
    
    if($licenseToFile){
        $writeLicenseParam = @{
            InputObject = $licenseFull
            FilePath = "$($path)\license.txt"
            Encoding = "UTF8"
            Force = $false
            NoClobber = $true
        }
        if($Force){
            $writeLicenseParam.Force = $true 
            $writeLicenseParam.NoClobber = $false
        }
        Out-File @writeLicenseParam
    }

    if($passThru){
        $functionOutput
    }

}