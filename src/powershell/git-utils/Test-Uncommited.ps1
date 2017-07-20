#requires -version 4
<#
.SYNOPSIS
  Test if there are uncommited files in current git master branch.

.DESCRIPTION
  A simply script that test if there are uncommited files in current git master branch by git executable, through the 'diff-index --name-only HEAD --' command.

.PARAMETER GitRepoPath
  The root path of git repo.

.PARAMETER GitExePath
  The executable path of git. Default is 'git'.

.INPUTS
  None.

.OUTPUTS
  A boolean response: $true if there are uncommited files, otherwise $false.

.NOTES
  Version:        1.0
  Author:         Roberto Desideri
  Creation Date:  2017-07-13
  Purpose/Change: Initial script development

.EXAMPLE
  .\Test-Uncommited.ps1 "path/to/git/repo"

.EXAMPLE
  .\Test-Uncommited.ps1 "path/to/git/repo" "C:/user/git.exe"
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
$changes = & "$Git diff-index --name-only HEAD --"
if ($changes.length -gt 0) { $out = $true }

# Restore location and return
Set-Location $OriginalLoc | Out-Null
return $Out
