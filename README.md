# Visión General.

Este proyecto ACME es para entretenerse y practicar el lenguaje ruby en algo que
se puede aplicar en la vida real.

La idea de este proyecto se me ocurrió porque tenía una raspberry pi, y quería
controlarla con una aplicación hecha en mi celular para reproducir música. No
obstante, al utilizar la raspberry pi una distribución linux como sistema
operativo, este proyecto _debería_ funcionar en cualquier computador que tenga
una distribución linux instalada.

ACME MPD API es una simple aplicación construida en Sinatra porque Sinatra es
simple, y esta aplicación no debe requerir de una base de datos para funcionar.
Ahora si alguien quiere usar Rails, podría usarlo creando un proyecto con el
flag `--api`, pero sería como matar una mosca con un tanque.

# Instalación y configuración.

¡PRUÉBELO! Este proyecto es de los que tiene que copiar e intrusear. Cualquier pregunta
será bienvenida en la pestaña de issues. MPD y MPC que son las dependencias del
proyecto se describen un poco más abajo.

Instale MPD y MPC en su sistema operativo. Luego ejecute el comando

> git clone https://github.com/KarlHeitmann/acme_mpd_api

Luego instale las dependencias ingresando a la carpeta del proyecto

> bundle install

Y corra el comando para ejecutar la aplicación:

> ruby app.rb

# ¿Qué es MPD?

Dentro de todos los reproductores de música que existen de código abierto,
existe uno que yo he encontrado muy especial. Se llama [mpd](https://www.musicpd.org/),
y lo conocí cuando usé archlinux hace casi una década, este [artículo es
bastante](https://wiki.archlinux.org/title/Music_Player_Daemon)
bueno y debiera servir para varias distribuciones linux, además que enseñan como
configurarlo y personalizarlo.

MPD es un _daemon_, un servicio que se ejecuta y que corre en segundo plano en
el ordenador. Cuando MPD está corriendo, uno puede comunicarse con él y darle
órdenes utilizando diferentes _clientes_ con los que uno puede darle órdenes
y recibir información de cosas como:
- Listar los archivos de música de la base de datos de canciones en el
  computador
- Mostrar qué canción se está tocando ahora
- Ordenar reproducir la canción actual
- Pausar la canción actual
- Avanzar a canción siguiente de la lista de reproducción
- Etc...

Algunos clientes que yo he usado para conectarme con mpd son
- [mpc](https://www.musicpd.org/clients/mpc/) cliente de linea de comandos,
  a través de un terminal uno usa mpc y puede dar órdenes y recibir información
  de mpd
- [ncmpc](https://musicpd.org/clients/ncmpc/) cliente de consola escrito en
  ncurses. Uno lo ejecuta en un terminal y funciona, se puede desplazar usando
  letras, así como el viejo instalador de Windows.


# ¿Por qué existe este proyecto?

La principal ventaja que veo de usar este reproductor, es que utiliza pocos
recursos. Uno le da la orden y MPD se pone a trabajar. ¡Nada mejor que eso!

Siempre he mantenido mi música en formato MP3 (si, los discos los ripeaba del
original), y nunca me ha atraído esta idea de escuchar la música desde servicios
de streaming. Si un día te quedas sin internet, ¿Qué haces?. Además, ahora tengo
dificultades para reproducir música en mp3 en un computador que no diré la marca
pero que no es muy amistoso con los derechos de copia, así que que mejor que
usar una vieja raspberry pi que tenía guardando polvo.

Ahora bien, los clientes para MPD a mi juicio dejan bastante que desear, y he
tenido problemas para conectarme a MPD desde otro computador conectado en la
red. Todo resulta muy engorroso. Así que por eso decidí crear este proyecto: un
servidor web que pueda dejar corriendo en la raspberry pi, al cual me pueda
conectar desde cualquier dispositivo en la red local, y así desde cualquier
dispositivo controlar el MPD que corre en la raspberry pi, y que va conectada al
equipo de música.

# ¿Cómo funciona?

Al correr el proyecto con `ruby app.rb` (no olvide previamente correr el `bundle
install`), el servidor se levanta y comienza a escuchar conexiones. Cuando
recibe una petición que llega al endpoint definido, la aplicación **correrá el
comando mpc** con un argumento que le permita ejecutar una orden, con lo que le
ordenará a MPD hacer algo, o le pedirá información sobre el estado de sus
canciones.

Esta aplicación realizará una llamada al sistema operativo con cada llamada al
comando *mpc*. Pero decidí hacer esto de esta forma porque es lo más sencillo.
Para aportar en este proyecto, le recomiendo que primero se familiarice con los
comandos básicos de **mpc**.

El objetivo es que cuando el servidor reciba la respuesta del comando mpc
enviado, la respuesta la tome y la estandarice en formato JSON, y se la envie
como respuesta a quien haya hecho la solicitud HTTP. Esta es la parte
entretenida del proyecto: ir creando endpoints en sinatra, donde cada endpoint
use un comando distinto de MPC, analizar el string entregado como respuesta,
y estandarizarlo en formato JSON. Tome el ejemplo del endpoint `get '/' do`, que
es el primero definido. Ese endpoint está completo. Observelo y comparelo con el
llamado que se hace usando el comando `mpc` desde el terminal. Fíjese que el
código usa los métodos `split`, `gsub`, `trim` y map principalmente. ¡No son más
que métodos estándar de los strings y de los arrays de Ruby! ¡Muy sencillo! Pero
hay que estudiar el programa `mpc` para entender esto. Para estudiarlo, la mejor
manera es observándolo en acción y ejecutándolo, probándolo, experimentándolo.

Si bien existen [librerías](https://www.musicpd.org/libs/) para conectarse a MPD
sin tener que usar clientes (que es como funciona este proyecto), el problema es
que no encontré librerías para Ruby, en el enlace anterior hay algunas para C,
C++, Python, Java y haxe.

# Mirando hacia adelante...

Al tener este servidor funcionando de manera básica, ahí viene lo interesante.
Usted puede hacer una aplicación web en Vue.JS o Ruby on Rails, que consuma la API que
proporciona este proyecto, y de esa manera controlar un reproductor de música
con su propia aplicación web. Su aplicación web puede además solicitar
información de otras API de internet. Por ejemplo para obtener la letra de la
canción actual, la imagen de la carátula del disco que se está reproduciendo, la
biografía de la banda actual, etc.

Pero eso no es todo, también puede aventurarse con [React Native](https://reactnative.dev/),
que es un paquete de node.js que permite crear aplicaciones móviles usando
React. De esta manera, puede crear una aplicación móvil que se conecte a este
servidor, y le de las órdenes a mpd para que reproduzca su música.

Este proyecto busca ser un puente para llevar a un estándar web como lo es hoy
en día el JSON la interfaz que provee **mpc**, y así hacer fácil que alguien
pueda crear su propia aplicación móvil o web que consuma esta API.

No he estudiado mucho este tema, pero _debería_ poder incluirse algunos módulo
de C en Ruby. Algo interesante sería tomar la librería [libmpdclient](https://www.musicpd.org/libs/libmpdclient/)
y ver cómo hacer para que la aplicación en Sinatra la use para comunicarse
directamente con mpd, sin tener que pasar por un intermediario como mpc. ¿Cómo
se hace? ¿Es viable?

# Homenaje

Al profesor Viktor Slüsarenko del departamento de física de la UTFSM, el Profesor
solía bautizar los proyectos de participación voluntaria como "Proyecto ACME".

![slusa](https://user-images.githubusercontent.com/3003032/145646044-b7d6de97-ad27-4f3b-8508-c881e1cfa740.jpg)

Siempre lo recordaré por su sentido del humor y su intención de explicar las cosas con
ejemplos y analogías sencillas

![DSC01349](https://user-images.githubusercontent.com/3003032/145646816-b8630915-357c-4c6d-b6dc-3a1891b58997.jpeg)

Descansa en paz, Maestro.



