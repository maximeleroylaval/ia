dictionnary(sauver).
dictionnary(savoir).
dictionnary(avance).
dictionnary(abolir).
dictionnary(facade).
dictionnary(tacler).
dictionnary(raleur).
dictionnary(palais).
dictionnary(madame).
dictionnary(limace).

letter(e, 26).
letter(a, 25).
letter(i, 24).
letter(s, 23).
letter(n, 22).
letter(r, 21).
letter(t, 20).
letter(o, 19).
letter(l, 18).
letter(u, 17).
letter(d, 16).
letter(c, 15).
letter(m, 14).
letter(p, 13).
letter(g, 12).
letter(b, 11).
letter(v, 10).
letter(h, 9).
letter(f, 8).
letter(q, 7).
letter(y, 6).
letter(x, 5).
letter(j, 4).
letter(k, 3).
letter(w, 2).
letter(z, 1).

% Display the hangman graphic when you lose N roud
display_round(N) :-
   (N is 1, writeln('/'));
   (N is 2, writeln('/-'));
   (N is 3, writeln('/-^'));
   (N is 4, writeln('/-^_'));
   (N is 5, writeln('/-^_^'));
   (N is 6, writeln('/-^_^-'));
   (N is 7, writeln('you  are dead ! /-^_^-/'), abort).

% Set global variable to store the word to find
set_find(X) :- atom_string(X, S), retractall(user_find(_)), asserta(user_find(S)).

% Set global variable to store the characters inputs
set_word(X) :- atom_string(X, S), retractall(user_word(_)), asserta(user_word(S)).

% Compare if the character input is contained in the word to find
compare :-
   user_find(K), K \= "", string_codes(K, A),
   user_word(X), string_code(1, X, C),
   member(C, A)
   ;
   false.

% Count the number of occurences of a letter in a word
count([], _, 0).
count([X|T], X, Y):- count(T, X, Z), Y is 1 + Z.
count([X1|T], X, Z):- X1 \= X, count(T, X, Z).

% Update the number of letters found
assign_target(F, C, K, I, T, T1, G, O) :-
   member(F, C),
   O is I,
   G < O,
   T1 is T + K
   ;
   O is G,
   T1 is T.

% Count occurences of letter input in the word to be found and update it
% Also checks if the length of saved letters is changed from last round
add_value_target(T, T1, G, O) :-
   user_find(A), string_codes(A, C),
   user_word(D), string_code(1, D, F),
   count(C, F, K),
   string_length(D, I),
   assign_target(F, C, K, I, T, T1, G, O).

% Save user input in a string and checks wether or not the letter input
% has already been typed
add_char(X) :-
   user_word(L),
   (
       string_code(1, X, I),
       string_codes(L, A),
       not(member(I, A)),
       sub_string(X, _, 1, _, O),
       string_concat(O, L, L1), set_word(L1)
   ).

% Verify if the game is won
check_victory(T) :-
   user_find(R), string_length(R, I),
   T is I, write(R), writeln(' was the word, you won !'),
   abort
   ;
   true.

% Read player input
player_input(S) :-
   read(X), atom_string(X, S).

% Check heuristic of word
check_word([], [], _, 0).
check_word([X|W], [Y|F], U, R) :-
   X is Y, member(X, U),
   check_word(W, F, U, R1),
   R is R1 + 1
   ;
   check_word(W, F, U, R).

% Check in dictionnary the best words matching the partial answer
check_dictionnary(W, F, U, R) :-
   string_length(F, I),
   string_length(W, I2),
   string_codes(W, W1),
   string_codes(F, F1),
   string_codes(U, U1),
   I2 is I,
   check_word(W1, F1, U1, R),
   0 < R.

% Choose best heuristic value and word associated in list
choose_best_word_value([], O, O, I, I).
choose_best_word_value([[X,Y]|L], O, O2, I, I2) :-
   Y > I,
   choose_best_word_value(L, X, O2, Y, I2)
   ;
   choose_best_word_value(L, O, O2, I, I2).

% Choose best word from its heurisitc values
choose_best_word(L, O) :-
   choose_best_word_value(L, _, O, 0, _).

% Get maximum value in list
get_max([P|T], O) :- get_max_value(T, P, O).
get_max_value([], P, P).
get_max_value([H|T], P, O) :-
    H > P,
    get_max_value(T, H, O)
    ;
    get_max_value(T, P, O).

% Check if letter is contained within guessed word
check_letter(U, O, W) :-
   atom_string(O, S),
   string_code(1, S, L),
   string_codes(W, W1),
   string_codes(U, U1),
   member(L, W1),
   not(member(L, U1)).

% Choose best letter according to their weigth
choose_best_letter(U, O, Y) :-
   findall(V, (letter(X, V), check_letter(U, X, O)), L),
   get_max(L, I),
   letter(Y, I).

% Read AI input
ai_input(Y) :-
   user_word(U),
   user_find(F),
   (
       setof([W,R], (dictionnary(W), check_dictionnary(W, F, U, R)), L),
       length(L, I),
       I > 0,
       choose_best_word(L, O),
       choose_best_letter(U, O, Y)
       ;
       choose_best_letter(U, "abcdefghijklmnopqrstuvwxyz", Y)
   ), write("Letter choosen by AI: "), writeln(Y), !.

% Verify if game is lost
check_end(N) :-
   X is 7, X > N.

% Main loop of the game
% Display life, letters typed, and ask for an input
% It then checks whether or not the letter is contained in the answer
% Checks if the game is a win or lose
game_loop(N, T, G, AI) :-
   write('life: '), Life is 7 - N, writeln(Life),
   write('typed: '), user_word(L), writeln(L),
   check_end(N),
   writeln('please type a character'),
   (
       AI is 0,
       player_input(S)
       ;
       ai_input(S)
   ),
   add_char(S),
   compare,
   add_value_target(T, T1, G, G1),
   check_victory(T1),
   game_loop(N, T1, G1, AI)
   ;
   N1 is N + 1,
   display_round(N1),
   game_loop(N1, T, G, AI).

% Initialise the answer and letters typed to empty strings
init :-
   set_find(""),
   set_word(""),
   writeln('please enter a word to find:'),
   read(E), set_find(E).

% Main entry of program for a human player
start :-
   init(),
   game_loop(0, 0, 0, 0).

% Main entry of program for an AI player
start_ai :-
   init(),
   game_loop(0, 0, 0, 1).









