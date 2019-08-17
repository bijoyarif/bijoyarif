readfile(File, L) :- 
      see(File), 
        readfile1([], L1),
        seen,
        reverse(L1, [], L2),
        scanner(L2, L),!.

readfile1(In, Out) :-
        get_char(N), 
        ( N = end_of_file
                -> In = Out
                 ; readfile2(N, In, Out)
        ).

readfile2(' ', In, Out) :- !,
        readfile1([' '| In], Out).
readfile2('\t', In, Out) :- !,
        readfile1(In, Out).
readfile2('\n', In, Out) :- !,
        readfile1(In, Out).
readfile2(C, In, Out):- !,
        readfile1([ C |In], Out).

reverse([], L, L).
reverse([F | R], L1, L) :- 
        reverse(R, [F | L1], L).
aux_make_atom([],Token,Token). 
aux_make_atom([X|Xs], Partial,Token) :- atom_concat(X,Partial,New_Partial), % concatenate the atoms "X" and 
                                                                            % "Partial" to form the new atom "New_Partial" 
                                        aux_make_atom(Xs,New_Partial,Token).
make_atom( [X|Xs], Token ) :- aux_make_atom(Xs,X,Token).
%get_number( [], N, N).
%get_number( [C|Xs], N, Token):-integer(C), N1 is N * 10 + C, get_number(Xs,N1,Token).
get_token( [] , Ts, Token) :- make_atom(Ts,Token). 
%get_token( [C|Xs] , _ , Token) :- integer(C), get_number( Xs, C, Token). 
get_token( [X|Xs] , Ts, Token) :- not(integer(X)), get_token( Xs, [X|Ts], Token).
ident( L1, [T | L2]):- ident1( L1, [], L3, L4), reverse(L3, [], L5), get_token( L5, [], T), scanner( L4, L2).
ident1( [L|Ls], L2, L3, L4):- (not(t_keyword(L)), ident1( Ls, [L|L2], L3, L4)); (L2 = L3, L4 = [L|Ls]).

scanner([], []).

% java special words
scanner([p, a, c, k, a, g, e | L1], [ package | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([i, m, p, o, r, t | L1], [ import | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([s, t, a, t, i, c | L1], [ static | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([p, u, b, l, i, c | L1], [ public | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([p, r, i, v, a, t, e | L1], [ private | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([c, l, a, s, s | L1], [ class | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).
scanner([o, v, e, r, r, i, d, e | L1], [ override | L2 ]) :- !,
        (scanner(L1, L2);ident(L1,L2)).

% reading space and syntactical symbols

scanner([' '|L1],L2):- !, (scanner(L1,L2);ident(L1,L2)).
scanner(['('|L1],['('|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([')'|L1],[')'|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner(['{'|L1],['{'|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner(['}'|L1],['}'|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner(['['|L1],['['|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([']'|L1],[']'|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([;|L1],[;|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([.|L1],[.|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([@|L1],[@|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner(['"'|L1],['"'|L2]):- !, (scanner(L1,L2);ident(L1,L2)).
scanner([,|L1],[,|L2]):- !, (scanner(L1,L2);ident(L1,L2)).

% operators: assignment, arithmetic, unary, equality and relational conditional, 
% try, compariosn, bitwise and bit shift

scanner([>, >, > | L1], [ >>> | L2 ]) :- !,
        (scanner(L1,L2);ident(L1, L2)).
scanner([>, > | L1], [ >> | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([<, < | L1], [ << | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([+, + | L1], [ ++ | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([-, - | L1], [ -- | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([=, = | L1], [ == | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([>, = | L1], [ >= | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([<, = | L1], [ <= | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([!, = | L1], [ '!=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([&, & | L1], [ && | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner(['|', '|' | L1], [ '||' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([+, = | L1], [ '+=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([-, = | L1], [ '-=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([*, = | L1], [ '*=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([/, = | L1], [ '/=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner(['%', = | L1], [ '%=' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([?| L1], [ ? | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([: | L1], [ : | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([+ | L1], [ + | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([- | L1], [ - | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([* | L1], [ * | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([/ | L1], [ / | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner(['%' | L1], [ '%' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([! | L1], [ ! | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([> | L1], [ > | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([< | L1], [ < | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([~ | L1], [ ~ | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([& | L1], [ & | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([^ | L1], [ ^ | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner(['|' | L1], [ '|' | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).
scanner([=| L1], [ = | L2 ]) :- !,
        (scanner(L1,L2);ident(L1,L2)).

% reading digits and integers
 
scanner([C | L1], L2) :-
        member(C, ['0','1','2','3','4','5','6','7','8','9']), !,
        atom_number(C, N),
        scanner_number(L1, N, L2).

scanner_number([C | L1], N, L2) :-
        member(C, ['0','1','2','3','4','5','6','7','8','9']), !,
        atom_number(C, D),
        N1 is N * 10 + D,
        scanner_number(L1, N1, L2).
scanner_number(L1, N, [N | L2]) :-
        scanner(L1, L2).

t_keyword(;).
t_keyword(+).
t_keyword(-).
t_keyword(*).
t_keyword(/).
t_keyword('%').
t_keyword(.).
t_keyword(;).
t_keyword(' ').
t_keyword(<).
t_keyword(>).
t_keyword(=).
t_keyword('(').
t_keyword(')').
t_keyword(!).
t_keyword(&).
t_keyword('|').
t_keyword(?).
t_keyword(:).
t_keyword(^).
t_keyword('[').
t_keyword(']').
t_keyword('}').
t_keyword('{').
t_keyword(,).
t_keyword('"').
t_keyword(@).
t_keyword(~).
