#
# Este script en Python va a cargar variables definidas en 'covid.cfg'. 
# La forma de acceder a estas variables en otro script en Python es usando
# covid.VARNAME, donde 'VARNAME' es el nombre de unas de las variables definidas
# en el archivo 'covid.cfg'.
#
import imp
import os

covid = imp.load_source('covid',"%s/%s"%(os.getcwd(),"covid.cfg"))
