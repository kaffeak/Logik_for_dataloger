partstring(List,L,F):-
     append([_,F,_], List), length(F,L), F\=[].

