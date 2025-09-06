%EL AMOR ESTA EN EL AIRE PARCIAL 2024

%Registro
%persona(Nombre,Edad,Genero).
persona(luciano, 20, masculino).
persona(lorem, 22, femenino).
persona(ipsum, 17, noBinario).

%datos(Persona, EdadMinima, EdadMaxima, ).
datos(luciano, 19, 72 ).
datos(lorem, 19, 77).

interesGenero(luciano, femenino).
interesGenero(luciano, bichota).
interesGenero(luciano, masculino).

interesGenero(lorem, masculino).

gustoDe(luciano, algo).
gustoDe(luciano, algo2).
gustoDe(luciano, algo3).
gustoDe(luciano, algo4).
gustoDe(luciano, algo5).


gustoDe(lorem, algo).
gustoDe(lorem, nose).
gustoDe(lorem, nose2).
gustoDe(lorem, nose3).
gustoDe(lorem, nose4).


disgustoDe(luciano, esto).
disgustoDe(luciano, esto2).
disgustoDe(luciano, esto3).
disgustoDe(luciano, esto4).
disgustoDe(luciano, esto5).


disgustoDe(lorem, esta).
disgustoDe(lorem, esta2).
disgustoDe(lorem, esta3).
disgustoDe(lorem, esta4).
disgustoDe(lorem, esta5).


indiceDeAmor(luciano, lorem, 1).
indiceDeAmor(luciano, lorem, 8).
indiceDeAmor(luciano, lorem, 5).






perfilCompleto(Persona):-
    persona(Persona,_,_),
    datos(Persona,_,_),
    interesGenero(Persona, _),
    cantidadGustos(Persona,CantidadGustos),
    cantidadDisgustos(Persona, CantidadDisgustos),
    mayorDeEdad(Persona),
    CantidadDisgustos >= 5, 
    CantidadGustos >= 5.

mayorDeEdad(Persona):-
    persona(Persona, Edad, _),
    Edad >= 18.

perfilIncompleto(Persona):-
    persona(Persona, _ , _),
    not(perfilCompleto(Persona)).

%se pueden contar a la vez con un predicado solo haciendo dos findall a la vez, pero no se si conviene
cantidadGustos(Persona,GustosTotales):-
    datos(Persona,_,_),
    findall(Gusto, gustoDe(Persona, Gusto), CantidadGustos),
    length(CantidadGustos, GustosTotales).

cantidadDisgustos(Persona,DisgustosTotales):-
    datos(Persona,_,_),
    findall(Disgusto, disgustoDe(Persona, Disgusto), CantidadDisgustos),
    length(CantidadDisgustos, DisgustosTotales).



%ANALISIS
almaLibre(Persona):-
    perfilCompleto(Persona),
    forall(persona(_,_,GeneroAInteresar), interesGenero(Persona, GeneroAInteresar)).
%PAra todos los generos que existen en nuestra base de datos, a esta persona le debe interesar.

almaLibre(Persona):-
    perfilCompleto(Persona),
    rangoDePretendencia(Persona,Rango),
    Rango > 30.

rangoDePretendencia(Persona,Rango):-
    datos(Persona, EdadMinima, EdadMaxima),
    Rango is EdadMaxima - EdadMinima.

quiereLaHerencia(Persona):-
    persona(Persona,Edad,_),
    datos(Persona,EdadMinima,_),
    EdadPretendida is Edad + 30,
    EdadPretendida =< EdadMinima.

indeseable(Persona):-
    perfilCompleto(Persona),
    forall(perfilCompleto(Pretendiente), not(pretendiente(Pretendiente,Persona))).
%MATCHES
%el genero y la edad del pretendido del pretendido coinciden con los intereses del pretendiente. y al menos un gusto en comun.
pretendiente(Pretendiente,Pretendido):-
    datos(Pretendiente,EdadMinima,EdadMaxima),
    persona(Pretendido,EdadPretendido,GeneroPretendido),
    interesGenero(Pretendiente,GeneroPretendido),
    between(EdadMinima, EdadMaxima, EdadPretendido),
    gustoEnComun(Pretendiente,Pretendido),
    Pretendiente \= Pretendido.
    
%auxiliar
gustoEnComun(Persona1,Persona2):-
    gustoDe(Persona1,Gusto),
    gustoDe(Persona2,Gusto).


hayMatch(Persona1, Persona2):-
    perfilCompleto(Persona1),
    perfilCompleto(Persona2),
    pretendiente(Persona1,Persona2),
    pretendiente(Persona2,Persona1).

trianguloAmoroso(Persona1, Persona2, Persona3):-
    pretendiente(Persona1,Persona2),
    pretendiente(Persona2,Persona3),
    pretendiente(Persona3,Persona1),
    not(hayMatch(Persona1, Persona2)),
    not(hayMatch(Persona2, Persona3)),
    not(hayMatch(Persona3, Persona1)).


unoParaElOtro(Persona1,Persona2):-
    hayMatch(Persona1, Persona2),
    todoMeGusta(Persona1,Persona2),
    todoMeGusta(Persona2,Persona1).

%auxiliar
todoMeGusta(Persona1,Persona2):-
    perfilCompleto(Persona1),
    perfilCompleto(Persona2),
    forall(gustoDe(Persona1,Gusto),  not(disgustoDe(Persona2, Gusto))).


%MENSAJES
%indice de amor forma parte de la base de conocimiento
desbalance(Persona1,Persona2):-
    indicePromedioDeEnviados(Persona1, Persona2, Promedio1),
    indicePromedioDeEnviados(Persona2, Persona1, Promedio2),
    Promedio2Final is Promedio2 * 2,
    Promedio1 > Promedio2Final. 

indicePromedioDeEnviados(Persona, Persona2, Promedio):-
    perfilCompleto(Persona),
    perfilCompleto(Persona2),
    mensajesEnviados(Persona,Persona2,MensajesEnviados),
    indiceDeEnviados(Persona,Persona2, IndiceTotal),
    Promedio is IndiceTotal / MensajesEnviados. 

mensajesEnviados(Persona,Persona2,MensajesEnviados):-
    perfilCompleto(Persona),
    perfilCompleto(Persona2),
    findall(Persona, indiceDeAmor(Persona, Persona2, _), MensajesTotales), %cuantas veces hace de emisor es similar a cuantos mensajes manda.
    length(MensajesTotales, MensajesEnviados).

indiceDeEnviados(Persona,Persona2,IndiceDeEnviados):-
    perfilCompleto(Persona),
    perfilCompleto(Persona2),
    findall(Indice, indiceDeAmor(Persona, Persona2, Indice), Indices),
    sum_list(Indices,IndiceDeEnviados).
    

%ghostea la Persona a la Persona2 EN ESTE CASO NO ES NECESARIO EL FORALL. Ya que con uno que no conteste se cumple para todos los que envia.
ghostea(Persona,Persona2):-
    perfilCompleto(Persona),
    perfilCompleto(Persona2),
    mensajeEnviado(Persona2,Persona),
    not(mensajeEnviado(Persona,Persona2)),
    Persona \= Persona2.


mensajeEnviado(Persona,Persona2):-
    indiceDeAmor(Persona, Persona2, _).
/*
ghostea(Persona, OtraPersona) :-
  leEscribioPeroNoResponde(Persona, OtraPersona).

leEscribioPeroNoResponde(Persona, OtraPersona) :-
  indiceDeAmor(Persona, OtraPersona, _),
  not(indiceDeAmor(OtraPersona, Persona, _)).*/