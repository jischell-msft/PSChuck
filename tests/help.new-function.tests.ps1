# https://github.com/devblackops/POSHOrigin/blob/master/Tests/Help.tests.ps1
# https://github.com/juneb/PesterTDD/blob/master/Module.Help.Tests.ps1
# http://www.lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
# ongoing test helper/template for testing help 

# 2016-05-31 update with looking for name, author, version, and license
# 2016-05-27 initial
# 
# help.%%FUNCTION_NAME%%.tests.ps1

$functionName = "New-Function"

. "$($psScriptRoot)\..\public\$($functionName).ps1"

$parameters = (Get-Command -Name $functionName).ParameterSets.Parameters | 
    Sort-Object -Property Name -Unique | Where-Object {$_.name -notIn $commonParam}


    $help = get-help $functionName -ErrorAction SilentlyContinue

Describe "Test help for $functionName" {

    # If help is not found, synopsis in auto-generated help is the syntax diagram
    It "should not be auto-generated" {
        $Help.Synopsis | Should Not BeLike '*`[`<CommonParameters`>`]*'
    }

    # Should be a description for every function
    It "gets description for $functionName" {
        $Help.Description | Should Not BeNullOrEmpty
    }

    # Should be at least one example
    It "gets example code from $functionName" {
        ($Help.Examples.Example | Select-Object -First 1).Code | Should Not BeNullOrEmpty
    }

    # Should be at least one example description
    It "gets example help from $functionName" {
        ($Help.Examples.Example.Remarks | Select-Object -First 1).Text | Should Not BeNullOrEmpty
    }

    Context "Test parameter help for $functionName" {
        
        $commonParam = @(
        'Debug'
        'ErrorAction'
        'ErrorVariable'
        'InformationAction'
        'InformationVariable'
        'OutBuffer'
        'OutVariable'
        'PipelineVariable'
        'Verbose'
        'WarningAction'
        'WarningVariable' 
        )

        $parameters = (Get-Command -Name $functionName).ParameterSets.Parameters | 
            Sort-Object -Property Name -Unique | Where-Object {$_.name -notIn $commonParam}
        
        $parameterNames = $parameters.Name
        $HelpParameterNames = $Help.Parameters.Parameter.Name | Sort-Object -Unique

        foreach ($parameter in $parameters) {
            $parameterName = $parameter.Name
            $parameterHelp = $Help.parameters.parameter | Where-Object Name -EQ $parameterName

            # Should be a description for every parameter
            It "gets help for parameter: $parameterName : in $functionName" {
                $parameterHelp.Description.Text | Should Not BeNullOrEmpty
            }

            # Required value in Help should match IsMandatory property of parameter
            It "help for $parameterName parameter in $functionName has correct Mandatory value" {
                $codeMandatory = $parameter.IsMandatory.toString()
                $parameterHelp.Required | Should Be $codeMandatory
            }

            foreach ($helpParm in $HelpParameterNames) {
                # Shouldn't find extra parameters in help.
                It "finds help parameter in code: $helpParm" {
                    $helpParm -in $parameterNames | Should Be $true
                }
            }
        }
    }
    
    # Notes should exist, contain name of function, author, version, and license
    Context "Test notes for `'$functionName`'" {
        
        $notes = @(($help.AlertSet.Alert.Text) -split '\n')
        
        It "Notes attribute `'name`' should contain $functionName" {
            $notesName = $notes | Select-String -pattern "Name:\s*"
            $notesName | Should Match "Name:\s*$($functionName)"
        }
        
        It "Notes attribute `'author`' should exist" {
            $notesAuthor = $notes | Select-String -pattern "Author:"
            $notesAuthor | Should Match "Author:*"
        }
        
        It "Notes attribute `'version`' should be in System.Version format" {
            $notesVersion = $notes | Select-String -pattern "Version:"
            $notesVersion | Should Match 'Version:\s*(\d{1,9}\.){2,4}'
        }
        
        It "Notes attribute `'license`' should exist" {
            $notesLicense = $notes | Select-String -pattern "License:"
            $notesLicense | Should Match 'License:*'
        }
        
    }
    
}