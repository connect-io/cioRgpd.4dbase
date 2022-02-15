var $collection_c : Collection

$collection_c:=Formula from string:C1601("cioToolsGetStructureDetailClt").call()

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471("values"; $collection_c.extract("table"); "index"; -1; "currentValue"; "Sélectionnez une table")
	: (Form event code:C388=Sur données modifiées:K2:15)
		Form:C1466.changeTable:=True:C214
		
		POST OUTSIDE CALL:C329(Current process:C322)
End case 