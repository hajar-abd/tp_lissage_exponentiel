#########################
# ABDAOUI Hâjar
# M2 DSS - 24/02/2026
# TP séries temporelles
#########################
# Packages ------------------

## résumer page 22 à page 25 à mettre en annexe du rapport
library(xtable)

# Introduction ---------

# Question 1 : 
# Chargement des données
data = read.csv2("varicelleb.csv", header = FALSE)
summary(data)
length(data)
str(data)
data_cleaned <- as.numeric(unlist(t(data)))
data_cleaned <- data_cleaned[!is.na(data_cleaned)]

# Création de la série temporelle 
ts_data <- ts(data_cleaned, frequency = 12, start = c(1931, 1), end = c(1972, 6)) # mettre le nombre de fréquences par années et les dates de début et fin de la serie temporelle 
head(ts_data)


# Question 2 : graphique de la série temporelle
plot(ts_data) # saisonnalité - 2 types additive ou multiplicative

# Question 3 :  évolution mensuelle du nombre de cas pour chaque année 
monthplot(ts_data,
          ylab = "Cas de varicelle",
          xlab = "Mois",
          main = "Évolutions mensuelles des cas de varicelle par année")

# Question 4 : évolution annuelle 
annual_values <- aggregate(ts_data, nfrequency = 1, FUN = sum)

plot(annual_values,
     type = "l",
     xlab = "Année",
     ylab = "Cas annuels de varicelle",
     main = "Évolution annuelle des cas de varicelle")

# superposer moyenne annuelle et écart type 

# Question 6 : tableau stats annuelles

df <- data.frame(value = as.numeric(ts_data),
                 year = floor(time(ts_data)),
                 month = cycle(ts_data))

annual_stats <- aggregate(value ~ year, df, function(x) c(mean = mean(x),
                                                          sd = sd(x),
                                                          min = min(x), 
                                                          max = max(x),
                                                          sum = sum(x)))

annual_stats <- data.frame(year = annual_stats$year,
                           mean = annual_stats$value[, "mean"],
                           sd = annual_stats$value[, "sd"],
                           min = annual_stats$value[, "min"],
                           max = annual_stats$value[, "max"],
                           sum = annual_stats$value[, "sum"])

annual_stats

# (a) : Tracer sur des graphiques différents, la courbe par année de chacune des statistiques

par(mfrow = c(3, 2))

plot(annual_stats$year, annual_stats$mean, type = "l",
     xlab = "Année", ylab = "Moyenne",
     main = "Moyenne annuelle")

plot(annual_stats$year, annual_stats$sd, type = "l",
     xlab = "Année", ylab = "Ecart-type",
     main = "Variabilité annuelle (sd)")

plot(annual_stats$year, annual_stats$min, type = "l",
     xlab = "Année", ylab = "Minimum",
     main = "Minimum annuel")

plot(annual_stats$year, annual_stats$max, type = "l",
     xlab = "Année", ylab = "Maximum",
     main = "Maximum annuel")

plot(annual_stats$year, annual_stats$sum, type = "l",
     xlab = "Année", ylab = "Somme annuelle",
     main = "Somme totale annuelle")

par(mfrow = c(1, 1))

# (b) : Faire la statistique descriptive de chaque colonne et interpréter convenablement les résultats obtenus

summary(annual_stats[, -1])      # exclure la colonne année

# Les statistiques annuelles montrent une variation importante du nombre de cas de varicelle selon les années. 
# La moyenne annuelle (environ 728 cas) et la médiane (717 cas) sont proches, indiquant une tendance centrale stable. 
# Mais les valeurs moyenne annuelle peuvent varier de 303 à plus de 1087 cas, témoignant d’années plus ou moins épidémiques.
# L’écart-type annuel moyen est autour de 527 cas, ce qui confirme des fluctuations mensuelles importantes et des pics saisonniers marqués certaines années. 
# Les minima annuels restent faibles, ce qui traduit la présence régulière de mois de faible circulation du virus de la varicelle. 
# À l’inverse, les maxima peuvent dépasser 3000 cas, indiquant des pics épidémiques intenses.
# La somme annuelle varie fortement, de 2500 à plus de 13000 cas. 
# Cela nous montre que l’ampleur des épidémies n’est pas constante et que certaines années sont nettement plus touchées que d’autres.

# Question 7 : modele

model <- lm(sd ~ mean, data = annual_stats)
summary(model)

# Le test F est significatif (p < 0,05), ce qui montre que le modèle est globalement pertinent.
# La moyenne annuelle explique une grande partie de la variabilité de l’écart-type annuel. 
# La variabilité des ecart types observés sur les 42 années est expliquée par les moyennes annuelles à hauteur de 87% (R^2)

# (a)
# Le test proposé est un test de Fisher 

# reconstruire le tableau anova du test de Fisher et décider s'il y a une pertinence dans le modèle. On compare la p valeur assoicé au test de fisher en utilisant un risque alpha de 5%. 
# Le test de fisher permet d'évaluer la pertinence de ce modèle. 
anova(model)

# (b)

par(mfrow = c(1, 2))
plot(model, which = 1)   # residuals vs fitted
plot(model, which = 2)   # qqplot
par(mfrow = c(1, 1))

shapiro.test(residuals(model)) # shapiro test pour normalité des résidus

# Le test de Shapiro donne une p-value < 0,05, ce qui indique que les résidus ne suivent pas une loi normale.
# Le QQ-plot confirme une déviation des courbes aux extrémités.

# (c)
summary(model)$coefficients # examine p-value de la pente

# La pente est significative (p < 0,05), ce qui montre que l’écart-type augmente avec la moyenne.
# On retient donc un modèle multiplicatif.


# Question 8 : 

acf(ts_data,main = "Fonction d'auto-corrélation (ACF) de la série", lag.max = 50) # autocorrelation
pacf(ts_data, main = "Fonction d'auto-corrélation partielle (PACF) de la série", lag.max = 50) # autocorrelation partielle
# Cela montre bien qu'il y a une saisonnallité 

# Lissage exponentiel -------------

## 2.1 Données de varicelles à New-York de 1931 à 1972 ----

train <- window(ts_data, start = c(1931, 1), end = c(1969, 12)) # training set
test  <- window(ts_data, start = c(1970, 1), end = c(1972, 6)) # test set

model_hw <- HoltWinters(train, seasonal = "mul") # Un modèle Holt-Winters saisonnier multiplicatif a été ajusté aux données de 1931 à 1969.
model_hw

pred_mul <- predict(model_hw, n.ahead = length(test))

err_mul    <- as.numeric(test) - as.numeric(pred_mul)
ESS_mul    <- sum(err_mul^2)          # Erreur quadratique totale (sum of squared errors)
RMSE_mul   <- sqrt(mean(err_mul^2))   # Racine de l'erreur quadratique moyenne


ts_test <- ts(test)
plot(ts_test, col = "black", lwd = 2,
     main = "Varicelle 1970-1972 : Observé vs Prévu (HW multiplicatif)",
     xlab = "Année", ylab = "Nombre de cas")
lines(pred_mul, col = "red", lty = 2, lwd = 2)

## 2.2 Données de la concentration en co2 du volcan Mauna Loa (Hawaï) de 1959 à 1997 ----

############################
# QUESTION 1 
############################

data <- read.table("maunaloa2Co2.txt", header = TRUE, na.strings = "-99.99")
data_month <- data[, 2:13]

# Passage en vecteur
co2_values <- as.numeric(t(as.matrix(data_month)))

# Suppression des NA
co2_values <- co2_values[!is.na(co2_values)]

# Création de la série temporelle
co2_ts <- ts(co2_values, frequency = 12, start = c(1959, 1), end = c(1997, 12))

# Représentation graphique

plot.ts(co2_ts,
        main = "Concentration mensuelle de CO2 (Mauna Loa)",
        ylab = "CO2 (ppm)")

# A partir de nos observations : la série présente
#   - une tendance croissante claire (hausse régulière)
#   - une saisonnalité annuelle marquée (oscillations régulières)
# => Le modèle de Holt-Winters additif est le plus approprié
#    (lissage exponentiel avec tendance et saisonnalité)

############################
# QUESTION 2
############################

co2_train <- window(co2_ts, start = c(1959, 1), end = c(1989, 12))
co2_test  <- window(co2_ts, start = c(1990, 1), end = c(1997, 12))

# Ajustement du modèle Holt-Winters additif sur les données d'entraînement
hw_model <- HoltWinters(co2_train, seasonal = "additive")
hw_model  # affiche les paramètres alpha, beta, gamma estimés


