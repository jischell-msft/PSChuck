---
external help file: 
schema: 2.0.0
---

# Get-Function
## SYNOPSIS
Get functions that are able to be dot sourced, for the provided path

## SYNTAX

	Get-Function [[-path] <Object>] [-recurse] [-unique]


## DESCRIPTION
Get functions found in the path provided, and return the result as \(an array of\) strings.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

	PS > get-function -path $env:USERPROFILE


Description
-----------
Will find any exportable functions that are directly in the path provided.

### -------------------------- EXAMPLE 2 --------------------------

	PS > get-function -path $env:USERPROFILE -recurse


Description
-----------
Will find any exportable functions that are directly /or in a child directory/ of the path provided.

### -------------------------- EXAMPLE 3 --------------------------

	PS > get-function -path $env:USERPROFILE -unique


Description
-----------
Will find any exportable functions that are directly in the path provided, and return only unique values.

## PARAMETERS

### -Path
Specifies the path to search for exportable functions.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: $pwd
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
By default, search is only one level.
This switch will force search to be fully recursive.

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

### -Unique
By default, results are sorted though not checked for uniqueness.
This switch specifies only unique values will be returned.

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

## INPUTS

## OUTPUTS

### System.String[]

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


#### Name:       get-function
#### Author:     Jim Schell
#### Version:    0.1.0
#### License:    MIT

### Change Log

###### 2016-06-02::0.1.0
- initial creation
- decided to stop repeating looking for exportable functions...

## RELATED LINKS

[Online Version:]()


