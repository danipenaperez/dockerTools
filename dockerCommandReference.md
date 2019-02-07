# Simple Docker Commands

Comandos Docker


## Listar Imagenes Locales
>docker images

## Descargar una imagen (la tendremos en el registry local)
>docker pull %repository/idImage%

### Inspeccionar informacion de una imagen (puertos, volumenes y demas info..)
>docker inspect $imageName:$version 

### Crear Imagen Docker
1.Crear un archivo llamado "Dockerfile" (sin extension y con ese nombre)  con la definicion

>docker build -t "imageName:version" $pathToFindDockerFile

Ejemplo
>docker build -t "myServiceImage:v1" .  (Esto generara una imagen taggeada con myServiceImage y version v1)

### Arrancar un contenedor con una imagen:
docker run -options
@see https://docs.docker.com/engine/reference/commandline/exec/#options
-d hace que se ejecute en segundo plano como daemon
-p expone por la interfaz de docker el puerto del contenedor puertoDocker:puertocontenedorInterno
--name (usara ese name para referenciarlo)

>docker run -d -p 49161:1521  wnameless/oracle-xe-11g

>docker run -d -p 9999:8080 myServiceImage:v1 (crea y arranca un contenedor basado en mySericeImage version v1 y su puerto interno 8080 lo tendremos accesible a traves del engine de docker en el 9999)

Ejemplo Assignar nombre a contenedor que se va a crear en el arranque con docker run:
>docker run -d -p 8080:8080 -p 1521:1521 --name oracleSeconf sath89/oracle-xe-11g  (esto lo llamara oracleSeconf)

### Listar contenedores 
>
>docker ps -a o tambien docker container ls --all  (lista todos los contenedores)
>docker ps (lista los contenedores arrancados)

### Ver los logs de un contenedor
>docker logs -f 23d0bc5a0f52

### Parar un contenedor
docker stop %idContainer%

### Borrar un contenedor 
>docker rm %idContainer% (pero no borra el volumen asociado)
>docker rm -v idContainer (Borrar container y los volumenes asociados)
>docker rm --force -v idContainer (Borrar un contenedor que esta corriendo (-force) y el volumen)
>docker rm $(docker ps -a -q) (Borrar todos los contenedores parados)


### Para acceder a la shel de un contenedor corriendo
>docker exec -it <container name> /bin/bash   (ojo usar el container name y noel containerId)

### Para acceder al file system de un contenedor:
>docker exec -t -i idContainer /bin/bash

### LOGS Ver salida continua de los logs de un contenedor (tambien se puede arrancar el contenedor sin usar -d (daemon) y obtendremos la salida por consola)
>docker logs fdf3c2349621 -f

### INSPECT Obtener toda la info de un contenedor (formato yaml)
>docker inspect idContainer    (esto retorna info de la red, del volumen montado, etc...

### PORTS consultar los puertos que expone un contenedor a traves del engine de docker
Consultar los puertos que expone un contenedor
>docker port idContainer

### RENOMBRAR contendor 
>docker rename $idcontainer myFriendlyName (ahora puedes hacer ">docker run myFriendlyName")

### VOLUMENES COMPARTIDOS (se puede especificar el filesystem y tambien hacer que 2 contenedores compartan el volumen y por lo tanto informacion/configuration, etc) 
>docker run -d -p 8080:8080 -p 1521:1521 -v /my/computerfilesystem/path:/ContainerDirectory sath89/oracle-xe-11g (arranca el contenedor y el monta /my/computerfilesystem/path dentro de /ContainerDirectory del contenedor. Cuidado al borrar el contenedor, por si comparte el volumen)

### FILESYSTEM extraer/importar archivos de/hacia el contenedor (no es necesario que el contenedor este arrancado)
>docker cp /tmp/foo.txt $idContainer:/foo.txt (copia el archivo /tmp/foo.txt de nuestro file system a la ruta raiz del contenedor)
>docker cp $idContainer:/foo.txt /tmp/foo.txt (copia el archivo /foo.txt del contenedor a /tmp/foo.txt de nuestro filesystem)

### Crear una red
>docker network create --driver=bridge atlassian-network

### Listar Redes configuradas en el engine
>docker network list

### Arrancar instancia usando un determinado bridge de red y un name para la instancia (ejemplos)
>docker run -d -p 33061:3306 --net=atlassian-network --name mysql57 -e MYSQL_ROOT_PASSWORD=secret mysql:5.7 --character-set-server=utf8mb4
>docker run --net=atlassian-network --name jira-software --detach --publish 8082:8080 cptactionhank/atlassian-jira-software:latest

### Broken Containers (Para entrar en contenedor que no puede arrancar)
En 2 pasos, hace commit de la imagen mysql57 a mysql57_broken y luego ejecuta el comando bin/bash sobre el contenedor creado y se accede a la shell
>docker commit mysql57 mysql57_broken && docker run -it mysql57_broken /bin/bash

