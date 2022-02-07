var $table_t; $champ_t : Text
var $nbColonne_el; $i_el; $nbBoucle_el; $refFenetre_el : Integer
var $pointeur_p : Pointer
var $class_o : Object
var $collection_c; $data_c : Collection

$data_c:=New collection:C1472

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		$collection_c:=Formula from string:C1601("cioToolsGetStructureDetailClt").call()
		
		$collection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue).extract("champ")
		$collection_c.unshift("Tous les champs")
		
		OBJECT Get pointer:C1124(Objet courant:K67:2)->:=New object:C1471("values"; $collection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
		OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; False:C215)
	: (Form event code:C388=Sur données modifiées:K2:15)
		$refFenetre_el:=Frontmost window:C447
		
		$class_o:=crgpdToolGetClass("RGPDDisplay").new()
		$class_o.getData(->$data_c)
		
		Form:C1466.data:=New collection:C1472
		Form:C1466.data:=$data_c.copy()
		
		$nbColonne_el:=LISTBOX Get number of columns:C831(*; "List Box")
		LISTBOX DELETE COLUMN:C830(*; "List Box"; 2; $nbColonne_el-1)
		
		$nbBoucle_el:=1
		
		If (OBJECT Get pointer:C1124(Objet courant:K67:2)->currentValue="Tous les champs")
			$nbBoucle_el:=OBJECT Get pointer:C1124(Objet courant:K67:2)->values.length
		End if 
		
		$collection_c:=OB Keys:C1719(Form:C1466.data[0])
		
		For ($i_el; 1; $nbBoucle_el)
			$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Colonne"+String:C10($i_el))
			
			If ($i_el=1)
				LISTBOX SET COLUMN FORMULA:C1203(*; "Colonne1"; "This."+$collection_c[$i_el-1]; Est un texte:K8:3)
			Else 
				LISTBOX INSERT COLUMN FORMULA:C970(*; "List Box"; $i_el+1; "Colonne"+String:C10($i_el); "This."+$collection_c[$i_el-1]; Est un texte:K8:3; "Entête"+String:C10($i_el); $pointeur_p)
			End if 
			
			OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); $collection_c[$i_el-1])
		End for 
		
		$class_o.resizeWindows($nbBoucle_el; $refFenetre_el)
End case 