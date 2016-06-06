function New-FunctionTest {
<#
.Synopsis
Create a new function test.

.Description
Create a new function test, enumerate non-common parameters and add to the test.

.Example
    PS > New-FunctionTest -functionName "get-verb" -path "$env:UserProfile\scripts"

Description
-----------
Creates a test for the function "get-verb".

.Outputs
Returns a the test as an array of strings.

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


#### Name:       New-FunctionTest
#### Author:     Jim Schell
#### Version:    0.1.1
#### License:    MIT

### Change Log

###### 2016-06-06::0.1.1
- significant whack-a-mole process for validating all the here-strings are properly escaped...

###### 2016-06-06::0.1.0
- initial creation

#>


    [CmdletBinding()]
    [OutputType([String[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [String]
        $FunctionName,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    
    )

    $dateYMD = get-date -UFormat %Y-%m-%d
    
    if( Test-Path "$($path)\$($FunctionName).ps1" ){
        $functionPath = "$($path)\$($FunctionName).ps1"
    }
    else{
        Throw "Could not find $($functionName)"
    }
    . "$($functionPath)"
    
    $starterTest = @'
<#
Auto-Generated by New-FunctionTest, a PSChuck tool.

Created on %%DATE%%
#>
'@

    $starterTest += @"

`$functionName = "%%FUNCTION_NAME%%"

if( (`$psScriptRoot -match ("\\Test\\|\\Tests\\") ) {
    `$functionPath = Get-ChildItem -path `$psScriptRoot\.. -filter "`$(`$functionName).ps1" -recurse
    `$function = . "`$(`$functionPath.FullName)"
}
else {
    `$function = . "`$(`$psScriptRoot)\`$(`$functionName).ps1"
}

Describe "%%FUNCTION_NAME%%" {
    Context "Parameter Validation"{
        %%ParamBasics%%
    
    }
    
    Context "Expected Behavior" {
        %%ExpectedBehavior%%      
    }
    
}    
"@
    
    # $pathToTemplateTest = "$psScriptRoot\Templates\FunctionName.tests.ps1"
    # $starterTest = Get-Content -path $pathToTemplateTest -raw
    
    $functionParameters = (Get-Command $($functionName) ).Parameters.Values
    $commonParameters = (Get-Command Get-CommonParameter).Parameters.Keys

    if( $functionParameters.count -gt $commonParameters.count){
        Write-Verbose "We have parameters for adding to a test."
    }
    else {
        Write-Verbose "We have no non-common parameters."
    }
    
    $functionParametersUnique = $functionParameters | Where-Object {$_.Name -notIn $commonParameters}
    
    $paramBasicAddToTest = $null
    $paramExpectedAddToTest = $null
    
    foreach($parameter in $functionParametersUnique){
        $parameterName = $parameter.Name
        $parameterType = $parameter.ParameterType
        $isMandatory = $parameter.Attributes.Mandatory
        
        $paramBasicTest = @"

        It 'Parameter $parameterName Exists, is Mandatory:$isMandatory' {
            `$function.Parameters.Keys.Contains("$parameterName") | Should Be `$True
            `$function.Parameters.$parameterName.Attributes.Mandatory | Should Be `$$isMandatory
        }

"@
        $paramBasicAddToTest += $paramBasicTest
        
        $paramExpectedTest = @"
        
        It 'Parameter $parameterName should behave like this'{
        #Blank on purpose, to be filled by humans
        }
      
"@
        $paramExpectedAddToTest += $paramExpectedTest
    }

    $starterTest = $starterTest -replace "%%FUNCTION_NAME%%",$FunctionName
    $starterTest = $starterTest -replace "%%ParamBasics%%",$paramBasicAddToTest
    $starterTest = $starterTest -replace "%%ExpectedBehavior%%",$paramExpectedAddToTest
    $starterTest = $starterTest -replace "%%DATE%%",$dateYMD
    
    $starterTest

}