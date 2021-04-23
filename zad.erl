%ZUZANNA MISZTAL

-module(zad).
-compile([export_all]).
-import(math, [sqrt/1]).

p(A,B,C) -> (A + B + C) / 2.

pole({prostokat,X,Y}) ->  X*Y;
pole({kolo,X}) -> 3.14*X*X;
pole({trojkat,A,B,C}) -> sqrt(p(A,B,C) * (p(A,B,C) - A) * (p(A,B,C) - B) * (p(A,B,C) - C)).


amin([X]) -> X;
amin([X|Y]) -> min(X, amin(Y)).

amax([X]) -> X;
amax([X|Y]) -> max(X, amax(Y)).

tmin_max(L) -> {amin(L), amax(L)}.

my_list(1) -> [1]; %warunek stopu
my_list(N) -> my_list(N-1) ++ [N]. %rekurencyjne dodawanie elementow

reverse([]) -> []; % funkcja pomocnicza do dzielenia listy na pol. Prosta rekurencja
reverse([X|Y]) -> reverse(Y) ++ [X]. 

len([]) -> 0;	%jak powyzej
len([_|Y]) -> 1 + len(Y).

cut_elems(_, 0) -> []; %rowniez funkcja pomocnicza.
cut_elems([X|_], 1) -> [X]; %Zwraca podlistę listy wejsciowej, o zadanej ilosci elementow
cut_elems([X|Y], N) -> [X] ++ cut_elems(Y, N-1).

%wybiera polowe (zaokraglajac w gore) elementow z lewej strony
%nastepnie polowe (ucinajac) elementow z prawej strony (obraca cala liste aby funkcja cut_elems mogla wybrac pierwsze wartosci, a nastepnie obraca wynik)
halves(L) -> [cut_elems(L, round(len(L)/2)), reverse(cut_elems(reverse(L), len(L) div 2))].

change(_,_,[]) -> [];
change(X,Y,[X|O]) ->[Y|change(X,Y,O)]; %jesli trzeba zamien pierwszy element listy, nastepnie wykonaj rekurencyjnie dla ogona
change(X,Y,[A|O]) ->[A|change(X,Y,O)].

merge(L, []) -> L;
merge([], L) -> L;
merge([X|Y], [Z|T])when X < Z -> [X|merge(Y, [Z|T])]; 
merge([X|Y], [Z|T]) -> [Z|merge([X|Y], T)]. % wybierz mniejszy element z glow dwoch list, dodaj do niego rekurencyjnie zmergowane pozostalosci list

insert(X, []) -> [X];
insert(X, [A|B]) when X =< A -> [X|[A|B]]; %obsluguje przypadek, gdy element nalezy dodac na poczatek listy
insert(X, [A|B]) -> [A] ++ insert(X, B). %w przeciwnym przypadku wykorzystaj rekurencje

diversify([], []) -> [];
diversify([X], [_]) -> [X];
diversify([A,_], [_,D]) -> [A,D]; %trzy warunki stopu
diversify([A,_|C], [_,E|F]) -> [A, E] ++ diversify(C, F). %wybranie pierwszych dwoch elementow, nastepnie laczone z rekurencjynym wywolaniem samej siebie