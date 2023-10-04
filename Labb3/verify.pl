verify(Filename):-
    see(Filename),
    read(T),    %transition relations
    read(L),    %sanningstilldelning
    read(S),    %tillståndsmängd, current state
    read(F),    %formel som ska testa
    seen,

    validate(T, L, S, [], F).

%checks if current state is "goal state"
validate(_, L, S, [], Statement):-
    member([S, Rel], L),
    member(Statement, Rel).

%neg
validate(_, L, S, [], neg(Statement)):-
    member([S, Rel], L),
    \+member(Statement, Rel).

%and
validate(T, L, S, [], and(State, Ment)):-
    validate(T, L, S, [], State),
    validate(T, L, S, [], Ment).

%or1
validate(T, L, S, [], or(State, _)):-
     validate(T, L, S, [], State).

%or2
validate(T, L, S, [], or(_, Ment)):-
    validate(T, L, S, [], Ment).

%AX, allkvantifiering, i nästa tillstånd
validate(T, L, S, [], ax(Statement)):-
    next_states(T, L, S, [], Statement).

%AG1, alltid
validate(_, _, S, U, ag(_)):-
    member(S, U).

%AG2
validate(T, L, S, U, ag(Statement)):-
    \+member(S, U),
    validate(T, L, S, [], Statement),
    next_states(T, L, S, [S|U], ag(Statement)).

%AF1, så småning om
validate(T, L, S, U, af(Statement)):-
    \+member(S, U),
    validate(T, L, S, [], Statement).

%AF2
validate(T, L, S, U, af(Statement)):-
    \+member(S, U),
    next_states(T, L, S, [S|U], af(Statement)).

%EX, existenskvantifiering, i något nästa tillstånd
validate(T, L, S, [], ex(Statement)):-
    some_next_state(T, L, S, [], Statement).

%EG1, det finns en väg där alltid
validate(_, _, S, U, eg(_)):-
    member(S, U).

%EG2
validate(T, L, S, U, eg(Statement)):-
    \+member(S, U),
    validate(T, L , S, [], Statement),
    some_next_state(T, L, S, [S|U], eg(Statement)).


%EF1, det finns en väg där så småningom
validate(T, L, S, U, ef(Statement)):-
    \+member(S, U),
    validate(T, L, S, [], Statement).

%EF2
validate(T, L, S, U, ef(Statement)):-
    \+member(S, U),
    some_next_state(T, L, S, [S|U], ef(Statement)).

%hjälpfunktioner---------------

%find all states
next_states(T, L, S, U, Statement):-
    member([S, List], T),
    next_value(T, L, U, List, Statement).

%find all linked values
next_value(_, _, _, [], _).

next_value(T, L, U, [ListHead|ListTail], Statement):-
    validate(T, L, ListHead, U, Statement),
    next_value(T, L, U, ListTail, Statement).

%find some state
some_next_state(T, L, S, U, Statement):-
    member([S, List], T),
    some_next_value(T, L, U, List, Statement).

%find some linked value
some_next_value(T, L, U, [ListHead|ListTail], Statement):-
    validate(T, L, ListHead, U, Statement);
    some_next_value(T, L, U, ListTail, Statement), !.
