%  sort4.erl
-module(sort4).
-compile([export_all]).

get_mstimestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).

%funkcja łącząca dwie posortowane listy
%przekopiowana z przedostatnich lab z erlanga
merge(L, []) -> L;
merge([], L) -> L;
merge([X|Y], [Z|T])when X < Z -> [X|merge(Y, [Z|T])];
merge([X|Y], [Z|T]) -> [Z|merge([X|Y], T)].

%dzieli listę na dwie listy składające się z elementów
%listy wejściowej, ale ze względu na brak takiej konieczności
%kolejność elementów nie jest zachowana
split([X]) -> {[X],[]};
split([X,Y]) -> {[X], [Y]};
split([X,Y|Z]) -> {A, B} = split(Z),
				{[X|A], [Y|B]}.

%sekwencyjne sortowanie przez scalanie
sorts([X]) -> [X];
sorts(L) -> {X, Y} = split(L),
			merge(sorts(X), sorts(Y)).

%sortowanie współbieżne
%drugi parametr jest Pidem procesu, do którego wysłana ma być
%posortowana lista. 
sortw([X], Parent) -> Parent!{self(),[X]};
sortw(L, Parent) -> {X, Y} = split(L),
				%stworzenie dwóch procesów do sortowania połów listy
				Left = spawn(?MODULE, sortw, [X, self()]),
				Right = spawn(?MODULE, sortw, [Y, self()]),
				%odbiór i przypisanie wyniku sortowania lewej połowy
				SL=receive
					{Left, SortedLeft}-> SortedLeft
				end,
				%odbiór i przypisanie wyniku sortowania prawej połowy
				SR=receive
					{Right, SortedRight} -> SortedRight
				end,
				Parent!{self(), merge(SL, SR)}. 

%opakowanie funkcji sortw/2 tak, aby nie trzeba było podawać Pid			
sortw(L) -> Pid = spawn(?MODULE, sortw, [L, self()]),
		receive
			{Pid, Sorted} -> Sorted
		end.

gensort() ->
 L=[rand:uniform(30000)+100 || _ <- lists:seq(1, 25339)],	
 Lw=L,
 io:format("Liczba elementów = ~p ~n",[length(L)]),
 io:format("Sortuje sekwencyjnie~n"),	
 TS1=get_mstimestamp(),
 Sorted = sorts(L),
 DS=get_mstimestamp()-TS1,	
 %io:fwrite("~w~n", [Sorted]),
 %można sprawdzić, czy faktycznie sortuje
 io:format("Czas sortowania ~p [ms]~n",[DS]),
 io:format("Sortuje wspolbieznie~n"),	
 TS2=get_mstimestamp(),
 SortedW = sortw(Lw),
 DS2=get_mstimestamp()-TS2,
 %io:fwrite("~w~n", [SortedW]),
 io:format("Czas sortowania ~p [ms]~n",[DS2]).