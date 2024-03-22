using module '.\BuildLogger.psm1'

using namespace System
using namespace System.IO

Set-StrictMode -Version Latest
$errorActionPreference = 'Stop'

function Main {
    $projectRootPath = [Path]::GetFullPath([Path]::Combine($PSScriptRoot, '..\'))
    $solutionPath = Join-Path $projectRootPath 'Solution1.sln'
    $distDirectory = [Path]::GetFullPath([Path]::Combine($projectRootPath, 'dist\'))

    [BuildLogger]::LogProgressBlock('Starting restore process.', {
        $restoreScriptPath = Join-Path $PSScriptRoot 'Restore-DotNet.ps1'
        $restoreScriptArguments = @($solutionPath)

        Write-Host "Executing restore script: $restoreScriptPath with arguments: $restoreScriptArguments"
        Invoke-Expression "& `"$restoreScriptPath`" $restoreScriptArguments"
    })

    [BuildLogger]::LogProgressBlock('Starting build process.', {
        $buildScriptPath = Join-Path $PSScriptRoot 'Build-DotNet.ps1'
        $buildScriptArguments = @($solutionPath, 'Debug')

        Write-Host "Executing build script: $buildScriptPath with arguments: $buildScriptArguments"
        Invoke-Expression "& `"$buildScriptPath`" $buildScriptArguments"
    })

    [BuildLogger]::LogProgressBlock('Starting publish process.', {
        $publishScriptPath = Join-Path $PSScriptRoot 'Publish-DotNet.ps1'
        $publishScriptArguments = @($solutionPath, 'Debug', $distDirectory)

        Write-Host "Executing publish script: $publishScriptPath with arguments: $publishScriptArguments"
        Invoke-Expression "& `"$publishScriptPath`" $publishScriptArguments"
    })
}

try {
    Main
} catch {
    $errorMessage = $_.Exception.Message
    [BuildLogger]::LogErrorRecord("Error occurred: $errorMessage")
    [Environment]::Exit(1)
}