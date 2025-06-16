import Text.Show.Functions ()
import Distribution.TestSuite (OptionType(optionFileExtensions))
data Atraccion = Atraccion {

    nombre :: String,
    alturaMinima :: Float,
    duracion :: Float,
    opiniones :: [String],
    mantenimiento ::Bool,
    listaDeReparaciones :: [Reparaciones],
    score :: Float

} deriving (Show)

data Reparaciones = Reparaciones {
    duracionReparacion :: Int, 
    trabajo :: TrabajoReparacion
} deriving (Show)

type TrabajoReparacion = Atraccion -> Atraccion

parque1 = Atraccion { nombre= "Hola", alturaMinima = 110, duracion = 5, opiniones = ["Grosa", "Buena", "Picante"], mantenimiento = False, listaDeReparaciones = [], score = 0} 

cantidadReparaciones :: Atraccion -> Int
cantidadReparaciones  = length . listaDeReparaciones 
longitudNombre :: Atraccion -> Int
longitudNombre = length .  nombre
longitudOpiniones :: Atraccion -> Int
longitudOpiniones = length . opiniones
calculoPuntaje :: Atraccion -> Float
calculoPuntaje atraccion = 10 *  fromIntegral (longitudNombre atraccion ) + 2 *  fromIntegral ( longitudOpiniones atraccion)

cambiarScore :: Atraccion -> Float -> Atraccion
cambiarScore atraccion nuevoScore =  atraccion { score = nuevoScore}

masBuenoQue :: Atraccion -> Atraccion
masBuenoQue atraccion 
    |  duracion atraccion > 10 = cambiarScore atraccion 100
    | duracion atraccion < 10 && cantidadReparaciones atraccion < 3 = cambiarScore atraccion . calculoPuntaje $ atraccion 
    | otherwise = cambiarScore atraccion (alturaMinima atraccion * 10)

    --Puntaje Atraccion ->Int ,, cambiarsCORE Atraccion -> Int -> Atraccion
    --Lo que hice fue realizar una aplicacion parcial con cambiarScore ya le pase la atraccion, genere una nueva funcion que espera
    --el entero para generar la nueva atraccion con el cambio de score.

--Punto 2

eliminarReparacion :: Atraccion -> [Reparaciones]
eliminarReparacion atraccion = drop 1 . reverse $  listaDeReparaciones atraccion 




ajusteDeTornilleria ::Float -> Atraccion -> Atraccion 
ajusteDeTornilleria  cantidadTornillos atraccion
    | cantidadTornillos + duracion atraccion < 10 = atraccion { duracion = cantidadTornillos + duracion atraccion}
    | otherwise = atraccion {duracion = 10}


engrase:: Atraccion -> Float -> Atraccion
engrase = calculoEngrase . agregarOpinion opinionValiente

-- qlo que pasa en engrase' es que hago aplicacion parcial en Agregaropinoin, genero una nueva funcion que es Atraccion -> Atraccion
--despues calculo engrase en una funcio Atraccion -> Float -> Atraccion , los parametros que paso son float y atraccion

calculoEngrase :: Atraccion -> Float -> Atraccion
calculoEngrase  atraccion cantidadgrasa = atraccion {alturaMinima = alturaMinima atraccion + ( 0.1 * cantidadgrasa) }
agregarOpinion :: String -> Atraccion-> Atraccion
agregarOpinion nuevaOpinion atraccion = atraccion {opiniones = nuevaOpinion : opiniones atraccion }
opinionValiente :: String
opinionValiente = "para Valientes"

--Agregar String -> Atraccion -> Atraccion , Atraccion Float Atraccion


mantenimientoElectrico atraccion =  atraccion { opiniones = tomarDosOpiniones atraccion}

tomarDosOpiniones = take 2  . opiniones 

mantenimientoBasico :: Atraccion -> Atraccion
mantenimientoBasico  = flip engrase 10 .  ajusteDeTornilleria 8 

--ajusteTornillos  Atraccion -> Atraccion    engrase ATRACCION -> Flloat -> Atraccion, tuve que poner flip porque engrase espera primero atraccion y luego la grasa
-- yo estoyt pasando rprimero la grasa

meDaMiedito atraccion = 