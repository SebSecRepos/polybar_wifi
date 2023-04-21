# Wifi_polybar

instalación de los módulos de ip y wifi polybar, la ip se adapta en caso de tener una interfaz wifi activa se mostrará la ip del adaptador inalambrico, si se desconecta se mostrará la ip del adaptador ethernet. El módulo wifi se muestra solo si hay una interfaz wlan incluso si no esta conectada, sin interfaz wlan el módulo desaparece. 
Para conectarse y desconectarse a una wlan se utiliza el script 
wifi.sh \<interfaz wlan>


# Pasos

- Descargue el repositorio en Descargas o Downloads

- Dentro del respositorio descargado copiar la carpeta /custom/ que esta dentro de  polybar
> cd wifi_polybar
> cp ./polybar/custom/ ~/.config/polybar 

- Dentro de la carpeta polybar (actual) hay un archivo llamado "bars_to_add_in_current.ini.txt", ese archvo contiene las polybars que hay que copiar en current.ini.
- Dentro de esta misma carpeta esta el archivo "modules_to_add_in_current.ini.txt", ese archivo contiene los módulos a agregar en current.ini.
- Simplemente abrir dichos archivos y copiar las bars y los módulos en current.ini

##  wifi. sh

- Ejecutar el archivo como sudo, y pasarle la interfaz wlan deseada
	tardará en cargar las redes, si ya esta conectada a una red le ofrecerá 		desconectarse escribiendo 'si', de lo contrario mostrará las redes y escribiendo el essid \<ENTER> luego la contraseña \<ENTER>
debería conectarse a la red seleccionada.

## Detalles 

- SI algún cambio no surge efecto reiniciar la polybar
-  Los módulos utilizan los íconos  obsoletos de hack nerd fonts
