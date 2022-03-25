//%attributes = {"preemptive":"capable"}
var $1 : Object
var $2 : Collection
var $3 : Text

var $entity_o; $type_o : Object
var $class_o : cs:C1710.Anonymization

$class_o:=cs:C1710.Anonymization.new($3)

For each ($entity_o; $1)
	
	For each ($type_o; $2)
		$entity_o[$type_o.field4D]:=$class_o.generateValue($type_o; $entity_o[$type_o.field4D])
	End for each 
	
	$entity_o.save()
End for each 

ALERT:C41("Fini")