var $fichier_o; $content_o : Object
var $collection_c : Collection

$collection_c:=New collection:C1472

If (Bool:C1537(Form:C1466.useParamSave)=True:C214)  // Il faut vérifier qu'une sauvegarde pour la table et pour les champs sélectionnés a bien été sauvegardé précedemment
	$fichier_o:=File:C1566(Get 4D folder:C485(Dossier Resources courant:K5:16; *)+"cioRgpd"+Séparateur dossier:K24:12+"configSave.json"; fk chemin plateforme:K87:2)
	
	Form:C1466.useParamSave:=Not:C34(($fichier_o.exists=False:C215))
	
	If ($fichier_o.exists=False:C215)
		ALERT:C41("Aucun fichier de sauvegarde n'a été enregistré, vous ne pouvez pas utiliser cette option.")
	Else 
		$content_o:=JSON Parse:C1218($fichier_o.getText())
		$collection_c:=$content_o.detail.query("table = :1 AND champ = :2"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue)
		
		Form:C1466.useParamSave:=Not:C34(($collection_c.length=0))
		
		If ($collection_c.length=0)
			ALERT:C41("Le fichier de sauvegarde ne contient pas d'élément sauvegardé pour la table « "+OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue+" » et le champ « "+\
				OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue+" »")
		End if 
		
	End if 
	
End if 