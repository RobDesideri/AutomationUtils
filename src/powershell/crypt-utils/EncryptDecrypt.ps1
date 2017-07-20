
param(
  # Specifies a path to one or more locations.
  [Parameter(Mandatory = $true,
    Position = 0,
    HelpMessage = "Path to file to encrypt / decrypt.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $String,

  # Decrypt switch, otherwise the script wiil encrypt
  [Parameter(Mandatory = $false)]
  [switch]
  $Decrypt
)

$ErrorActionPreference = "Stop"
$ErrorFrom = "ERROR from $(Split-Path $PSScriptRoot -Leaf):"
$Script:String = $String

function Encrypt() {
  try {
    $plain = $Script:String
    $secure = ConvertTo-SecureString $plain -asPlainText -force
    $encrypted = $secure | ConvertFrom-SecureString
    Write-Verbose "'$FilePath' file has been encrypted."
    return $encrypted
  }
  catch {
    throw "$ErrorFrom'$FilePath 'file encryption failed.`n$PSItem"
  }
}

function Decrypt() {
  try {
    $encrypted = $Script:String
    $secure = ConvertTo-SecureString $encrypted
    $helper = New-Object system.Management.Automation.PSCredential("test", $secure)
    $plain = $helper.GetNetworkCredential().Password
    $plain = $plain -replace $rgx, ''
    Write-Verbose "'$FilePath' file has been decrypted."
    return $plain
  }
  catch {
    throw "$ErrorFrom'$FilePath 'file decryption failed.`n$PSItem"
  }
}

if ($Decrypt) {
  return $(Decrypt $String)
}
else {
  return $(Encrypt $String)
}