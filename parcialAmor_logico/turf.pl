
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 59).
jockey(lezcano,149, 50).
jockey(baratucci, 158, 55).
jockey(falero, 157, 52).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).


stud(elTute, valdivieso).
stud(elTute, falero).
stud(lasHormigas, lezcano).
stud(elCharabon, baratucci).
stud(elCharabon, leguisamo).
%botafogo peso maximo 52
preferencia(botafogo, 52).
preferencia(botafogo, baratucci).
%letrasMinimas 7
preferencia(oldMan, 7).
%energica depende de botafogo
preferencia(matBoy, 170).
%yatasto ninguno.

campeon(botafogo,gpNacional).
campeon(botafogo,gpRepublica).
campeon(oldMan, gpRepulica).
campeon(oldMan, palermoDeOro).
campeon(matBoy, gpCriadores).



%PUNTO 2
prefiere(botafogo,Jockey):-
    jockey(Jockey, _, Peso),
    Peso < 52.
prefiere(botafogo, baratucci).

prefiere(matBoy,Jockey):-
    jockey(Jockey, Altura, _),
    Altura > 170.

prefiere(oldMan, Jockey):-
    jockey(Jockey, _ , _),
    letrasDe(Jockey, Cantidad),
    Cantidad > 7.


%auxiliar

letrasDe(Jockey, Cantidad):-
    jockey(Jockey, _ , _),
    atom_length(Jockey, Cantidad).
    