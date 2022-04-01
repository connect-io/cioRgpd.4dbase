<!-- Type your summary here -->
## Description

### Description
Class qui permet de générer des profils de personnes cohérentes mais aléatoire

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : generate](#fonction--generate)
* [Fonction : generateValue](#fonction--generateValue)
* [Fonction : isValidField](#fonction--isValidField)

--------------------------------------------------------------------------------

## Fonction : constructor

### Fonctionnement
```4d
cs.avatarPerson.new() -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
class_o := crgpdToolGetClass("avatarPerson").new()
```

--------------------------------------------------------------------------------

## Fonction : generateValue
Générer une valeur pour anonymiser un champ d'une table.

### Fonctionnement
```4d
class_o.generateValue()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $lib_t      | Texte      | Entrée        | Type de valeur attendue (nom, prénom, adresse etc.) |


### Example
```4d
class_o.generateValue()
```

--------------------------------------------------------------------------------