var $collection_c : Collection

$collection_c:=Formula from string:C1601("cioToolsGetStructureDetailClt").call()

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471("values"; $collection_c.extract("table"); "index"; -1; "currentValue"; "Sélectionnez une table")
	: (Form event code:C388=Sur données modifiées:K2:15)
		$collection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet courant:K67:2)->currentValue)[0].champ
		$collection_c.unshift("Tous les champs")
		
		Form:C1466.data:=New collection:C1472
		
		OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; True:C214)
		OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->:=New object:C1471("values"; $collection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
End case 