var $fichier_o : 4D:C1709.File

Case of 
	: (Form event code:C388=Sur clic:K2:4)
		$fichier_o:=File:C1566(Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioRgpd"+Séparateur dossier:K24:12+"config.json"; fk chemin plateforme:K87:2)
		
		If ($fichier_o.exists=True:C214)
			OPEN URL:C673($fichier_o.platformPath)
		Else 
			ALERT:C41("Le fichier de configuration n'est pas présent dans le dossier Resources du composant")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 