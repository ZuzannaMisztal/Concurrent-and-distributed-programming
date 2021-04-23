-module(zad1).
-compile([export_all]).

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

%mergesort
sort([X]) -> [X];
sort(L) -> {X, Y} = split(L),
			merge(sort(X), sort(Y)).
			
%tworzy listę o długości L z wartościami losowymi od 0 do 99
lista(L) -> [rand:uniform(100)-1 || _ <- lists:seq(1, L)].			
			
%proces generuje losową listę o zadanej długości i przesyła
%do sortera. Następnie uruchamia się ze zmniejszonym parametrem N,
%który oznacza pozostałą ilość generacji do wykonania.
%Gdy N=0 wysyłana jest wiadomość kończąca.	
generator(Sorter_pid, 0, _) -> Sorter_pid!koniec;			
generator(Sorter_pid, N, L) -> Lista = lista(L),
							Sorter_pid!Lista,
							generator(Sorter_pid, N-1, L).
							
%po odebraniu atomu :koniec: przesyła dalej informację o końcu do 
%printera. W przypadku otrzymania innego termu zakłada że to lista,
%sortuje ją, przesyła do printera i wywołuje się rekurencyjne,
%tak aby dalej istniał sorter nasłuchujący nowych list do posortowania
sorter(Printer_pid) ->
	receive
		koniec ->
			Printer_pid!koniec;
		Lista ->
			Printer_pid!sort(Lista),
			sorter(Printer_pid)	
	end.
	
%proces wypisujący listę po jej odebraniu
printer() ->
	receive
		koniec -> ok;
		Lista -> 
			io:fwrite("~w~n", [Lista]),
			printer()
	end.	

%tworzy odpowiednie procesy
%N to ilość list do wygenerowania, L to długość list		
main(N, L) ->
	P3 = spawn(?MODULE, printer, []),
	P2 = spawn(?MODULE, sorter, [P3]),
	spawn(?MODULE, generator, [P2, N, L]).