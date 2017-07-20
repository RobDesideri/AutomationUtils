#requires -version 4
<#
.SYNOPSIS
  Test if we are in a git master branch or not.

.DESCRIPTION
  A simply script that test if we are in master branch by git executable, through the 'rev-parse --abbrev-ref HEAD' command.

.PARAMETER GitRepoPath
  The root path of git repo.

.PARAMETER GitExePath
  The executable path of git. Default is 'git'.

.INPUTS
  None.

.OUTPUTS
  A boolean response: $true if we are in master branch, otherwise $false.

.NOTES
  Version:        1.0
  Author:         Roberto Desideri
  Creation Date:  2017-07-13
  Purpose/Change: Initial script development

.EXAMPLE
  .\Test-MasterBranch.ps1 "path/to/git/repo"

.EXAMPLE
  .\Test-MasterBranch.ps1 "path/to/git/repo" "C:/user/git.exe"
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

param(
  # Literal path to git repo.
  [Parameter(Mandatory=$true,
             Position=0,
             ValueFromPipelineByPropertyName=$false,
             HelpMessage="Literal path to git repository.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $GitRepoPath,

  # Literal path to git executable file.
  [Parameter(Mandatory=$false,
             Position=1,
             ValueFromPipelineByPropertyName=$false,
             HelpMessage="Literal path to git executable.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $GitExePath
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

# Store actual location
$OriginalLoc = Get-Location

# Change actual location
Set-Location $PSScriptRoot | Out-Null
#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Check parameters & environment validity
.\private\Check.ps1

# We are in 'master' branch?
$Out = $false
Set-Location $GitRepoPath | Out-Null
$branch = & "$Git rev-parse --abbrev-ref HEAD"
if ($branch -eq "master") { $out = $true }

# Restore location and return
Set-Location $OriginalLoc | Out-Null
return $Out