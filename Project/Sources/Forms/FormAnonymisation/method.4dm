var $table_t : Text
var $class_o : Object
var $collection_c; $autreCollection_c : Collection

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		Form:C1466.objet:=New object:C1471
		Form:C1466.loadInit:=True:C214
		
		POST OUTSIDE CALL:C329(Current process:C322)
	: (Form event code:C388=Sur appel extérieur:K2:11)
		$class_o:=crgpdToolGetClass("RGPDDisplay").new()
		
		$collection_c:=$class_o.getStructureDetail()
		$autreCollection_c:=New collection:C1472
		
		OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie1")->:=""
		OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie2")->:=""
		
		If (Bool:C1537(Form:C1466.loadInit)=True:C214)
			OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->:=New object:C1471("values"; $collection_c.extract("table"); "index"; -1; "currentValue"; "Sélectionnez une table")
			
			
			$autreCollection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue).extract("champ")
			$autreCollection_c.unshift("Tous les champs")
			
			OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471("values"; $autreCollection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
			OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; False:C215)
		End if 
		
		If (Bool:C1537(Form:C1466.changeTable)=True:C214)
			$collection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue)[0].champ
			$collection_c.unshift("Tous les champs")
			
			Form:C1466.data:=New collection:C1472
			Form:C1466.useParamSave:=False:C215
			
			OBJECT SET ENABLED:C1123(*; "Bouton"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; True:C214)
			
			OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->:=New object:C1471("values"; $collection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
		End if 
		
		If (Bool:C1537(Form:C1466.changeChamp)=True:C214)
			$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue
			
			Form:C1466.data:=ds:C1482[$table_t].all()
			Form:C1466.useParamSave:=False:C215
			
			If ($class_o.checkSaveFileExist()=True:C214)
				OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie1")->:="Il existe déjà une sauvegarde du paramétrage pour la table « "+OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue\
					+" » et le champ « "+OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue+" »"
			End if 
			
			OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie2")->:=String:C10(Form:C1466.data.length)+" enregistrements à anonymiser."
			OBJECT SET ENABLED:C1123(*; "Bouton"; True:C214)
		End if 
		
		crgpdToolDeleteProperty(Form:C1466; "changeTable"; "changeChamp"; "loadInit")
End case 