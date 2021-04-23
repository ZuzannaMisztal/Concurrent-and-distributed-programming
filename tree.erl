-module(tree).
-compile([export_all]).
-import(random, [uniform/1]).

init() ->
	{node, 'nil'}.
	
insert(Key, Val, {node, 'nil'}) ->
	Left = init(),
	Right = init(),
	{node, {Key, Val, Left, Right}};
	
insert(Key, Val, {node, {NodeKey, NodeVal, Left, Right}}) ->
	if Key < NodeKey -> {node, {NodeKey, NodeVal, insert(Key, Val, Left), Right}};
		Key > NodeKey -> {node, {NodeKey, NodeVal, Left, insert(Key, Val, Right)}};
		Key == NodeKey -> {node, Key, Val, Left, Right}
	end.
	
generate_random(0) -> init();
generate_random(N) -> insert(uniform(20), uniform(100), generate_random(N-1)).

find0(Key, Tree) ->
	try find(Key, Tree) of
		false -> false
	catch
		Val -> Val
	end.

find(_, {node, 'nil'}) -> false;
find(Key, {node, {Key, Value, _, _}}) -> throw(Value);
find(Key, {node, {NodeKey, _, Left, _}}) when Key < NodeKey -> find(Key, Left);
find(Key, {node, {_, _, _, Right}}) -> find(Key, Right).

to_list({node, 'nil'}) -> [];
to_list({node, {Key, Value, Left, Right}}) -> to_list(Left) ++ [{Key, Value}] ++ to_list(Right).

from_list([]) -> init();
from_list([{Key, Val}|T]) -> insert(Key, Val, from_list(T)).