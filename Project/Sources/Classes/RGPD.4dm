/* -----------------------------------------------------------------------------
Class : cs.RGPD

Class de gestion du composant RGPD

-----------------------------------------------------------------------------*/

Class constructor($initialisation_b : Boolean; $configChemin_t : Text)
/* -----------------------------------------------------------------------------
Fonction : RGPD.constructor
	
Initialisation du composant
	
Historique
15/02/22 - Rémy Scanu remy@connect-io.fr> - Création
-----------------------------------------------------------------------------*/
	var $fichierConfig_o : cs:C1710.File
	
	If (Bool:C1537($initialisation_b)=True:C214)  // On initialise tout ça uniquement au premier appel (Normalement Sur ouverture de la base)
		MESSAGE:C88("Initialisation du composant cioRGPD")
		
		Use (Storage:C1525)
			Storage:C1525.rgpd:=New shared object:C1526()
		End use 
		
		Case of 
			: (Count parameters:C259=1)
				This:C1470.configChemin:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioMarketingAutomation"+Séparateur dossier:K24:12+"config.json"
			: (String:C10($configChemin_t)="")
				This:C1470.configChemin:=Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioMarketingAutomation"+Séparateur dossier:K24:12+"config.json"
			Else 
				This:C1470.configChemin:=$configChemin_t
		End case 
		
		$fichierConfig_o:=File:C1566(This:C1470.configChemin; fk chemin plateforme:K87:2)
		
		If ($fichierConfig_o.exists=True:C214)
			// Je charge toutes les images
			This:C1470.loadImage()
			
			Use (Storage:C1525.rgpd)
				Storage:C1525.rgpd.config:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525.automation)
			End use 
			
		Else 
			ALERT:C41("Impossible d'intialiser le composant cioRgpd")
		End if 
		
		DELAY PROCESS:C323(Current process:C322; 120)
	End if 