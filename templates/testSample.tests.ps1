$functionName = "%%FUNCTION_NAME%%"

if( ($psScriptRoot -match ("\\Test\\|\\Tests\\") ) {
    $functionPath = Get-ChildItem -path $psScriptRoot\.. -filter "$($functionName).ps1" -recurse
    $function = . "$(functionPath.FullName)"
}
else {
    $function = . "$($psScriptRoot)\$($functionName).ps1"
}

Describe "%%FUNCTION_NAME%%" {
    Context "Parameter Validation"{
    
        It 'Parameter Param1 exists, is Mandatory:True'{
            $function.Parameters.Keys.Contains("Param1") | Should Be $True
            $function.Parameters.Param1.Attributes.Manadatory | Should Be $True
        }
    
        It 'Parameter Param2 exists, is Mandatory:True'{
            $function.Parameters.Keys.Contains("Param2") | Should Be $True
            $function.Parameters.Param2.Attributes.Manadatory | Should Be $True
        }
        
        It 'Parameter Param3 exists, is Mandatory:True'{
            $function.Parameters.Keys.Contains("Param3") | Should Be $True
            $function.Parameters.Param3.Attributes.Manadatory | Should Be $True
        }
    }
    
    Context "Expected Behavior" {
    
        It 'should return a string object' {
            $result = $functionName -Param1 "Sun" -Param2 3 -Param3 "sdf"
            $result.GetType().FullName | Should Be "System.String"
        }
        
    }
    
}