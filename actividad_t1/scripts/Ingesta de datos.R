#Cargar librerías
library(readr)
library(here)
library(dplyr)
library(readxl)

#--------Ingesta de datos----
#lectura directa desde URL
datos_web<- read.csv("https://www.datos.gob.mx/dataset/bd428f6b-bc9a-4617-8c4b-9dd320101f30/resource/70dfeb69-065b-4ed4-8922-505602666250/download/d3_aire01_49_1.csv")

#Documentación
# Origen: Plataforma Nacional de datos Abiertos (Mexico)
# Fecha descarga: 23/07/2025
# Método lectura: read_csv, delimitador ",", codificación UTF-8
#Relevancia: En un contexto donde la calidad del aire empeora en 
#todos los Estados del País, conocer las principales fuentes de emisión
#así como los contaminantes principales nos podrían dar ideas para
#la mitigación de ellos.
#Lectura local
datos_incendios<- read_csv(here("data", "raw", "incendios.csv"))
#Documentación
# Origen: Plataforma Nacional de datos Abiertos (Mexico)
# URL: https://www.datos.gob.mx/dataset/3a1d4a71-4dad-4ae9-9eec-44de7fa8ebf3/resource/ddf38874-6243-4437-8f76-19f797cafa5c/download/estadisticasincendiosforestales2015-2024.csv 
# Fecha descarga: 23/07/2025
# Método lectura: read_csv, delimitador ",", codificación UTF-8
#Relevancia: Acorde al set de datos de la URL que nos muestra las
#fuentes de contaminación por entidad así como los tipos de contaminantes
#el conocer si existe una relación significativa entre la contaminación atmosférica
#y los incendios forestales, siendo estos últimos un problema que ultimamente
#afecta a un volcán muy importante en mi Estado. 