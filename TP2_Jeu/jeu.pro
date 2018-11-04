set_find(X) :- atom_string(X, S), retractall(user_find(_)), asserta(user_find(S)).

set_word(X) :- atom_string(X, S), retractall(user_word(_)), asserta(user_word(S)).

compare :-
   user_find(K), K \= "", string_codes(K, A),
   user_word(X), string_code(1, X, C),
   member(C, A)
   ;
   false.

count([],_,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1 + Z.
count([X1|T],X,Z):- X1 \= X, count(T,X,Z).

assign_target(F, C, K, I, T, T1, G, O) :-
   member(F, C),
   O is I,
   G < O,
   T1 is T + K
   ;
   O is G,
   T1 is T.

add_value_target(T, T1, G, O) :-
   user_find(A), string_codes(A, C),
   user_word(D), string_code(1, D, F),
   count(C, F, K),
   string_length(D, I),
   assign_target(F, C, K, I, T, T1, G, O), writeln(T1).

add_char(X) :-
   user_word(L),
   writeln(L),
   (
       string_code(1, X, I),
       string_codes(L, A),
       not(member(I, A)),
       sub_string(X, _, 1, _, O),
       string_concat(O, L, L1), set_word(L1)
   ).

start :-
   set_find(""),
   set_word(""),
   writeln('please enter a word to find:'),
   read(E), set_find(E),
   loop(0, 0, 0).

check_end(N) :-
   X is 7,
   X > N.

check_victory(T) :-
   user_find(R), string_length(R, I),
   T is I, writeln('you won !'), abort
   ;
   true.

round(N) :-
   (N is 1, writeln('/'));
   (N is 2, writeln('/-'));
   (N is 3, writeln('/-^'));
   (N is 4, writeln('/-^_'));
   (N is 5, writeln('/-^_^'));
   (N is 6, writeln('/-^_^-'));
   (N is 7, writeln('you  are dead ! /-^_^-/'), abort).

loop(N, T, G) :-
   write('life: '), Life is 7 - N, write_ln(Life),
   check_end(N),
   writeln('please type a character'),
   read(X), atom_string(X, S), add_char(S),
   compare,
   add_value_target(T, T1, G, G1),
   check_victory(T1),
   loop(N, T1, G1)
   ;
   N1 is N + 1,
   round(N1),
   loop(N1, T, G).
