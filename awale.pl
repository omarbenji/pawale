% Prolog file

/* --- Specification ---

Game state is defined by, twoo list
one for each player, ( x, y, ....)
x, y represent the number of seeds by hole, there is six holes by player.
Score is defined by how many seeds a player captured.

in order to simplify the code, we consider

1 2 3 4 5 6
6 5 4 3 2 1

it seems simplier to reverse the list before drawing it and keeping a natural order for processing
*/

% -----------------------------Main Menu ----------------------------- 

launch_game:- repeat, main_menu, !.

main_menu:- write('1. Joueur contre joueur'), nl,
            write('0. Quitter le jeu'), nl,
            nl,
            read(Choice), nl, launch(Choice), nl,
            Choice=0.

launch(0):- write('Au revoir'), ! .
launch(1):- write('Nouvelle partie, humain contre humain'),
            nl, game_loop_pvp([4, 4, 4, 4, 4, 4], [4, 4, 4, 4, 4, 4], 0, 0, 'joueur1'),
            nl, !.

launch(_):- write('Savez-vous lire ?').

% -----------------------------Game Loop ----------------------------- 

diff(X,X):- !, fail.
diff(_,_).

element(X, [T|Q]):- X = T, !, true.
element(X, [_|Q]):- element(X, Q).

elements(X, [X|Q]).
elements(X, [_|Q]):- element(X, Q).

mooves(_, [], L, L).
mooves(N, [T|Q], Tmp, R):- NI is N +1, diff(T, 0), mooves(NI, Q, [NI|Tmp], R), !.
mooves(N, [_|Q], Tmp, R):- NI is N + 1, mooves(NI, Q, Tmp, R).
mooves(L, R):- mooves(0, L, [], R).


% How to detect if the game entered in a cycle
% implement other victory condition
is_win(S, Turn):- S >= 25, nl, nl, write(Turn), write(' a gagné. \n Fin de la partie \n\n').

get(L, C, R):- get(1, L, C, R).
get(I, [_|Q], C, R):- II is I +1, get(II, Q, C, R), !. 
get(X, [T|Q], X, T).

add_to_list(N, L, NC, R):- add_to_list(N, [], L, NC, R).
add_to_list(N, L, [T|Q], NC, R):- NN is N -1, N > 0, TT is T + 1, add_to_list(NN, [TT|L], Q, NC, R), !.
add_to_list(N, L, [T|Q], NC, R):- add_to_list(N, [T|L], Q, NC, R).
add_to_list(N, T, [], N,T).

%add_from(N, Pos, L, R):- 


% 11 or 12
%seed(I1, I2, Choice, O1, O2):- get(I1, choice, N), X is round(N / 11) + 1, seed(I1, I2, Choice,  
%seed(I1, I2, Choice, O1, O2):- get(I1, Choice, N), add_to_list(N, I1, NN, R), write(NN), nl, write( R).
seed(I1, I2, Choice, O1, O2):- get(I1, Choice, N), 

%


% I -> input, O -> output, 1 calling player, 2 oponement
% first, get the number of seeds in the selected holes
%seed(I1, I2, Choice, O1, O2 ):- get(I1, Choice, N), seed(0, 0, Choice, N, I1, I2, [], []).

% copy I1 to O2 until we reach the selected holls
%seed(0, H, X, N, [T|Q], I2, O1, O2):-  HI is H + 1, diff(HI, X), seed(0, HI, X, N, Q, I2, [T|O1], O2).

% here we reach the selected holl
%seed(G, H, N, X, [T|Q], I2, O1, O2):- H = X, HI is H +1, seed(1, HI, N, X, Q, I2, [0|O1], O2).

% distribute the seeds in the player field, until there is no seed or we reach end
%seed(1, H, N, X, [T|Q], I2, O1, O2):- TI is T + 1, HI is H +1, NI is N - 1, diff(NI, 0), seed(1, HI, NI, X, Q, I2, [TI|O1], O2).
%seed(1, H, 0, X, [T|Q], I2, O1, O2):- HI is H +1, seed(1, HI, 0, X, Q, I2, [T|O1], O2).

%reach the player one field end, ! reverse ?
%seed(1, H, N, X, [], I2, O1, O2):- seed(1, 0, N, X, [], I2, reverse(O1), O2).

% distribute on the other field
%seed(1, H, N, X, [], [T|Q], O1, O2):- TI is T + 1, HI is H +1, NI is N - 1, diff(NI, 0), seed(1, HI, NI, X, Q, I2, O1, [TI|O2]).
%seed(1, H, 0, X, [], [T|Q], O1, O2):- HI is H +1, seed(1, HI, 0, X, Q, I2, O1, [TI|O2]).


% if more than 12
%seed(1, H, N, X, [], [], O1, O2):- NI is N -1, diff(NI, 0), seed(2, 0, NI, X, O1, O2, O1, O2).
%seed(2, H, N, X, [T|Q], I2, O1, O2):- NI is N -1, HI is H + 1, diff(NI, 0), diff(HI, X), TI is TI +1, seed(2, HI, NI, X, Q, I2, [TI|O1], O2).

% more than 18, fuck that shit

%end condition 
%seed(2, H, 0, X, _, _, O1, O2).
%seed(1, H, 0, X, [], [], O1, O2).
                             

game_loop_pvp(Map1, Map2, Score1, Score2, Turn):- is_win(Score1, 'joueur1'). 
game_loop_pvp(Map1, Map2, Score1, Score2, Turn):- is_win(Score2, 'joueur2'). 


% ajouter conteur de graine prises
game_loop_pvp(Map1, Map2, Score1, Score2, 'joueur1'):- 
                    draw_game(Map1, Map2, Score1, Score2, 'joueur1'),
                    
                    write('Vous pouvez semer depuis les trous: '),
                    mooves(Map1, R), reverse(R, M), write(M),
                    repeat, nl, read(Choice), element(Choice, M),
                    write(Choice),
                    
                    % redistribute the map and update scores
                    seed(Map1, Map2, Choice, N_map1, N_map2),
                    take(Map2, Score, N_map2, N_score1),
                    game_loop_pvp(N_map1, N_map2, N_score1, Score2, 'joueur2').


game_loop_pvp(Map1, Map2, Score1, Score2, 'joueur2'):- 
                    draw_game(Map1, Map2, Score1, Score2, 'joueur2'),

                    write('Vous pouvez semer depuis les trous: '),
                    mooves(Map2, R), reverse(R, M), write(M),
                    repeat, nl, read(Choice), element(Choice, M),
                    write(Choice),
                    
                    seeding(Map1, Map2, Score2, Choice, N_map1, N_map2, N_score2),
                    game_loop_pvp(N_map1, N_map2, Score1, N_score2, 'joueur2').
% ----------------------------- Draw ----------------------------- 

% reverse a list
reverse([], L, L).
reverse([T|Q], Tmp, Res) :- reverse(Q, [T| Tmp], Res).
reverse(L, LP) :- reverse(L, [], LP).

% draw primitive
draw([T|Q]) :- write(T), tab(4), draw(Q).
draw([]).

% print the map
draw_game(P1, P2, S1, S2, Turn):- 
                    write('\n\n'),
                    write('Joueur 1 |'), tab(2), draw(P1), nl,
                    reverse(P2, RP2),
                    write('Joueur 2 |'), tab(2), draw(RP2), nl,
                    nl, write('Joueur 1:'), tab(2), write(S1), nl,
                    write('Joueur 2:'), tab(2), write(S2), nl,
                    write('Tour de: '), write(Turn), nl,
                    nl, nl, nl.

