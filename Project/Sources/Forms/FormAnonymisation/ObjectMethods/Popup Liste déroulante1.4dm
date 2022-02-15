var $collection_c : Collection

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		$collection_c:=Formula from string:C1601("cioToolsGetStructureDetailClt").call()
		
		$collection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue).extract("champ")
		$collection_c.unshift("Tous les champs")
		
		OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471("values"; $collection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
		OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; False:C215)
	: (Form event code:C388=Sur données modifiées:K2:15)
		Form:C1466.changeChamp:=True:C214
		
		POST OUTSIDE CALL:C329(Current process:C322)
End case 