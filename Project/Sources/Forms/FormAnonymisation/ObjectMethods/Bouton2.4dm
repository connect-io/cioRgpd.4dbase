var $table_t : Text
var $anonymize_o : cs:C1710.Anonymization

Case of 
	: (Form event code:C388=Sur chargement:K2:1)
		OBJECT SET ENABLED:C1123(*; OBJECT Get name:C1087(Objet courant:K67:2); False:C215)
	: (Form event code:C388=Sur clic:K2:4)
		$table_t:=OBJECT Get pointer:C1124(Objet nommé:K67:5; "dataClassList")->currentValue
		$anonymize_o:=cs:C1710.Anonymization.new($table_t)
		
		CONFIRM:C162("Souhaitez-vous sauvegarder vos choix pour la dataclasse « "+$table_t+" » et les appliquer automatiquement ultérieurement ?"; "Oui"; "Non")
		
		If (OK=1)
			$anonymize_o.relationSave()
		End if 
		
	: (Form event code:C388=Sur survol:K2:35)
		SET CURSOR:C469(9000)
End case 