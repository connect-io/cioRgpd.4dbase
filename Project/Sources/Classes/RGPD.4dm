/*------------------------------------------------------------------------------
Class : cs.RGPD

Class de gestion du composant RGPD

------------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $configChemin_t : Text)
/*------------------------------------------------------------------------------
Fonction : RGPD.constructor
	
Initialisation du composant
	
Historique
15/02/22 - Rémy Scanu remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
	var $fichierConfig_o : cs:C1710.File
	var $class_o : Object
	
	If (Bool:C1537($initialisation_b)=True:C214)  // On initialise tout ça uniquement au premier appel (Normalement Sur ouverture de la base)
		MESSAGE:C88("Initialisation du composant cioRGPD")
		
		Case of 
			: (Count parameters:C259=1)
				This:C1470.configChemin:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioRgpd"+Séparateur dossier:K24:12+"config.json"
			: (String:C10($configChemin_t)="")
				This:C1470.configChemin:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioRgpd"+Séparateur dossier:K24:12+"config.json"
			Else 
				This:C1470.configChemin:=$configChemin_t
		End case 
		
		$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk chemin plateforme:K87:2)
		
		If ($fichierConfig_o.exists=True:C214)
			// Je charge toutes les images
			This:C1470.loadImage()
			
			Use (Storage:C1525)
				Storage:C1525.rgpd:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525)
			End use 
			
		Else 
			ALERT:C41("Impossible d'intialiser le composant cioRgpd")
		End if 
		
		DELAY PROCESS:C323(Current process:C322; 120)
	End if 
	
Function loadImage
/*------------------------------------------------------------------------------
Fonction : RGPD.loadImage
	
Charge dans This, toutes les images mises dans le dossier /Resources/Images/ du composant
	
Historique
16/03/22 - Rémy Scanu <remy@connect-io.fr> - Ajout entête
------------------------------------------------------------------------------*/
	var ${1} : Text  // Nom de l'image
	
	var $fichier_o : 4D:C1709.File
	var $dossier_o : 4D:C1709.Folder
	var $blob_b : Blob
	var $image_i : Picture
	var $image_o : Object
	
	$image_o:=New object:C1471()
	$dossier_o:=Folder:C1567(Get 4D folder:C485(Dossier Resources courant:K5:16)+"Images"+Séparateur dossier:K24:12; fk chemin plateforme:K87:2)
	
	For each ($fichier_o; $dossier_o.files(fk ignorer invisibles:K87:22))
		$blob_b:=$fichier_o.getContent()
		BLOB TO PICTURE:C682($blob_b; $image_i)
		
		$image_o[$fichier_o.name]:=$image_i
	End for each 
	
	Use (Storage:C1525)
		Storage:C1525.image:=OB Copy:C1225($image_o; ck shared:K85:29; Storage:C1525)
	End use 