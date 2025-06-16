
sumarElementos :: Num a => [a] -> a
sumarElementos [] = 0
sumarElementos (x:xs)= x + sumarElementos xs
--en recursion siempre plantear el caso base y el caso recursivo


--Esta es una version con patrones
sumarElementos' :: Num a => [a] -> a
sumarElementos' lista = sum lista 

--Ejercicio 2


frecuenciaCardiaca :: [Int]
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

promedioFrecuencia frecuenciaCardiaca = sum frecuenciaCardiaca / fromIntegral ( length frecuenciaCardiaca)

promedioFrecuencia :: (Fractional a) => [a] -> a
--la division funciona con solo factorial, por eso se hace fromIntegral para convertirlo a un tipo mas general


lafrecuenciaEnMinuto ::  Int -> Int
lafrecuenciaEnMinuto m =   frecuenciaCardiaca !!   minuto m
minuto :: Integral a => a -> a
minuto m = div m 10

frecuenciasHastaMomento m = take  (minuto m +1) frecuenciaCardiaca

esCapicua lista = concat lista ==  (reverse . concat) lista

--concat [[a]] -> a , reverse [a] -> [a]. No se puede hacer reverse.concat lista. Se debe componer las dos funciones a la vez
-- si hiciera reverse . concat lista estoy componiendo una funcion con un resultado.
