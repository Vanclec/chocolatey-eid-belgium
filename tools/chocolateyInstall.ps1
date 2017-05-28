$ErrorActionPreference	= 'Stop';
$packageName			= 'eid-belgium';
$toolsDir				= ($(Split-Path -Parent $MyInvocation.MyCommand.Definition) + '\');
$url					= 'https://eid.belgium.be/sites/default/files/software/beidmw_32_4.1.20.msi';
$url64					= 'https://eid.belgium.be/sites/default/files/software/beidmw_64_4.1.20.msi';
$checkSum				= '2B93B7AA2ED5441854ACCA435FF9341A75AD4B5EA37778E011174D8568C612D3';
$checkSum64				= '0A7ED9490FE11B7F105CEDE8970A387E8356A90413F2307F593E7714C9E26922';

$packageArgs = @{
	packageName		= $packageName
	unzipLocation	= $toolsDir
	fileType		= 'MSI'
	url				= $url
	url64bit		= $url64
	checkSum		= $checkSum
	checkSum64		= $checkSum64
	checksumType	= 'sha256'
	checksumType64	= 'sha256'
	silentArgs		= "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
	validExitCodes	= @(0, 3010, 1641)
}

CertUtil -AddStore TrustedPublisher ($toolsDir + '\fedict_quickinstall.cer');
Install-ChocolateyPackage @packageArgs;
