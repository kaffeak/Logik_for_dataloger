find(Start, Goal) :-
  neighbour(Start, _),
  search_graph(Start, Start, Goal, []).

search_graph(void, _, _, _).

search_graph(_, Start, Goal, _) :-
  Start == Goal,
  add_to(Start, [], Result),
  write(Result).

search_graph(Element, _, Goal, Result2) :-
  Element == Goal,
  add_too(Element, Result2, Result),
  write(Result).
  

search_graph(Element, Start, Goal, []) :-
  neighbour(Element, X),
  add_to(Element, [], Result2),
  search_graph(X, Start, Goal, Result2).
  
search_graph(Element, Start, Goal, Result) :-
  neighbour(Element, X),
  \+member(X, Result),
  add_to(Element, Result, Result2),
  search_graph(X, Start, Goal, Result2).


add_to(Y, [], [Y]).

add_to(Y, [Z | L], [Z | L2]) :-
  add_to(Y, L, L2).


neighbour(a, b).
neighbour(a, i).

neighbour(b, a).
neighbour(b, c).

neighbour(c, b).
neighbour(c, d).
neighbour(c, e).
neighbour(c, h).

neighbour(d, c).

neighbour(e, c).
neighbour(e, f).

neighbour(f, e).
neighbour(f, g).
neighbour(f, i).

neighbour(g, f).
neighbour(g, h).

neighbour(h, c).
neighbour(h, g).

neighbour(i, a).
neighbour(i, f).
