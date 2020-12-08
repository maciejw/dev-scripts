Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1';

function CartesianProduct($setA, $setB) {
  $setA | ForEach-Object { $a = $_; $setB | ForEach-Object { , @($a; $_ ) } } 
}

function Install {
  [CmdletBinding()]
  param (
    $installs
  ) 
  $installs | ForEach-Object { .\dotnet-install.ps1 -Runtime $_[0] -Channel $_[1] -Architecture 'x64' -Version 'latest' -NoPath -InstallDir 'c:\Program Files\dotnet' }
  $installs | ForEach-Object { .\dotnet-install.ps1 -Runtime $_[0] -Channel $_[1] -Architecture 'x86' -Version 'latest' -NoPath -InstallDir 'c:\Program Files (x86)\dotnet' }
}

$runtimes1 = @('dotnet')

$channels1 = @('1.0', '1.1', '2.0')

$runtimes2 = @('dotnet', 'aspnetcore')

$channels2 = @('2.1', '2.2')

$runtimes3 = @('dotnet', 'aspnetcore', 'windowsdesktop')

$channels3 = @('3.0', '3.1')

Install(CartesianProduct $runtimes1 $channels1)
Install(CartesianProduct $runtimes2 $channels2)
Install(CartesianProduct $runtimes3 $channels3)

Remove-Item .\dotnet-install.ps1
