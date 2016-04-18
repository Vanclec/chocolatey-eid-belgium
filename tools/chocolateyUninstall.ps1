$ErrorActionPreference = 'Stop';

# Données utilisées au sein de l'installeur
$packageName	= 'eIDBelgium';
$installerType	= 'msi';
$silentArgs		= '/qr /norestart';
$validExitCodes = @(0,3010); # 0 : success. 3010 : redémarrage requis.

# Tentative de désinstallation des éléments du package
Try {
	# Récupération du GUID du package
	$packageGuid = Get-ChildItem HKLM:\SOFTWARE\Classes\Installer\Products |
		Get-ItemProperty -Name 'ProductName' |
		? { $_.ProductName -Like '*e-ID middleware*' } |
		Select -ExpandProperty PSChildName -First 1;
	
	# Récupération du fichier servant à la désinstallation du package
	$InstallProperties = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$packageGuid\InstallProperties;
	$uninstallFile = $InstallProperties.LocalPackage;
	
	# Désinstallation du package
	$msiArgs = "/x $uninstallFile $silentArgs";
	Start-ChocolateyProcessAsAdmin "$msiArgs" 'msiexec' -validExitCodes $validExitCodes;
}

# Quelque chose s'est mal passé, retour avec affichage d'erreur
Catch {
	Throw $_.Exception;
}
