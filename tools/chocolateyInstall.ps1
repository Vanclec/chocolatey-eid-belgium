$ErrorActionPreference	= 'Stop';
$packageName			= 'eid-belgium';
$toolsDir				= ($(Split-Path -Parent $MyInvocation.MyCommand.Definition) + '\');
$url					= 'https://downloads.services.belgium.be/eid/BeidMW_32_4.1.18.msi';
$url64					= 'https://downloads.services.belgium.be/eid/BeidMW_64_4.1.18.msi';

$packageArgs = @{
	packageName		= $packageName
	unzipLocation	= $toolsDir
	fileType		= 'MSI'
	url				= $url
	url64bit		= $url64
	silentArgs		= "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
	validExitCodes	= @(0, 3010, 1641)
}

CertUtil -AddStore TrustedPublisher ($toolsDir + '\fedict_quickinstall.cer');
Install-ChocolateyPackage @packageArgs;
