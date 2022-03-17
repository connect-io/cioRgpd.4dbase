var $propriete_t : Text
var $colonne_el; $ligne_el : Integer
var $collection_c : Collection

$collection_c:=New collection:C1472

LISTBOX GET CELL POSITION:C971(*; "List Box"; $colonne_el; $ligne_el)
$collection_c:=OB Keys:C1719(Form:C1466.setDataType[$ligne_el-1])

If (Value type:C1509(Form:C1466.setDataType[$ligne_el-1][$collection_c[$colonne_el-1]])=Est un booléen:K8:9) & (Bool:C1537(Form:C1466.setDataType[$ligne_el-1][$collection_c[$colonne_el-1]])=True:C214)  // La colonne modifiée contient bien une checkbox et a été cliquée
	
	For each ($propriete_t; $collection_c)
		
		If (Value type:C1509(Form:C1466.setDataType[$ligne_el-1][$propriete_t])=Est un booléen:K8:9) & ($propriete_t#$collection_c[$colonne_el-1])
			Form:C1466.setDataType[$ligne_el-1][$propriete_t]:=False:C215
		End if 
		
	End for each 
	
End if 