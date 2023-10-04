verify(Filename):-

    see(Filename),
    read(Prems),
    read(Goal),
    read(Proof),
    seen,

    valid_goal(Goal, Proof),
    valid_proof_loop(Prems, Proof,Goal, Proof),

    !.

valid_goal(Goal, Proof):-
    last_list(Proof, Goal).

last_list([Head | []],Goal):-
    member(Goal , Head); !, fail.

last_list([_ | Tail],Goal):-
    last_list(Tail,Goal).

%Valid proof caller base campus train station bench
valid_proof_loop([Prems],[ProofHead|ProofTail],Goal,Proof):-
    valid_proof(ProofHead, Prems,Proof, Goal ),
    valid_proof_loop(Prems, ProofTail,Goal, Proof).

%premise function
valid_proof([_,Statement, premise], [Prems], _ , _):-
    member(Statement,Prems).

%assumption function
valid_proof([[_,_,assumption]|BoxTail],[Prems],[Proof], Goal):-
    assumption_loop(BoxTail, Prems, Goal, Proof).

%copy function
valid_proof([_,Statement, copy(X)], _ , [Proof],_):-
    nth0(X,Proof,RightRow),
    nth0(1,RightRow,Statement).

%andint function
valid_proof([_,and(A,B), andint(X,Y)],_,[Proof],_):-
    nth0(X, Proof, FirstRow),
    nth0(Y, Proof, SecondRow),
    member(A,FirstRow),
    member(B,SecondRow).

%andel1 function
valid_proof([_,Statement,andel1(X)],_,[Proof],_):-
    nth0(X, Proof, ThisRow),
    member(and(Statement , _),ThisRow).

%andel2 function
valid_proof([_,Statement,andel2(X)],_,[Proof],_):-
    nth0(X, Proof, ThisRow),
    member(and( _, Statement),ThisRow).

%används inte
orint1(x).
%används inte
orint2(x).

%orel function
valid_proof([_,_,orel(X,Y,U,V,W)], _, [Proof],_):-
    nth0(X, Proof, FirstRow),
    nth0(Y, Proof, SecondRow),
    nth0(U, Proof, ThirdRow),
    nth0(V, Proof, ForthRow),
    nth0(W, Proof, FifthRow),

    member(or(A,B),FirstRow),

    member(A , SecondRow),
    member(cont, ThirdRow),
    member(B , ForthRow),
    member(cont, FifthRow).

%impint function
valid_proof([_,Statement,impel(X,Y)],_,[Proof],_):-
    nth0(X,Proof,FirstRow),
    nth0(Y,Proof,SecondRow),

    member(imp(A,B),SecondRow),
    member(A,FirstRow),
    B == Statement.

%negint function
valid_proof([_,Statement,negint(X,Y)],_,[Proof],_):-

    nth0(X,Proof,FirstRow),
    nth0(Y,Proof,SecondRow),

    member(A,FirstRow),
    member(cont,SecondRow),
    Statement == neg(A).negel(x, y).

%contel function
valid_proof([_,Statement,contel(X)],_,[Proof],Goal):-
    nth0(X,Proof,FirstRow),
    member(cont,FirstRow),
    Statement == Goal.

%negnegint function
valid_proof([_,Statement,negnegint(X)],_,[Proof],Goal):-
    nth0(X,Proof,FirstRow),
    nth0(1,FirstRow,Var),
    Statement == neg(neg(Var)),
    Statement == Goal. %denna rad kanske onödig

%negnegel function
valid_proof([_,Statement,negnegel(X)],_,[Proof],_):-
    nth0(X,Proof,FirstRow),
    nth0(1,FirstRow,Val),
    Val == neg(neg(Statement)).

%mt function
valid_proof([_,Statement,mt(X,Y)],_,[Proof],_):-
    nth0(X,Proof,FirstRow),
    nth0(Y,Proof,SecondRow),
    member(imp(A,B),FirstRow),
    member(neg(B),SecondRow),
    Statement == neg(A).

%pbc function
valid_proof([_,Statement,pbc(X,Y)],_,[Proof],_):-
    nth0(X,Proof,FirstRow),
    nth0(Y,Proof,SecondRow),
    member(neg(Statement),FirstRow),
    member(cont,SecondRow).

%lem function
valid_proof([_,_,lem],_,_,_):-
    true.

assumption_loop([ProofHead|ProofTail],[Prems],Goal,[Proof]):-
    valid_proof(ProofHead,Prems,Proof,Goal),
    assumption_loop(ProofTail,Prems,Goal,Proof).
