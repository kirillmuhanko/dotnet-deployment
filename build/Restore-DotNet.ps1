using namespace System.IO

param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the path to the solution.")]
    [string] $SolutionPath
)

Set-StrictMode -Version Latest
$errorActionPreference = 'Stop'

$dotnetCommandPath = (Get-Command dotnet).Path

$dotnetRestoreArguments = @(
    'restore'
    $SolutionPath,
    '--locked-mode'
) 

Invoke-Expression "& `"$dotnetCommandPath`" $dotnetRestoreArguments"