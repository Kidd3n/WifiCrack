## WifiPwnedd
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

| Español | [English](https://github.com/Kidd3n/WifiPwnedd?tab=readme-ov-file)  |
| --- | --- |


| :exclamation:  **Disclaimer**  |
|---------------------------------|
| El uso de esta herramienta en entornos reales es completamente **ilegal** sin la autorización necesaria. **Usted es responsable** de cualquier problema que pueda causar al utilizar esta herramienta. |

## Como se ejecuta la herramienta? 

```
git clone https://github.com/Kidd3n/WifiPwnedd.git

cd WifiPwnedd

chmod 755 wifipwnedd.sh

sudo ./wifipwnedd.sh
```

## Menu de ataques 

![Screenshot_2023-11-14_17-53-37](https://github.com/Kidd3n/WifiPwnedd/assets/89719224/4f4ed8a4-501b-46c6-b976-6ba32610f0c4)









- Configura la tarjeta que tu le indiques para que este en modo monitor (necesario)

- Se cambia la direccion MAC con Macchanger para ser aun mas anonimos 

### 1) Handshake Attack

- Nos saldra una ventana con todas las redes disponibles y sus canales, le debemos indicar el nombre correctamnete de la red y su canal

- Luego nos saldra una ventana igual, solo que ahora estara filtrada por el nombre y el canal que le pasamos anteriormente

- Esperamos unos segundos y empezara el ataque a la red

- Despues de algunos segundos vamos a optener un Handshake

- Luego se hara fuerza bruta con el diccionario que le pasamos (Durara bastante dependiendo de tu computadora y de la contraseña)

### 2) PMKID Attack

- Esperara el paquete necesario por los segundos que le indiquemos

- Si lo captura pasara a la fase de fuerza bruta con hashcat

- Si no lo captura se cerrara el ataque

### 3) DoS Attack

- Nos preguntara por la red que le queremos hacer el ataque

- Luego por los canales, los recomendados son el 1,6,11 pero puedes poner todos del 1-12 o los que guste 

- Puede que la red cambie de canales

### 4) Beacon Flood Attack

- Nos preguntara si queremos ponerle nombre a la red, si le damos que si (Y) nos preguntara el nombre y empazara

- (Recomendado) Si le damos que no (N) pues se nos hara un flood de redes con nombre extraños

### 5) Network Traffic

- Podemos ver todo el trafico que viaja

### 6) Scanner

- Podemos ver los clientes que estan conectados a nuestra red privada, podemos ver el nombre del dispositivo y la IP

### 7) DoS for Client 

- Este modulo sirve para quitarle el acceso a internet a un cliente en nuestra red usando paquetes ARP con arpspoof.

- Tenemos que estar en una red privada antes de entrar en este modulo

- Se nos pedira una direccion ip, debemos poner la de nuestra victima

- Luego pondremos en segundos el tiempo que queremos quitarle el acceso

- Creditos: El creador de este script fue @PinguinodeMario, Gracias por permitir que este en esta herramienta

- Video sobre el Modulo: https://youtu.be/MbB0XRjFS_Y?si=1i1ajq_NEBHYmH-8

### 8) Wifiphisher

- Gemelo malvado

- Debes escoger una red a la cual se le mandaran paquetes de desauntenticacion global (Todas las MAC'S), esto para que los usuarios no tengan la red disponible y se conecten a nuesta red

- El nombre de la red es el mismo a la red que queremos clonar.

- Generará los ficheros de configuración hostapd y dnsmasq, y también configurará que cuando se conecte un dispositivo se le asigne una dirección IP y una NetMask.

- A continuación podemos elegir un login a utilizar

- Esperamos las credenciales de las víctimas

### 9) Fake/Rogue ap

- Crea una red falsa con el nombre que elijas.

- Generará los ficheros de configuración hostapd y dnsmasq con el nombre y canal que dimos anteriormente, y también configurará que cuando se conecte un dispositivo se le asigne una dirección IP y una NetMask.

- A continuación podemos elegir un login a utilizar

- Esperamos las credenciales de las víctimas

### 10) Force Brute .cap

- Fuerza bruta con el diccionario que queramos a un archivo .cap.

### 11) Hash .cap -> .hccapx

- Convierte tu archivo hash o archivo .cap a .hccapx

### 12) Hashed Dictionary (Rainbow Taibles)

- Es un diccionario precomputado para ser usado contra hashes, esto nos ayudara a que sea mas rapido (Depende de la contraseñas)

### 13) Force brute with GPU

- ❕ Esta opción no se puede hacer en una máquina virtual, sólo funcionará cuando el SO esté directamente instalado.

- Nos pedirá un hash, ya sea .cap o hccapx, si es .cap se convertirá automáticamente a formato hccapx con el nombre que queramos.

- Luego nos saldrá un menú donde veremos nuestro Hardware y podremos seleccionar nuestra GPU (Si pones una CPU no se hará la fuerza bruta).

- Automáticamente se hará la fuerza bruta con nuestro diccionario preferido para el hash y con la GPU de tu pc.
