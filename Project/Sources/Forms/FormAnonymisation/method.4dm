var $refFenetre_el; $nbColonne_el; $nbBoucle_el; $i_el : Integer
var $pointeur_p : Pointer
var $class_o : Object
var $collection_c; $data_c : Collection

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		Form:C1466.objet:=New object:C1471
		
		POST OUTSIDE CALL:C329(Current process:C322)
	: (Form event code:C388=Sur appel extérieur:K2:11)
		$data_c:=New collection:C1472
		$collection_c:=Formula from string:C1601("cioToolsGetStructureDetailClt").call()
		
		If (Bool:C1537(Form:C1466.changeTable)=True:C214)
			$collection_c:=$collection_c.query("table = :1"; OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante")->currentValue)[0].champ
			$collection_c.unshift("Tous les champs")
			
			Form:C1466.data:=New collection:C1472
			
			OBJECT SET ENABLED:C1123(*; "Bouton"; False:C215)
			OBJECT SET ENABLED:C1123(*; "Popup Liste déroulante1"; True:C214)
			
			OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->:=New object:C1471("values"; $collection_c; "index"; -1; "currentValue"; "Sélectionnez un champ")
		End if 
		
		If (Bool:C1537(Form:C1466.changeChamp)=True:C214)
			$refFenetre_el:=Frontmost window:C447
			
			$class_o:=crgpdToolGetClass("RGPDDisplay").new()
			$class_o.getData(->$data_c)
			
			Form:C1466.data:=New collection:C1472
			Form:C1466.data:=$data_c.copy()
			
			$nbColonne_el:=LISTBOX Get number of columns:C831(*; "List Box")
			LISTBOX DELETE COLUMN:C830(*; "List Box"; 2; $nbColonne_el-1)
			
			$nbBoucle_el:=1
			
			If (OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->currentValue="Tous les champs")
				$nbBoucle_el:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Popup Liste déroulante1")->values.length+4  // On rajoute 3 car il y a 3 propriétés en plus pour chaque ligne [table, champ, type]
			End if 
			
			$collection_c:=OB Keys:C1719(Form:C1466.data[0])
			
			For ($i_el; 1; $nbBoucle_el)
				$pointeur_p:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "Colonne"+String:C10($i_el))
				
				If ($i_el=1)
					LISTBOX SET COLUMN FORMULA:C1203(*; "Colonne1"; "This."+$collection_c[$i_el-1]; Est un texte:K8:3)
				Else 
					LISTBOX INSERT COLUMN FORMULA:C970(*; "List Box"; $i_el+1; "Colonne"+String:C10($i_el); "This."+$collection_c[$i_el-1]; Est un texte:K8:3; "Entête"+String:C10($i_el); $pointeur_p)
				End if 
				
				If ($collection_c[$i_el-1]="table") | ($collection_c[$i_el-1]="champ") | ($collection_c[$i_el-1]="champType") | ($collection_c[$i_el-1]="primaryKey")
					OBJECT SET VISIBLE:C603(*; "Colonne"+String:C10($i_el); False:C215)
				End if 
				
				OBJECT SET TITLE:C194(*; "Entête"+String:C10($i_el); $collection_c[$i_el-1])
			End for 
			
			$class_o.resizeWindows($nbBoucle_el; $refFenetre_el)
			$class_o.resizeFullWidth(($nbBoucle_el>1); New collection:C1472("Rectangle3"; "Bouton"))
			
			OBJECT SET ENABLED:C1123(*; "Bouton"; True:C214)
		End if 
		
		crgpdToolDeleteProperty(Form:C1466; "changeTable"; "changeChamp")
End case 