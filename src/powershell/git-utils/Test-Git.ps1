#requires -version 4
<#
.SYNOPSIS
  Test if the git executable exists.

.DESCRIPTION
  A simply script that test if the git executable exists.

.PARAMETER GitExePath
  The executable path of git. Default is 'git'.

.INPUTS
  None.

.OUTPUTS
  A boolean response: $true if git exists, otherwise $false.

.NOTES
  Version:        1.0
  Author:         Roberto Desideri
  Creation Date:  2017-07-13
  Purpose/Change: Initial script development

.EXAMPLE
  .\Test-Git.ps1

.EXAMPLE
  .\Test-Git.ps1 "C:/user/git.exe"
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

param(
  # Literal path to git executable file.
  [Parameter(Mandatory=$false,
             Position=1,
             ValueFromPipelineByPropertyName=$false,
             HelpMessage="Literal path to git executable.")]
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

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$Script:Out = $false

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Is git present?
if ($GitExePath) {
  $Git = Test-Path $GitExePath -PathType File
} else {
  $Git = .\utils\Test-CommandExists.ps1 'git'
}

if ($Git) {
  Write-Verbose "Git executable found at '$($Out.Source)' path."
  $Script:Out = $true
} else {
  if ($GitExePath) {
    Write-Verbose "Git executable not found at '$GitExePath' path."
  } else {
    Write-Verbose "Git executable not found."
  }
}

# Restore location and return
Set-Location $OriginalLoc | Out-Null
return $Script:Out