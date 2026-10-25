# Analyse de séries temporelles et lissage exponentiel

Travail pratique réalisé avec r et r markdown pour explorer des séries temporelles, comparer des méthodes de lissage exponentiel et évaluer leurs prévisions sur des observations conservées à part.

Deux applications sont étudiées : le nombre mensuel de cas de varicelle à new york entre 1931 et 1972, et la concentration atmosphérique en co2 à mauna loa.

## Contenu de l'analyse

### Cas mensuels de varicelle

- Transformation des données en une série mensuelle de type `ts`.
- Visualisation de l'évolution, des profils saisonniers et des totaux annuels.
- Calcul de statistiques annuelles et exploration des autocorrélations.
- Comparaison du lissage exponentiel simple, double et saisonnier multiplicatif de holt-winters.
- Apprentissage sur la période 1931–1969 et comparaison des prévisions aux observations de janvier 1970 à juin 1972.

### Concentration en co2

- Exploration de la série `co2` fournie avec r, couvrant 1959–1997.
- Ajustement d'un modèle de holt-winters à saisonnalité additive.
- Apprentissage sur 1959–1989 et validation sur 1990–1997.
- Prévisions pour 1998–2003, puis comparaison aux observations complémentaires du fichier `maunaloa2Co2.txt`.
- Présentation de graphiques, d'intervalles de prévision et de mesures d'erreur.

## Fichiers à consulter

| Fichier | Contenu |
| --- | --- |
| [tp_lissage_exponentiel.Rmd](tp_lissage_exponentiel.Rmd) | Code, explications et interprétations |
| [tp_lissage_exponentiel_hajar_abdaoui.html](tp_lissage_exponentiel_hajar_abdaoui.html) | Rapport déjà généré, à télécharger puis ouvrir dans un navigateur |
| [varicelleb.csv](varicelleb.csv) | Données mensuelles de varicelle |
| [maunaloa2Co2.txt](maunaloa2Co2.txt) | Observations complémentaires de co2 |
| [TP1_-_intro_et_lissage.pdf](TP1_-_intro_et_lissage.pdf) | Énoncé du travail pratique |
| [FICHE_1_Lissage_exponentiel_-_Hâjar_Abdaoui.pdf](FICHE_1_Lissage_exponentiel_-_Hâjar_Abdaoui.pdf) | Fiche sur le lissage exponentiel |
| [tp.Rproj](tp.Rproj) | Projet rstudio |

## Utilisation

Installer r et rstudio, puis ouvrir `tp.Rproj`. Depuis la racine du dépôt :

```r
install.packages(c("rmarkdown", "knitr"))
rmarkdown::render("tp_lissage_exponentiel.Rmd", output_format = "html_document")
```

Les calculs s'appuient sur les fonctions fournies avec r, notamment `ts()`, `window()`, `acf()`, `pacf()`, `HoltWinters()` et `predict()`.

Le rendu html nécessite pandoc, généralement fourni avec rstudio. Le document propose également des sorties word et pdf ; la sortie pdf nécessite une installation latex. Conserver les deux fichiers de données à la racine du projet.

## Contexte du travail

Travail réalisé par hâjar abdaoui. Le dépôt illustre une démarche pédagogique d'exploration, de modélisation et de validation de prévisions sur des séries historiques.
