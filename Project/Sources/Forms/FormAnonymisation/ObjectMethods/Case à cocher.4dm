var $content_o : Object
var $collection_c : Collection

$collection_c:=New collection:C1472

If (Bool:C1537(Form:C1466.useParamSave)=True:C214)  // Il faut vérifier qu'une sauvegarde pour la table et pour les champs sélectionnés a bien été sauvegardé précedemment
	
	Form:C1466.useParamSave:=Not:C34((Storage:C1525.relation_f.exists=False:C215))
	
	If (Storage:C1525.relation_f.exists=False:C215)
		ALERT:C41("Aucun fichier de sauvegarde n'a été enregistré, vous ne pouvez pas utiliser cette option.")
	Else 
		$content_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
		$collection_c:=$content_o.detail.query("table = :1"; OBJECT Get pointer:C1124(Object named:K67:5; "dataClassList")->currentValue)
		
		Form:C1466.useParamSave:=Not:C34(($collection_c.length=0))
		
		If ($collection_c.length=0)
			ALERT:C41("Le fichier de sauvegarde ne contient pas d'élément sauvegardé pour la table « "+OBJECT Get pointer:C1124(Object named:K67:5; "dataClassList")->currentValue+" »")
		End if 
		
	End if 
	
End if 

If (Form:C1466.useParamSave=True:C214)
	Form:C1466.changeTable:=True:C214
	
	POST OUTSIDE CALL:C329(Current process:C322)
End if 