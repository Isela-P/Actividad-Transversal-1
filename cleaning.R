
#------------ 1 Configuracion y adquisicion de datos----------
#Cargar librerías
library(readr)
library(here)
library(dplyr)
library(stringr)
library(janitor)


#--------Ingesta de datos-----------#
#lectura directa desde URL
calidad_aire<- read.csv("https://www.datos.gob.mx/dataset/bd428f6b-bc9a-4617-8c4b-9dd320101f30/resource/70dfeb69-065b-4ed4-8922-505602666250/download/d3_aire01_49_1.csv")

#Documentación
# Origen: Plataforma Nacional de datos Abiertos (Mexico) 
#URL: https://datos.gob.mx/dataset/calidad_aire_emisiones_contaminantes/resource/70dfeb69-065b-4ed4-8922-505602666250
# Fecha descarga: 23/07/2025
# Método lectura: read_csv, delimitador ",", codificación UTF-8
#Relevancia: En un contexto donde la calidad del aire empeora en 
#todos los Estados del País, conocer las principales fuentes de emisión
#así como los contaminantes principales nos podrían dar ideas para
#la mitigación de ellos.
#NOTA_ Es el inventario del año 2018


#Lectura local
incendios<- read_csv(here("data", "raw", "incendios.csv"))
#Documentación
# Origen: Plataforma Nacional de datos Abiertos (Mexico)
# URL: https://datos.gob.mx/dataset/incendios_forestales
#Fecha descarga: 23/07/2025
# Método lectura: read_csv, delimitador ",", codificación UTF-8
#Relevancia: Acorde al set de datos de la URL que nos muestra las
#fuentes de contaminación por entidad así como los tipos de contaminantes
#el conocer si existe una relación significativa entre la contaminación atmosférica
#y los incendios forestales, siendo estos últimos un problema que ultimamente
#afecta a un volcán muy importante en mi Estado. 

#----------- 2 Limpieza y estandarización ------------#

#observar rápidamente los datos
str(calidad_aire)
#observamos que existen 11 columnas. Debemos seleccionar unicamente las relevantes para el estudio
calidad_aire<- select(calidad_aire, Entidad, Tipo_de_Fuente,PM_2_5,CO,SO_2,NOx)

str(calidad_aire)
summary(calidad_aire)
#Nuevamente seleccionamos las columnas de interés al estudio
incendios<- select(incendios, Entidad, Causa, Tipo_impacto,Total_hectareas, Fecha_Inicio, Fecha_Termino)
str(incendios)
summary(incendios)

#Recordando que el estudio sera enfocado al Estado de Puebla
calidad_aire<- filter(calidad_aire, Entidad== "Puebla")

incendios<- filter(incendios, Entidad=="Puebla")

#Detección y eliminación de Duplicados
sum(duplicated(calidad_aire))

calidad_aire<- calidad_aire[!duplicated(calidad_aire), ]

sum(duplicated(calidad_aire)) #rectificar eliminación de duplicados.


sum(duplicated(incendios)) 

incendios<- incendios[!duplicated(incendios), ]

sum(duplicated(incendios)) #rectificar la eliminación de duplicados.

#Oservar cuántos datos Nulos tenemos pro columna
summarise_all(calidad_aire, funs(sum(is.na(.))))
#Eliminar los datos nulos. 
calidad_aire<- na.omit(calidad_aire)
summarise_all(calidad_aire, funs(sum(is.na(.))))

summarise_all(incendios, funs(sum(is.na(.)))) #No existen datos Nulos.

#Estandarizar nombres de columnas
incendios<-janitor::clean_names(incendios)

calidad_aire<- janitor::clean_names(calidad_aire) #Debido a que 2 columnas
#mantienen nombres dificies se hará un rename

calidad_aire<-calidad_aire%>%
  rename(pm_25 = pm_2_5)

calidad_aire<-calidad_aire%>%
  rename(nox =n_ox)

calidad_aire<-calidad_aire%>%
  rename(so2 =so_2)

#rectificar formato de fechas

incendios<- incendios%>%
  mutate(fecha_inicio=as.Date(fecha_inicio, format("%Y-%m-%d"))
  )

incendios<- incendios%>%
  mutate(fecha_termino=as.Date(fecha_termino, format("%Y-%m-%d"))
  )

#Guardar datos limpios
write.csv(incendios,"data/processed/clean_incendios.csv",row.names = FALSE)
write.csv(calidad_aire,"data/processed/clean_calidad_aire.csv",row.names = FALSE)

#Guardar scrip
getwd()
