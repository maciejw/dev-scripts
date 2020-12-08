[CmdletBinding()]
param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]
  $useVersion,
  [Parameter(Mandatory = $false)]
  [string]
  $nodeInstallDirectory = 'c:\node'
)


function GetLatestNodeVersion {
  param (
    $version,
    $platform = 'win',
    $cpu = 'x64'
  )
  $response = Invoke-WebRequest "https://nodejs.org/dist/latest-$version.x/"
  $response.Links | Where-Object href -Match "node-.*-$platform-$cpu.zip" | Select-Object -ExpandProperty href | Split-Path -LeafBase
}

function DownloadNode {
  param (
    $nodeInstallDirectory,
    $version,
    $latestNodeVersion
  )
  $nodeArchive = "$latestNodeVersion.zip"
  Invoke-WebRequest "https://nodejs.org/dist/latest-$version.x/$nodeArchive" -OutFile $nodeArchive
  Expand-Archive $nodeArchive -DestinationPath $nodeInstallDirectory
  Remove-Item $nodeArchive
  Write-Output "@call $nodeInstallDirectory\$nodeDirectory\nodevars.bat">"$nodeInstallDirectory\use-$version.cmd"
}

function SetCurrentVersion {
  param (
    $nodeInstallDirectory,
    $nodeDirectory
  )
  $current = "$nodeInstallDirectory\current"
  Get-Item $current | Remove-Item 
  New-Item -ItemType Junction $current -Value "$nodeInstallDirectory\$nodeDirectory" | Select-Object -ExpandProperty NameString 
  Write-Output "@call $current\nodevars.bat">"$nodeInstallDirectory\use.cmd"
}

function Update {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [string]
    $version,
    [Parameter(Mandatory, Position = 0)]
    [string]
    $useVersion,
    [Parameter(Mandatory, Position = 1)]
    [string]
    $nodeInstallDirectory
  )
  process {

    $nodeDirectory = GetLatestNodeVersion $version
  
    if (-not (Test-Path "$nodeInstallDirectory\$nodeDirectory") ) {
      Remove-Item "$nodeInstallDirectory\node-$version*" -Recurse -Force
      DownloadNode -nodeInstallDirectory $nodeInstallDirectory -version $version -latestNodeVersion $nodeDirectory
      Write-Host "$version updated"
    }
    else {
      Write-Host "$version up to date"
    }
  
    if ($useVersion -eq $version) {
      SetCurrentVersion -nodeInstallDirectory $nodeInstallDirectory -nodeDirectory $nodeDirectory 
    }
  }
}

'v10', 'v12', 'v14', 'v15' | Update $useVersion $nodeInstallDirectory
