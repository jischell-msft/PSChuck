---
external help file: 
schema: 2.0.0
---

# New-Function
## SYNOPSIS
Create a new function, with comment based help.

## SYNTAX

```
New-Function [-Verb] <String> [-Noun] <String> [-Author] <String> [[-Version] <Version>]
 [[-FunctionParam] <Array>] [[-Link] <Array>] [-License] <String> [-LicenseToFile] [-PassThru] [-Force]
 [[-Path] <Object>]
```

## DESCRIPTION
Create a new function, including checking approved verbs, comment based help \(with license, author information, change log, links\), parameters, and the capability to include a separate file that includes the license.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

	PS> new-function -verb notAVerb -noun doesntMatter...
	new-function : Cannot validate argument on parameter 'verb'.
	'notAVerb' did not match the expected set of approved verbs.

Description
-----------
Validation occurs at parameter ingestion, for the 'verb' parameter.
Parameter must be found with 'get-verb -verb $_'.

### -------------------------- EXAMPLE 2 --------------------------

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

## PARAMETERS

### -Verb
Specifies the verb to use for the function name, in the verb-noun convention.
Verb must be found in the approved list of verbs - 'get-verb' will output this list.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Noun
Specifies the noun to use for the function name, in the verb-noun convention.
Currently there is not checking to validate singular form is used ('computer' instead of 'computers'), although this is checked by PSScriptAnalyzer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Author
Specifies the name of the author writing the function.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the version of the function to begin from.

```yaml
Type: Version
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 0.1.0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionParam
Specifies an array of string values to use as parameter names.

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Link
Specifies an array of links that will be added to the comment based help.

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: @("http://example.com")
Accept pipeline input: False
Accept wildcard characters: False
```

### -License
Specifies the license to use, from the set of licenses available and formated in the 'LICENSE' directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 7
Default value: MIT
Accept pipeline input: False
Accept wildcard characters: False
```

### -LicenseToFile
Outputs the content of the license to a file in the same directory as the function.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the content of the newly created function.
By default, this cmdlet will not generate output to the console.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
By default, existing files with the same name will not be over written.
This forces the update.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the location where the file\(s\) should be created.
Defaults to the present working directory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
Default value: $pwd
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
The MIT License \(MIT\) 
Copyright \(c\) 2016 Jim Schell

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files \(the "Software"\), to deal 
in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


#### Name:       new-function
#### Author:     Jim Schell
#### Version:    0.1.6
#### License:    MIT

### Change Log

###### 2016-06-02::0.1.6
- updated how licenses are loaded, from within the function to reading psd1 files in a folder named 'LICENSE'.
New method includes license name \(full and short\) as well as the URI for the license.

###### 2016-06-02::0.1.5
- update out-file parameters to match intent on 'force' switch - updated to include 'noClobber' option \(default = true, force = false\)
- updated example where invalid verb used, error message has been improved with the 'throw' behavior
- updated formatting of notes section to simplify rendering of external help/ help as markdown \(hurrah for platyPS!\)

###### 2016-05-31::0.1.4
- update error handling of parameter validation for 'verb' parameter

###### 2016-05-31::0.1.3
- updated 'overWrite' to 'force'

###### 2016-05-27::0.1.2
- updated 'outToConsole' to 'passThru'

###### 2016-05-27::0.1.1
- after fighting with throw/ trap/ debug, realized that parameter names need to *match* in order to be processed \(as expected\).
Future-Self: Take notes.
Spell-check wouldn't be bad either.

###### 2016-05-27::0.1.0
- initial creation after months \(?years\) of having the idea

## RELATED LINKS

[Online Version:]()


