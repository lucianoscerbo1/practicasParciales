
data Heroe = Heroe{

    nombre :: String,
    epiteto :: String,
    reconocimiento :: Int,
    listaDeArtefactos :: [Artefacto],
    listaDeTareas :: [Tarea]
}

type Artefacto = (NombreArtefacto , Rareza)
type NombreArtefacto = String
type Rareza = Int

pasarAlaHistoria :: Heroe -> Heroe
pasarAlaHistoria heroe
    | reconocimiento heroe > 1000 =     cambiarEpiteto "El Mitico " heroe 
    | reconocimiento heroe > 500 =   ( añadirArtefacto lanzaOlimpo   . cambiarEpiteto "El Magnifico ") heroe
    | reconocimiento heroe > 100  =( añadirArtefacto xiphos  . cambiarEpiteto "Hoplita") heroe 
    |otherwise = heroe 

lanzaOlimpo = ("Lanza del Olimpo" , 100)
xiphos = ("Xiphos" , 50)

cambiarEpiteto :: String -> Heroe -> Heroe
cambiarEpiteto  nuevoEpiteto heroe  = heroe { epiteto = nuevoEpiteto}

añadirArtefacto :: Artefacto -> Heroe -> Heroe
añadirArtefacto  nuevoArtefacto heroe  = heroe { listaDeArtefactos =  nuevoArtefacto : listaDeArtefactos heroe }


--Punto 2--
--Tarea modifica nuestros heroes
type Tarea = Heroe -> Heroe

encontrarArtefacto ::  Artefacto->Tarea
encontrarArtefacto artefactoEncontrado heroe  = (añadirArtefacto (artefactoEncontrado)  .  sumarReconocimiento (tomarRarezaArtefacto artefactoEncontrado))  heroe 
--sumarReconocimiento me tiene que dar un heroe con reconocmiento modificado

sumarReconocimiento :: Int -> Heroe -> Heroe
sumarReconocimiento cantidad heroe  =  heroe { reconocimiento = reconocimiento heroe + cantidad}

tomarRarezaArtefacto :: Artefacto -> Rareza
tomarRarezaArtefacto  = snd 

--sumaReconocimiento , triplicar Rareza de artefactos, , desecha los que tienen menos de 1000,  añadir Objeto
escalarOlimpo heroe =    (añadirArtefacto (relampagoZeus)  . desecharArtefactos .  triplicarRareza . sumarReconocimiento 500) heroe

relampagoZeus = ("Relampago de Zeus", 500)

desecharArtefactos :: Heroe ->Heroe
desecharArtefactos heroe = añadirArtefacto (filter esComun) heroe

esComun :: Artefacto -> Artefacto
esComun artefacto = 1000 > rareza artefacto

triplicarRareza :: Heroe -> Heroe
triplicarRareza = añadirArtefacto triplicarRarezaArtefactos

triplicarRarezaArtefactos :: [Artefacto] -> [Artefacto]
triplicarRarezaArtefactos artefactos = map triplicarRarezaDelArtefacto artefactos


triplicarRarezaDelArtefacto ::Artefacto -> Artefacto
triplicarRarezaDelArtefacto (nombre , rareza) =  (nombre, rareza *3)