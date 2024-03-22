using namespace System

class BuildLogger {
    static [bool] IsTeamCity() {
        return Test-Path env:TEAMCITY_VERSION
    }

    static [void] LogProgress([string] $stepDescription) {
        if ([BuildLogger]::IsTeamCity()) {
            $escapedText = [BuildLogger]::EscapeForTeamCity($stepDescription)
            Write-Host "##teamcity[progressMessage '$escapedText']"
        } else {
            Write-Host "`n[STEP] $stepDescription`n"
        }
    }

    static [void] LogStartProgress([string] $stepDescription) {
        if ([BuildLogger]::IsTeamCity()) {
            $escapedText = [BuildLogger]::EscapeForTeamCity($stepDescription)
            Write-Host "##teamcity[progressStart '$escapedText']"
            Write-Host "##teamcity[blockOpened name='$escapedText']"
        } else {
            Write-Host "`n[START] $stepDescription`n"
        }
    }

    static [void] LogEndProgress([string] $stepDescription) {
        if ([BuildLogger]::IsTeamCity()) {
            $escapedText = [BuildLogger]::EscapeForTeamCity($stepDescription)
            Write-Host "##teamcity[blockClosed name='$escapedText']"
            Write-Host "##teamcity[progressEnd '$escapedText']"
        } else {
            Write-Host "`n[END] $stepDescription`n"
        }
    }

    static [void] LogProgressBlock([string] $stepDescription, [Func[object]] $task) {
        [BuildLogger]::LogStartProgress($stepDescription)
        $task.Invoke() | Out-Host
        [BuildLogger]::LogEndProgress($stepDescription)
    }

    static [void] LogBuildProblem([string] $description) {
        if ([BuildLogger]::IsTeamCity()) {
            $escapedText = [BuildLogger]::EscapeForTeamCity($description)
            Write-Host "##teamcity[buildProblem description='$escapedText']"
        } else {
            Write-Error "Error: $description"
        }
    }

    static [void] LogErrorRecord([System.Management.Automation.ErrorRecord] $errorRecord) {
        [BuildLogger]::LogBuildProblem([BuildLogger]::FormatErrorRecord($errorRecord))
    }

    hidden static [string] EscapeForTeamCity([string] $text) {
        if ([string]::IsNullOrEmpty($text)) {
            return $text
        }

        $escapedText = $text.
            Replace('|', '||').
            Replace("`n", '|n').
            Replace("`r", '|r').
            Replace("'", "|'").
            Replace('[', '|[').
            Replace(']', '|]')

        return $escapedText
    }

    hidden static [string] FormatErrorRecord([System.Management.Automation.ErrorRecord] $errorRecord) {
        $errors = @()
        $errors += ($errorRecord | Format-List * -Force) | Out-String
        $errors += ($errorRecord.InvocationInfo | Format-List *) | Out-String
        $exception = $errorRecord.Exception

        for ($i = 0; $exception; $i++, ($exception = $exception.InnerException)) {  
            $errors += ("$i" * 80) | Out-String
            $errors += ($exception | Format-List * -Force) | Out-String
        }

        return $errors -join "`n"
    }
}