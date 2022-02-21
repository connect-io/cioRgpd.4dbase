<!-- Type your summary here -->
## Description

### Description
Gestion du formulaire d'anonymisation d'une base donnée 4D

### Accès aux fonctions
* [Fonction : constructor](#fonction--constructor)
* [Fonction : applyValue](#fonction--applyValue)
* [Fonction : chooseTypeData](#fonction--chooseTypeData)
* [Fonction : generateValue](#fonction--generateValue)
* [Fonction : getData](#fonction--getData)
* [Fonction : resizeFullWidth](#fonction--resizeFullWidth)
* [Fonction : resizeWindows](#fonction--resizeWindows)

--------------------------------------------------------------------------------

## Fonction : constructor

### Fonctionnement
```4d
cs.RGPDDisplay.new() -> $instance_o
```

| Paramètre       | Type       | entrée/sortie | Description |
| --------------- | ---------- | ------------- | ----------- |


### Example
```4d
class_o := crgpdToolGetClass("RGPDDisplay").new()
```

--------------------------------------------------------------------------------

## Fonction : applyValue
Applique une valeur aléatoire pour anonymiser un champ d'une table

### Fonctionnement
```4d
class_o.applyValue($enregistrement_o; $element_o; $type_o)
```

| Paramètre         | Type       | entrée/sortie | Description |
| ----------------- | ---------- | ------------- | ----------- |
| $enregistrement_o | Objet      | Entrée        | Entité à anonymiser |
| $element_o        | Objet      | Entrée        | Element construit avec la méthode getData() |
| $type_o           | Objet      | Entrée        | Type de valeur attendue |



### Example
```4d
class_o.applyValue()
```

--------------------------------------------------------------------------------

## Fonction : chooseTypeData
Permet de faire matcher un champ avec un type de valeur attendue (nom, prénom etc.)

### Fonctionnement
```4d
class_o.chooseTypeData()
```

| Paramètre   | Type       | entrée/sortie | Description |
| ----------- | ---------- | ------------- | ----------- |
| $typeData_c | Collection | Sortie        | Collection qui contient pour chaque champ le type de valeur attendu |



### Example
```4d
class_o.chooseTypeData()
```

--------------------------------------------------------------------------------