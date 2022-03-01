remove_duplicates([],_).

remove_duplicates([H|T],E):-
    memberchk(H,E),
    remove_duplicates(T,E).

remove_duplicates([H|T],E):-
    appendEl(H,E,R),
    remove_duplicates(T, R).


