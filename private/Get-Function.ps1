function Get-Function {
<#
.Synopsis
Get functions that are able to be dot sourced, for the provided path

.Description
Get functions found in the path provided, and return the result as (an array of) strings.

.Parameter Path
Specifies the path to search for exportable functions.

.Parameter Recurse
By default, search is only one level. This switch will force search to be fully recursive.

.Parameter Unique
By default, results are sorted though not checked for uniqueness. This switch specifies only unique values will be returned.

.Example
    PS > get-function -path $env:USERPROFILE

Description
-----------
Will find any exportable functions that are directly in the path provided.

.Example
    PS > get-function -path $env:USERPROFILE -recurse

Description
-----------
Will find any exportable functions that are directly /or in a child directory/ of the path provided.

.Example
    PS > get-function -path $env:USERPROFILE -unique

Description
-----------
Will find any exportable functions that are directly in the path provided, and return only unique values.

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


#### Name:       get-function
#### Author:     Jim Schell
#### Version:    0.1.0
#### License:    MIT

### Change Log

###### 2016-06-02::0.1.0
- initial creation
- decided to stop repeating looking for exportable functions...

#>


    [CmdletBinding()]
    [OutputType([String[]])]
    Param(
        $path = $pwd,
        
        [switch]$recurse,
        [switch]$unique
    )
    
    $searchParam = @{
        path = "$path\*ps1"
        file = $true
        exclude = "*tests*"
    }
    if($recurse){
        $searchParam += @{ recurse = $true }
    }
    
    $scriptsToCheck =  Get-ChildItem @searchParam
    
    $functionResolved = @()
    foreach( $entry in $scriptsToCheck ){
        $tokens = $null
        $errors = $null
        
        $entryContent = Get-Content -raw -path $entry.fullName
        
        $function = [System.Management.Automation.Language.Parser]::ParseInput( $entryContent, [ref]$tokens, [ref]$errors)
        $functionList = @( $function.findAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}, $false ) )
        
        foreach( $functionFound  in $functionList ){
            $functionResolved += "$($functionFound.name)"
        }
        
    }
    $functionResolved = $functionResolved | Sort-Object
    
    if($unique){
        $functionResolved = $functionResolved | Select-Object -unique
    }
    
    $functionResolved
    
}