<#
.SYNOPSIS
  Some parameters and environmental tests shared between public scripts.

.INPUTS
  None. All parameters is retrieved by dynamic scoping.

.OUTPUTS
  None if parameters pass check task, otherwise throw.

.NOTES
  Version:        1.0
  Author:         Roberto Desideri
  Creation Date:  2017-07-13
  Purpose/Change: Initial script development

.EXAMPLE
  .\ParamsCheck.ps1 git
#>

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

# Store actual location
$OriginalLoc = Get-Location

# Change actual location
Set-Location $PSScriptRoot | Out-Null

# Is git present?
# NOTE: is used the parent $GitExePath parameter

$gitOk = .\..\Test-Git.ps1 $GitExePath
if (!$gitOk) {
  if ($GitExePath) {
    throw "Git executable not found in '$GitExePath' path."
  } else {
    throw "Git executable not found in this environment."
  }
}

# Do the GitRepoPath exists?
# NOTE: is used the $GitRepoPath parameter

if (!(Test-Path $GitRepoPath)) {
  throw "$GitRepoPath repo path not found in this environment."
}

# Restore location and return
Set-Location $OriginalLoc | Out-Null