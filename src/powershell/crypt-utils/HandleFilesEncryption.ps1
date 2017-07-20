param(
  # Path to env file
  [Parameter(Mandatory = $true)]
  [string]
  $FileToProcess,

  # Enable decryption
  [Parameter(Mandatory = $false)]
  [switch]
  $Decryption
)

$ErrorActionPreference = "Stop"
$thisLocation = Get-Location
Set-Location $PSScriptRoot

New-Variable EncodedExtension ".pscredentialencoded" -Option ReadOnly -Force -ErrorAction SilentlyContinue

function Decrypt () {
  try {
    $encrypted = Get-Content $Script:EncFile
    $plain = .\EncryptDecrypt.ps1 $encrypted -Decrypt
    Set-Content $Script:PlainFile $plain -Force -NoNewline
  }
  catch {
    throw $PSItem
  }
  try {
    Remove-Item $Script:EncFile -Force -ErrorAction Stop
  }
  catch {
    Write-Warning "'$Script:EncFile' file has been decrypted into the '$Script:PlainFile' file, but the encrypted '$(Split-Path $Script:EncFile -Leaf)' version still exists. Delete it manually!"
  }
    
}

function Encrypt () {
  try {
    $plain = Get-Content $Script:PlainFile -Raw
    $encrypted = .\EncryptDecrypt.ps1 $plain
    Set-Content $($FileToProcess + $EncodedExtension) -Value $encrypted -Force -NoNewline
  }
  catch {
    throw $PSItem
  }
  try {
    Remove-Item "$FileToProcess" -Force -ErrorAction Stop
  }
  catch {
    Write-Warning "'$Script:PlainFile' file has been encrypted into the '$Script:EncFile' file, but the plain '$(Split-Path $Script:PlainFile -Leaf)' version still exists. Delete it manually!"
  }
}

# Filename helpers
if ($Decryption) {
  if (!$FileToProcess.EndsWith($EncodedExtension)) {
    $FileToProcess = $FileToProcess + $EncodedExtension
  }
  $Script:EncFile = $FileToProcess
  $Script:PlainFile = $FileToProcess -replace ([regex]::Escape($EncodedExtension) + "$"), ""
  Decrypt
}
else {
  $Script:EncFile = $FileToProcess + $EncodedExtension
  $Script:PlainFile = $FileToProcess
  Encrypt
}

Set-Location $thisLocation