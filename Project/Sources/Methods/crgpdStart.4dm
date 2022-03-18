//%attributes = {"shared":true}
/* -----------------------------------------------------------------------------
Méthode : crgpdStart

Permet de faire l'instanciation de la class RGPD

Historique
15/02/22 - Rémy Scanu <remy@connect-io.fr> - Création
------------------------------------------------------------------------------*/
var $i_el; $j_el : Integer
var $blob_b : Blob
var $image_i : Picture
var $configFile_o; $imageFile_o; $personFile_o : 4D:C1709.File

// Chargement des images
Use (Storage:C1525)
	Storage:C1525.image:=New shared object:C1526()
End use 

For each ($imageFile_o; Folder:C1567(fk dossier ressources:K87:11).folder("Images").files(fk ignorer invisibles:K87:22))
	// Obliger de faire comme ça car BLOB VERS IMAGE($imageFile_o.getContent(); $image_i) ne fonctionne pas
	$blob_b:=$imageFile_o.getContent()
	BLOB TO PICTURE:C682($blob_b; $image_i)
	
	Use (Storage:C1525.image)
		Storage:C1525.image[$imageFile_o.name]:=$image_i
	End use 
	
End for each 

// Chargement du fichier de config
$configFile_o:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/config.json")

If (Not:C34($configFile_o.exists))  // Il n'existe pas de fichier de config dans la base hote, on le génère.
	Folder:C1567(fk dossier ressources:K87:11).file("configModel.json").copyTo($configFile_o.parent; $configFile_o.fullName)
End if 

Use (Storage:C1525)
	Storage:C1525.config:=OB Copy:C1225(JSON Parse:C1218($configFile_o.getText()); ck shared:K85:29; Storage:C1525)
End use 

// Chargement du fichier des relations si il n'existe pas...
Use (Storage:C1525)
	Storage:C1525.relation_f:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/relation.json")
End use 

If (Storage:C1525.relation_f.exists=False:C215)
	$content_o:=New object:C1471("detail"; New collection:C1472())
	Storage:C1525.relation_f.setText(JSON Stringify:C1217($content_o; *))
End if 

// Chargement des fichiers nécessaires pour la création de profil aléatoire
Use (Storage:C1525)
	Storage:C1525.person_f:=Folder:C1567(fk dossier ressources:K87:11; *).file("cioRgpd/person.jsonc")
End use 

If (Storage:C1525.person_f.exists=False:C215)
	Folder:C1567(fk dossier ressources:K87:11).file("person.jsonc").copyTo(Storage:C1525.person_f.parent; Storage:C1525.person_f.fullName)
End if 

// Chargement du détail de la structure de la base hôte
Use (Storage:C1525)
	Storage:C1525.structureDetail:=New shared collection:C1527
	
	For ($i_el; 1; Get last table number:C254)
		
		If (Is table number valid:C999($i_el)=True:C214)
			
			Use (Storage:C1525.structureDetail)
				Storage:C1525.structureDetail.push(New shared object:C1526)
				
				Use (Storage:C1525.structureDetail[Storage:C1525.structureDetail.length-1])
					Storage:C1525.structureDetail[Storage:C1525.structureDetail.length-1].table:=Table name:C256($i_el)
					Storage:C1525.structureDetail[Storage:C1525.structureDetail.length-1].champ:=New shared collection:C1527
				End use 
				
			End use 
			
			For ($j_el; 1; Get last field number:C255($i_el))
				
				If (Is field number valid:C1000($i_el; $j_el)=True:C214)
					
					Use (Storage:C1525.structureDetail[Storage:C1525.structureDetail.length-1].champ)
						Storage:C1525.structureDetail[Storage:C1525.structureDetail.length-1].champ.push(Field name:C257($i_el; $j_el))
					End use 
					
				End if 
				
			End for 
			
		End if 
		
	End for 
	
End use 

crgpdToolWindowsForm("FormComponentStart"; "center"; New object:C1471)