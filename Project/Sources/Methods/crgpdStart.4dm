//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : crgpdStart

Permet de faire l'instanciation de la class RGPD

Historique
15/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
var $fichierConfig_o; $fichierImage_o : 4D:C1709.File
var $blob_b : Blob
var $image_i : Picture

// Chargement des images
Use (Storage:C1525)
	Storage:C1525.image:=New shared object:C1526()
End use 

For each ($fichierImage_o; Folder:C1567(fk dossier ressources:K87:11).folder("Images").files(fk ignorer invisibles:K87:22))
	// Obliger de faire comme ça car BLOB VERS IMAGE($fichierImage_o.getContent(); $image_i) ne fonctionne pas
	$blob_b:=$fichierImage_o.getContent()
	BLOB TO PICTURE:C682($blob_b; $image_i)
	
	Use (Storage:C1525.image)
		Storage:C1525.image[$fichierImage_o.name]:=$image_i
	End use 
	
End for each 

// Chargement du fichier de config
$fichierConfig_o:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/config.json")

If (Not:C34($fichierConfig_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
	$fichierConfig_o.parent.create()
	
	Folder:C1567(fk dossier ressources:K87:11).file("configModel.json").copyTo($fichierConfig_o.parent; $fichierConfig_o.fullName)
End if 

Use (Storage:C1525)
	Storage:C1525.config:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525)
End use 

crgpdToolWindowsForm("FormComponentStart"; "center"; New object:C1471)