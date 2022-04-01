<!-- Type your summary here -->
## Description

### Description
Class qui permet l'anonymisation d'une table.

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : generateValue](#fonction--generateValue)
* [Fonction : go](#fonction--go)
* [Fonction : relationSave](#fonction--relationSave)
* [Fonction : relationUpdate](#fonction--relationUpdate)

--------------------------------------------------------------------------------

## Fonction : constructor

### Fonctionnement
```4d
cs.Anonymization.new() -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |
| $dataClass_t    | Texte      | Entrée        | Table dans lequel est éxécuté le traitement. |


### Example
```4d
class_o := crgpdToolGetClass("Anonymization").new("Person")
```

--------------------------------------------------------------------------------

## Fonction : generateValue
Permet de savoir si dans le fichier de relation du composant il existe déjà
un traitement d'anonymisation effectué pour la table sélectionnée

### Fonctionnement
```4d
class_o.generateValue()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $type_o     | Objet      | Entrée        | Type de valeur attendue (nom, prénom, adresse etc.) |
| $entity_o   | Objet      | Entrée        | Entity du champ qu'on souhaite anonymiser           |
| $value_v    | Variant    | Sortie        | Valeur du champ une fois anonymisé                  |



### Example
```4d
class_o.generateValue(New object("libTypeValue";"nom";"field4D";"lastName");ds.Person.get(100))
```

--------------------------------------------------------------------------------

## Fonction : go
Lancement de l'anonymisation pour tous les enregistrements d'une table
sélectionnée

### Fonctionnement
```4d
class_o.go()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |



### Example
```4d
class_o.go()
```

--------------------------------------------------------------------------------

## Fonction : relationSave
Sauvegarde des relations entre les champs et le type d'anonymisation dans
le fichier relation.json

### Fonctionnement
```4d
class_o.relationSave()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |



### Example
```4d
class_o.relationSave()
```

--------------------------------------------------------------------------------

## Fonction : relationUpdate
Mise à jour des relations entre les champs et le type d'anonymisation suite
à un matching dans le formulaire d'anonymisation entre les champs 4D et le type
de champ proposé

### Fonctionnement
```4d
class_o.relationUpdate()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $relation_c | Collection | Entrée        | Relations entre les champs et le type d'anonymisation. |



### Example
```4d
class_o.relationUpdate()
```

--------------------------------------------------------------------------------