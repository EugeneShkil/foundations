% vim: set fenc=utf8 syntax=logtalk :
:-	module(functions, []).
:-	encoding(utf8).


grad2rad(Grad, Rad):- Rad is Grad * pi/180.0.

'кПа -> кгс/см^2'(KPa, Kgs_sm2):- Kgs_sm2 is KPa/100.0.
'кгс/см^2 -> тс/м^2'(Kgs_sm2, Ts_m2):- Ts_m2 is 10.0 * Kgs_sm2.


li(X1, X2, Xx, Y1, Y2, Yz):- Yz is Y1 + (((Xx - X1)*(Y2 - Y1))/(X2 - X1)).

liс(X1, X2, Xx, Y1, Y2, Yz):- Xx >= X1, Xx < X2, li(X1, X2, Xx, Y1, Y2, Yz).


'линейная_интерполяция'(X1, X2, Xx, Y1, Y2, Yz):- li(X1, X2, Xx, Y1, Y2, Yz).
wwnnl(Description, Value):- write(Description), write(' = |'), write(Value), write('|'), flush_output.
ww(Description, Value):- wwnnl(Description, Value), nl, flush_output.

l(Type, Level, Message):-
	(
		description:log_level(LL), LL >= Level,
		(
			Type = i, Type_part_message = 'INFO';
			Type = w, Type_part_message = 'WARNING';
			Type = e, Type_part_message = 'ERROR'
		),	
		write(Type_part_message), write('('), write(Level), write('): '), writeln(Message), flush_output
	); true.
	
pv(Level, Description, Value, Unit):- atomic_list_concat([Description, ' :  [ ', Value, ' ], ', Unit, ';'], Message), l(i, Level, Message),
%l(i, Level, '------------------------------------------------------------------------------------'),
	true.

pl(Level, List):- atomic_list_concat(List, ' ', Message), l(i, Level, Message).

write_list(List):-	List = [];	List = [H|T], writeln(H), write_list(T).

clean_vars_from_list([], []).
clean_vars_from_list(INPUT_LIST, OUTPUT_LIST):-
	!,
	(
		(
			INPUT_LIST = [HI|TI],
	       		OUTPUT_LIST = [HO|TO],
			nonvar(HI), HO = HI,
			clean_vars_from_list(TI, TO)
		);
		(
			INPUT_LIST = [_|TI],
			clean_vars_from_list(TI, OUTPUT_LIST)
		)
	).



