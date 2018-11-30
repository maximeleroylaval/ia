% Definition des operateurs
:-
   op( 800, fx, si ),
   op( 700, xfx, alors ),
   op( 300, xfy, ou ),
   op( 200, xfy, et ).

:-
   dynamic(fait/1).

% données du problème : fait( X ) - à  ajouter


% Règles de la base de connaissances : si ... alors ... - à ajouter
si blizzard et rts et futuriste alors stacraft.
si blizzard et rts et fantasy alors warcraft.
si blizzard et moba alors hots.
si blizzard et mmorpg alors wow.
si blizzard et rpg alors diablo.
si blizzard et fps alors overwatch.
si ea et fps alors battlefield.
si ea et mmorpg et futuriste alors swtor.
si ea et rpg et fantasy alors dragon.
si riot et moba alors lol.
si blizzard et fantasy et pc et online ou rpg et online alors wow.

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

% main_game/0 : point d'entrée secondaire (garde la liste des faits)
main_game :-
   writeln('Ajoutez un fait:'),
   read(E),
   not(recherche_fait(E)),
   assert(fait(E)),
   ch_avant,
   main_game.

main_game :-
   writeln('Fait déjà existant !'),
   main_game.

% play/0 : point d'entrée (vide la liste des faits)
play :-
   retractall(fait(_)),
   main_game.

