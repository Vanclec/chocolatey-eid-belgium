$ErrorActionPreference = 'Stop';

# Données utilisées au sein de l'installeur
$packageName	= 'eIDBelgium';
$toolsDir		= ($(Split-Path -Parent $MyInvocation.MyCommand.Definition) + '\');
$installerType	= 'msi';
$silentArgs		= '/passive /norestart';
$validExitCodes = @(0,3010); # 0 : success. 3010 : redémarrage requis.

# Pages contenant, respectivement, les MSI d'installation et les certificats racine
$msiPageUrl = 'http://eid.belgium.be/fr/utiliser_votre_eid/besoin_d_aide/problemes_avec_l_installation';
$certPageUrl = 'http://faq.eid.belgium.be/fr/windows_software.html';

# Tentative d'installation des éléments du package
Try {
	# Identification des liens de téléchargement depuis le site de l'eID
	$msiLinks = ((Invoke-WebRequest -UseBasicParsing -Uri $msiPageUrl).Links | Where-Object { $_.href -Like "*.msi" } | Select-Object href).href;
	$msiLink32 = $msiLinks[0];
	$msiLink64 = $msiLinks[1];
	
	
	# Bug : le certificat fournit par Belgium.be ne permet pas l'installation silencieuse du pilote de gestion du lecteur de cartes
	# L'utilisation du certificat importé lors de l'installation classique du Middleware semble fonctionner
	# On zappe toute l'étape de téléchargement et d'import du certificat du site, on installe directement l'autre certificat, fournit dans ce package
	
	# Cheat : le lien pointant vers l'archive des certificats est relatif (../file.zip)
	# $certificatesLink = ('http://faq.eid.belgium.be/void/' + ((Invoke-WebRequest -UseBasicParsing -Uri $certPageUrl).Links | Where-Object { $_.href -Like "*Fedict_Cert*.zip" } | Select-Object href).href);
	# # Téléchargement et extraction des certificats du Fedict
	# Get-ChocolateyWebFile $packageName ($toolsDir + '\Certificates.zip') $certificatesLink;
	# Get-ChocolateyUnzip ($toolsDir + '\Certificates.zip') $toolsDir;
	# CertUtil -AddStore TrustedPublisher ($toolsDir + '\fedict_codesiging.cer');
	CertUtil -AddStore TrustedPublisher ($toolsDir + '\fedict_quickinstall.cer');
	
	
	# Installation du logiciel
	Install-ChocolateyPackage $packageName $installerType $silentArgs $msiLink32 $msiLink64 $validExitCodes;
}

# Quelque chose s'est mal passé, retour avec affichage d'erreur
Catch {
	Throw $_.Exception;
}
