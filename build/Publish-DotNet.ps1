using namespace System.IO

param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the path to the solution.")]
    [string] $SolutionPath,

    [Parameter(Mandatory=$true, HelpMessage="Specify the build configuration (e.g., Debug, Release).")]
    [string] $Configuration,

    [Parameter(Mandatory=$true, HelpMessage="Specify the output directory for publishing.")]
    [string] $OutputDirectory
)

Set-StrictMode -Version Latest
$errorActionPreference = 'Stop'

$dotnetCommandPath = (Get-Command dotnet).Path

$dotnePublishtArguments = @(
    'publish',
    $SolutionPath,
    '--configuration', 
    $Configuration,
    '--no-build',
    '--output', 
    $OutputDirectory
)

Invoke-Expression "& `"$dotnetCommandPath`" $dotnePublishtArguments"