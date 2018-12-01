% Definition des operateurs
:-
   op( 800, fx, si ),
   op( 700, xfx, alors ),
   op( 300, xfy, ou ),
   op( 200, xfy, et ).

% Définition du prédicat fait/1 comme étant dynamique
:-
   dynamic(fait/1).

% Règles de la base de connaissances : si ... alors ...
si style(distance) alors role(tireur).
si style(sort) alors role(mage).
si style(melee) alors role(combattant).
si role(tireur) et element(glace) ou alt(reine) alors champion(ashe).
si role(tireur) et element(air) ou alt(sherif) alors champion(caitlyn).
si role(tireur) et element(poison) ou alt(monstre) alors champion(twitch).
si role(tireur) et element(feu) ou alt(pirate) alors champion(mf).
si role(mage) et element(feu) ou alt(elementaire) alors champion(brand).
si role(mage) et element(glace) ou alt(elementaire) alors champion(anivia).
si role(mage) et element(eau) ou alt(monstre) alors champion(fizz).
si role(mage) et element(feu) ou alt(artiste) alors champion(jhin).
si role(combattant) et element(terre) ou alt(elementaire) alors champion(malphite).
si role(combattant) et element(glace) ou alt(artiste) alors champion(mundo).
si role(combattant) et element(feu) ou alt(pirate) alors champion(gankplang).
si role(combattant) et element(eau) ou alt(sherrif) alors champion(vi).

% ch_arriere/1 : moteur d inference fonctionnant en chainage arriere
ch_arriere( But ) :-
   est_vrai( But ).

est_vrai( Proposition ) :- fait( Proposition ).
est_vrai( Proposition ) :- si Condition alors Proposition, est_vrai( Condition ).
est_vrai( Cond1 et Cond2 ) :- est_vrai( Cond1 ), est_vrai( Cond2 ).
est_vrai( Cond1 ou Cond2 ) :- est_vrai( Cond1 ) ; est_vrai( Cond2 ).

% ch_avant/0 : moteur d inference fonctionnant en chainage avant
ch_avant :-
   nouveau_fait( Nouveau ), !,
   write( 'Nouveau fait : ' ), write( Nouveau ), nl,
   assert( fait( Nouveau ) ),
   ch_avant.

ch_avant :-
   write( 'Plus de nouveaux faits déduits, la BC est saturée.'), nl.

nouveau_fait( NouvFait ) :-
    si Condition alors NouvFait,
    not( fait(NouvFait) ),
    recherche_fait( Condition ).

recherche_fait( Condition ) :-
    fait( Condition ).

recherche_fait( Cond1 et Cond2 ) :-
   recherche_fait( Cond1 ), recherche_fait( Cond2 ).

recherche_fait( Cond1 ou Cond2 ) :-
   recherche_fait( Cond1 ) ; recherche_fait( Cond2 ).

% check_exit/1 : vérifie si l'argument est exit
check_exit(Value) :-
       Value = 'exit',
       abort.

% main_game/0 : boucle de jeu principale
main_game :-
   writeln('Ajoutez un fait:'),
   read(E),
   not(check_exit(E)),
   not(recherche_fait(E)),
   assert(fait(E)),
   ch_avant,
   main_game.

main_game :-
   writeln('Fait déjà existant !'),
   main_game.

% clear/O : vide la liste des faits
clear :-
      retractall(fait(_)).

% jouer_avec_fait/0 point d'entrée secondaire (garde la liste des faits)
jouer_avec_fait:-
   ch_avant.

% play/0 : point d'entrée (vide la liste des faits)
play :-
   retractall(fait(_)),
   main_game.
