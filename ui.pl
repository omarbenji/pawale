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

% reverse a list
reverse([], L, L).
reverse([T|Q], Tmp, Res) :- reverse(Q, [T| Tmp], Res).
reverse(L, LP) :- reverse(L, [], LP).

% draw primitive
draw([T|Q]) :- write(T), tab(4), draw(Q).
draw([]).

% print the map
draw_map(P1, P2):- write('Joueur 1 |'), tab(2), draw(P1),
                    reverse(P2, RP2),
                    nl,  write('Joueur 2 |'), tab(2), draw(RP2).
