//%attributes = {}
var $fichierConfig_o : 4D:C1709.File
var $fichierImage_o : 4D:C1709.file
var $image_i : Picture

// Chargement des images
Use (Storage:C1525)
	Storage:C1525.image:=New shared object:C1526()
End use 

For each ($fichierImage_o; Folder:C1567(fk dossier ressources:K87:11).folder("Images").files(fk ignorer invisibles:K87:22))
	BLOB TO PICTURE:C682($fichierImage_o.getContent(); $image_i)
	
	Use (Storage:C1525.image)
		Storage:C1525.image[$fichierImage_o.name]:=$image_i
	End use 
	
End for each 

// Chargement du fichier de config
$fichierConfig_o:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/config.json")

If (Not:C34($fichierConfig_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génére.
	$fichierConfig_o.parent.create()
	
	Folder:C1567(fk dossier ressources:K87:11).file("configModel.json").copyTo($fichierConfig_o.parent; $fichierConfig_o.fullName)
End if 

Use (Storage:C1525)
	Storage:C1525.config:=OB Copy:C1225(JSON Parse:C1218($fichierConfig_o.getText()); ck shared:K85:29; Storage:C1525)
End use 