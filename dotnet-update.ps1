Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1';

function cartesianProduct($setA, $setB) {
  $setA | % { $a = $_; $setB | % { , @($a; $_ ) } } 
}

function install($installs) { 
  $installs | % { .\dotnet-install.ps1 -Runtime $_[0] -Channel $_[1] -Architecture 'x64' -Version 'latest' -NoPath -InstallDir 'c:\Program Files\dotnet' }
  $installs | % { .\dotnet-install.ps1 -Runtime $_[0] -Channel $_[1] -Architecture 'x86' -Version 'latest' -NoPath -InstallDir 'c:\Program Files (x86)\dotnet' }
}

$runtimes1 = @('dotnet')

$channels1 = @('1.0', '1.1', '2.0')

$runtimes2 = @('dotnet', 'aspnetcore')

$channels2 = @('2.1', '2.2')

$runtimes3 = @('dotnet', 'aspnetcore', 'windowsdesktop')

$channels3 = @('3.0', '3.1')

install(cartesianProduct $runtimes1 $channels1)
install(cartesianProduct $runtimes2 $channels2)
install(cartesianProduct $runtimes3 $channels3)
del .\dotnet-install.ps1
