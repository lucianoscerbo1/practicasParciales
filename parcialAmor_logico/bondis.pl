% Recorridos en GBA:
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).
%ejemplo para elbono
recorrido(33, gba(norte), maipu).
recorrido(33, gba(sur), lanus).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

%conviene hacer beneficiario y personas por distinto lado.
persona(pepito).
persona(juanita).
persona(tito).
persona(marta).


beneficiario(juanita, estudiantil).
beneficiario(pepito, casasParticulares(gba(oeste))).
beneficiario(marta, jubilada).
beneficiario(marta, casasParticulares(caba)).
beneficiario(marta, casasParticulares(gba(sur))).

valorNormalBoleto(Linea, 500):-
    recorrido(Linea, _ , _),
    jurisdiccion(Linea, nacional).

valorNormalBoleto(Linea, 350):-
    recorrido(Linea, _ , _),
    jurisdiccion(Linea, provincial, caba).


%aca se tiene que meter un findall, para calcular el vlaor final, para encontrar todas las calles y multiplicarla
valorNormalBoleto(Linea, Costo):-
    jurisdiccion(Linea, provincial,buenosAires),
    cantidadCalles(Linea, Cantidad),
    bonoZonal(Linea,Plus),
    Costo is (25*Cantidad) + Plus.

pasaPorDistintasZonas(Linea):-
    jurisdiccion(Linea, provincial, buenosAires),
    recorrido(Linea, Zona1, _),
    recorrido(Linea, Zona2, _),
    Zona1 \= Zona2.

bonoZonal(Linea,50):-
    pasaPorDistintasZonas(Linea).

bonoZonal(Linea, 0):-
    not(pasaPorDistintasZonas(Linea)).

%a los jubilados le sale la mitad.
beneficio(jubilada,Linea,Costo):-
    valorNormalBoleto(Linea, CostoParcial),
    Costo is CostoParcial/2.


%A los estudiantes 50 pesos.
beneficio(estudiantil, _, 50).

%beneficio de zona, debe coicnidar con las casasParticlares
beneficio(casasParticulares(Zona),Linea,0):-
    recorrido(Linea, Zona, _).


%Este seria el predicado final
/*
el boleto depende de los beneficios que tenga la persona
Si es estudiantil el boleto siempre vale 50 no importa cual sea la linea
Si es casasParticulares debe coincidir la zona entre linea y beneficiario para etar subsidiado
Si es jubilado cuesta la mitad en todas las lineas.
No se acumulan beneficios
Ahora bien, una persona tiene varios beneficios pero el valor del boleto debe
ser el minimo, osea que no sea acumulan solo se aplica el beneficio
que le reduce el boleto lo mas posible
Me interesa la persona, la linea y su valor
Luego si es beneficiario o no y cual es su beneficio
lueog ver uantos beneficios tiene
 */

posiblesBeneficios(Persona,Linea,ValorBeneficio):-
    beneficiario(Persona,Beneficio),
    beneficio(Beneficio,Linea, ValorBeneficio).

costoViaje(Persona, Linea, Valor):-
    beneficiario(Persona, _),
    recorrido(Linea, _, _),
    posiblesBeneficios(Persona, Linea, ValorBeneficio),
    forall( (posiblesBeneficios(Persona,Linea, OtroValor), Valor\= ValorBeneficio), Valor < OtroValor).


%si una persona no tiene beneficios, paga el valor normal.

costoViaje(Persona, Linea, Costo):-
    persona(Persona),
    valorNormalBoleto(Linea,Costo),
    not(beneficiario(Persona,_)).









%auxiliar
cantidadCalles(Linea, Cantidad):-
   % recorrido(Linea, _, Calle),  obliga a que cantidadCalles/2 se ejecute una vez por cada calle posible.
    findall(Calle2,( recorrido(Linea,_,Calle2) ), CallesTotales),
    length(CallesTotales, Cantidad).



%Saber si dos líneas pueden combinarse, que se cumple cuando su recorrido pasa por una misma calle dentro de la misma zona.
puedenCombinarse(Linea1,Linea2):-
        recorrido(Linea1, Zona, Calle),
        recorrido(Linea2, Zona, Calle),
        Linea1 \= Linea2.

jurisdiccion(Linea, nacional):-
    recorrido(Linea,_, _),
    cruzaGeneralPaz(Linea).

jurisdiccion(Linea, provincial, Provincia):-
    recorrido(Linea, _ , _ ),
    queProvincia(Linea, Provincia),
    not(cruzaGeneralPaz(Linea)).
    

%auxiliares
queProvincia(Linea, buenosAires):-
    recorrido(Linea, gba(_),_).

queProvincia(Linea, caba):-
    recorrido(Linea, caba, _).

cruzaGeneralPaz(Linea):-
    recorrido(Linea, gba(_), _),
    recorrido(Linea, caba, _).


%deberia hacer un predicado que calcule cuantas lineas por la calle, y hacer una comparacion
cuantasPasanPor(Calle, Zona, Cantidad):-
    recorrido(_, Zona, Calle),
    findall(Linea, recorrido(Linea,Zona,Calle), LineasTotales),
    length(LineasTotales, Cantidad).
    


calleMasTransitada(Calle,Zona):-
    cuantasPasanPor(Calle, Zona, Cantidad),
    forall((recorrido(_,Zona,Calle2), Calle \= Calle2), (cuantasPasanPor(Calle2, Zona, Cantidad2), Cantidad > Cantidad2)).

%el resuelto hace un forall con 3 condiciones, primero invoca cuantasLineas pasan por la calle a comparar con otra.
%Para todo recorrido por la misma zona y disinta calle, cuantasPasan por la calle2 que se compara con calle1, despues la cantidadPrincipal tiene que ser mayor a la cantidadMenor.
% el antecedente es  (recorrido(_,Zona,Calle2), Calle \= Calle2) compuesto
%el consecuente es (cuantasPasanPor(Calle2, Zona, Cantidad2), Cantidad > Cantidad2) compuesto

calleDeTransbordo(Calle,Zona):-
    recorrido(_,Zona,Calle),
    cuantasPasanPor(Calle, Zona, Cantidad),
    forall(recorrido(_,Zona,Calle) , jurisdiccion(_, nacional)),
    Cantidad >= 3.


%Punto 5

    


%auxiliar
calleDeLinea(Linea, Calle):-
    recorrido(Linea, _ , Calle).
