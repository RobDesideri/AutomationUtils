# Execute the git push to target repository

param(
  # Path of git repo
  [Parameter(Mandatory = $true, Position = 1)]
  [string]
  $RemotePath
)

$out = & "$($Global:BIN.git) push $RemoteName master --force  2>&1"
if ($LASTEXITCODE -ne 0) {
  throw "Git error on push into dist\$Global:TargetEnv`nGit error: $out"
}

