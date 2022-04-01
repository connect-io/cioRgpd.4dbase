var $propriete_t : Text
var $content_o; $relation_o : Object

Case of 
	: (Form event code:C388=Sur clic:K2:4)
		CONFIRM:C162("Souhaitez-vous vraiment imprimer le registre ?"; "Oui"; "Non")
		
		If (OK=1)
			$content_o:=JSON Parse:C1218(Storage:C1525.relation_f.getText())
			
			Use (Storage:C1525)
				Storage:C1525.registre:=New shared collection:C1527
				
				For each ($relation_o; $content_o.detail)
					Storage:C1525.registre.push(New shared object:C1526)
					
					For each ($propriete_t; $relation_o)
						
						Use (Storage:C1525.registre[Storage:C1525.registre.length-1])
							
							If (Value type:C1509($relation_o[$propriete_t])#Est un objet:K8:27) & (Value type:C1509($relation_o[$propriete_t])#Est une collection:K8:32)
								Storage:C1525.registre[Storage:C1525.registre.length-1][$propriete_t]:=$relation_o[$propriete_t]
							End if 
							
						End use 
						
					End for each 
					
				End for each 
				
			End use 
			
			crgpdToolPrintForm("FormRegistre")
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 