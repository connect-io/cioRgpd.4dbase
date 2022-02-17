var $propriete_t : Text
var $colonne_el; $ligne_el : Integer
var $stop_b : Boolean
var $collection_c : Collection

$collection_c:=New collection:C1472

Case of 
	: (Form event code:C388=Sur données modifiées:K2:15)
		
		If (Form:C1466.columnRules#Null:C1517)
			
			If (Form:C1466.columnRules.booleanUniqueByLine#Null:C1517)  // Il y a une règle qui dit qu'une seule checkbox par ligne peut être sélectionnée
				LISTBOX GET CELL POSITION:C971(*; "List Box"; $colonne_el; $ligne_el)
				$collection_c:=OB Keys:C1719(Form:C1466.data[$ligne_el-1])
				
				If (Value type:C1509(Form:C1466.data[$ligne_el-1][$collection_c[$colonne_el-1]])=Est un booléen:K8:9) & (Bool:C1537(Form:C1466.data[$ligne_el-1][$collection_c[$colonne_el-1]])=True:C214)  // La colonne modifié contient bien une checkbox et a été cliquée
					
					For each ($propriete_t; $collection_c)
						
						If (Value type:C1509(Form:C1466.data[$ligne_el-1][$propriete_t])=Est un booléen:K8:9) & ($propriete_t#$collection_c[$colonne_el-1])
							Form:C1466.data[$ligne_el-1][$propriete_t]:=False:C215
						End if 
						
					End for each 
					
				End if 
				
			End if 
			
		End if 
		
	: (Form event code:C388=Sur clic:K2:4)
		
		If (Form:C1466.columnRules#Null:C1517)
			
			If (Form:C1466.columnRules.clic#Null:C1517)
				$stop_b:=(Form:C1466.columnRules.clic="noCopyCollection")
			End if 
			
		End if 
		
		If ($stop_b=False:C215)
			elementSelection_c:=Form:C1466.elementSelection.copy()
		End if 
		
End case 