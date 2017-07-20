#requires -version 4
<#
.SYNOPSIS
  Test if command exists in the environment.

.DESCRIPTION
  A simply script that test if an executable exists in current environment.

.PARAMETER ExeName
  The name of the executable to check.

.INPUTS
  None.

.OUTPUTS
  A boolean response: $true if executable exists, otherwise $false.

.NOTES
  Version:        1.0
  Author:         Roberto Desideri
  Creation Date:  2017-07-13
  Purpose/Change: Initial script development

.EXAMPLE
  .\Test-CommandExists.ps1 git
#>


#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  # Executable name to check
  [Parameter(Mandatory = $true,
    Position = 0)]
  [string]
  $ExeName
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

$ErrorActionPreference = 'Stop'

#-----------------------------------------------------------[Functions]------------------------------------------------------------

try {
  if (Get-Command $ExeName) {
    return $true
  }
}
Catch {
  return $false
}
