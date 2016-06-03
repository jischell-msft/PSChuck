---
external help file: 
schema: 2.0.0
---

# new-module
## SYNOPSIS
Create a new module.

## SYNTAX

```
new-module [-ModuleName] <String> [-Author] <String> [[-Version] <Version>] [-License] <String>
 [[-Path] <Object>]
```

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
new-module
```

Description
-----------
does something

## PARAMETERS

### -ModuleName
Specifies name to be used for the module.

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

### -Author
Specifies author of the module.

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

### -Version
Specifies the version of the module.

```yaml
Type: Version
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 0.1.0
Accept pipeline input: False
Accept wildcard characters: False
```

### -License
Specifies the license to release the module under.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: MIT
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the parent path where the module folder and files will be created.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: $pwd
Accept pipeline input: False
Accept wildcard characters: False
```

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


#### Name:       new-module
#### Author:     Jim Schell
#### Version:    0.1.1
#### License:    MIT

### Change Log

###### 2016-06-03::0.1.1
- added the rest of the help sections \(bare\).
need to go back and fill in examples, synopsis, description

###### 2016-06-01::0.1.0
- initial creation
- building out the rest of scaffolding

## RELATED LINKS

[Online Version:]()

