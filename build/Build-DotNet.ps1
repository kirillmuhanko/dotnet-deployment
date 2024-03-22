using namespace System.IO

param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the path to the solution.")]
    [string] $SolutionPath,

    [Parameter(Mandatory=$true, HelpMessage="Specify the build configuration (e.g., Debug, Release).")]
    [string] $Configuration
)

Set-StrictMode -Version Latest
$errorActionPreference = 'Stop'

$dotnetCommandPath = (Get-Command dotnet).Path

$dotnetBuildArguments = @(
    'build',
    $SolutionPath,
    '--configuration',
    $Configuration,
    '--no-restore'
)

Invoke-Expression "& `"$dotnetCommandPath`" $dotnetBuildArguments"