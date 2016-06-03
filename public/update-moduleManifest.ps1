function update-moduleManifest {
<#

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


#### Name:       new-module
#### Author:     Jim Schell
#### Version:    0.1.0
#### License:    MIT

### Change Log

###### 2016-06-02::0.1.0
- initial creation
- building out the rest of scaffolding

#>


    [CmdletBinding()]
    Param(
        $path,
        
        $version
    )
    
    if(Test-Path $path\*psm1){
        Write-Verbose "Found the module file!"
    }
    else {
        $msgModuleNotFound = "Could not find a module file with `'PSM1`' extension on `'$($path)`'."
        Throw $msgModuleNotFound
    }
    
    $publicFolder = "$path\public"
    
    $functionToExport = @( get-function -path $publicFolder -unique )
    
    if($functionToExport.count -lt 1){
        $msgNoFunctionForExport = "Could not find any functions to export in `'$($publicFolder)`'."
        Throw $msgNoFunctionForExport
    }
    
    $functionsToExportOpen = @"

FunctionsToExport = @(

"@
    $functionsToExportContent = $functionsToExportOpen
    
    $functionCount = 0
    foreach($publicFunction in $functionToExport){
        $functionCount++
        if( $functionCount -lt $functionToExport.count ){
        $include = @"
    '$($publicFunction)',

"@
        }
        else{
        $include = @"
    '$($publicFunction)'

"@
        }
        $functionsToExportContent += $include
    }
    $functionsToExportContent += @"
)
"@

}