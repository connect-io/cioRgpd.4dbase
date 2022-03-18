var $table_t : Text
var $class_o : Object
var $collection_c : Collection

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		var elementSelection_c : Collection
		
		Form:C1466.loadInit:=True:C214
		
		POST OUTSIDE CALL:C329(Current process:C322)
	: (Form event code:C388=Sur appel extérieur:K2:11)
		$class_o:=cs:C1710.RGPDDisplay.new()
		OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie1")->:=""
		
		If (Bool:C1537(Form:C1466.loadInit)=True:C214)
			Form:C1466.useParamSave:=False:C215
			
			$collection_c:=$class_o.getStructureDetail().orderBy("table asc")
			OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->:=New object:C1471("values"; $collection_c.extract("table"); "index"; -1; "currentValue"; "Sélectionnez une dataclasse")
		End if 
		
		If (Bool:C1537(Form:C1466.changeTable)=True:C214)
			$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue
			
			Form:C1466.data:=ds:C1482[$table_t].all()
			
			If ($class_o.checkSaveFileExist()=True:C214)
				OBJECT Get pointer:C1124(Objet nommé:K67:5; "Zone de saisie1")->:="Il existe déjà une sauvegarde du paramétrage pour la dataclasse « "+OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue+" »"
			End if 
			
			OBJECT SET VISIBLE:C603(*; "Bouton@"; True:C214)
			OBJECT SET VISIBLE:C603(*; "Rectangle@"; True:C214)
			
			OBJECT SET VISIBLE:C603(*; "List Box"; True:C214)
			OBJECT SET ENABLED:C1123(*; "Bouton@"; True:C214)
			
			$class_o.chooseTypeData()
		End if 
		
		crgpdToolDeleteProperty(Form:C1466; "changeTable"; "loadInit")
End case 