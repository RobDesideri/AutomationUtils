
param(
  # Path to env file
  [Parameter(Mandatory = $true)]
  [string]
  $EnvFile
)

$outEnvHash = @{}
function ReadEnv () {
  $envContent = $(Get-Content $EnvFile -Raw).Split("`n")
  foreach ($r in $envContent) {
    if ($($r.Trim())) {
      $r -match '^.*='
      $key = $($($Matches[0].Trim()).Replace('=', '')).Trim()
      $value = $($r.Replace($Matches[0], '')).Trim()
      $outEnvHash.Add($key, $value) 
    }
  }
}

ReadEnv | Out-Null
return $outEnvHash