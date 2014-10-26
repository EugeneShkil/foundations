% vim: set fenc=utf8 syntax=logtalk :
:-	module(framework, [ca/2]).
:-	encoding(utf8).

w(X):- write(X).

print_term(PREFIX, TERM):-
	( TERM =.. [F, L], is_list(L), w(PREFIX), w(F), atomic_list_concat(['\t', PREFIX], PREFIX2), print_terms_list(PREFIX2, L) );
	( TERM =.. [F, V, U], w(PREFIX), w(F), write('  : '), write(V), write('\t[ '), write(U), writeln(' ]') );
	( TERM =.. [F, V], write(PREFIX), write(F), write('  : '), writeln(V) ).

print_terms_list(PREFIX, TL):-
	TL = [];
	TL = [H|T],
       	print_term(PREFIX, H),
	print_terms_list(PREFIX, T).

%-------------------------------------------------------------------------------------------------------------------------------------------------------------
baseline_data(Term, BD):-
	Term =.. [_Two_points, _Prefix, True_term],
	True_term =.. [_F, _R, BD].
print_baseline_data(Term):-
	writeln('  исходные данные:'),
	baseline_data(Term, BD),
	BD = baseline_data(V), (
		is_list(V), print_terms_list('\t', V);
		print_term('\t', V)
	);
	w('INFO(framework:print_baseline_data): '), w('in baseline_data('),w(V), w(') -> '), w(V), w(' is not list or value'), nl.

%-------------------------------------------------------------------------------------------------------------------------------------------------------------
res(Term, R):-
	Term =.. [_Two_points, _Prefix, True_term],
	True_term =.. [_F, RR, _BD],
	RR = result(R).

res(Term, Functor, Value, Unit):-
	res(Term, R),
	R =.. [Functor, Value, Unit];
	w('INFO(framework:res/4): '), w(Term), nl.

print_result(Term):-
	res(Term, R),
	print_term('  результат::  ', R),
	writeln('-----------------------------------------------------------------------------------------------------------------').
%-------------------------------------------------------------------------------------------------------------------------------------------------------------
functor_name(Term, Functor_name):-
	Term =.. [Two_points, Prefix, True_term],
	True_term =.. [F, _R, _BD],
	atomic_list_concat([Prefix, Two_points, F], Functor_name).
print_functor_name(Term):-	functor_name(Term, Functor_name), writeln(Functor_name).
%-------------------------------------------------------------------------------------------------------------------------------------------------------------

cl(Term):-
	call(Term);
	functor_name(Term, Functor_name),
	throw(error(formal, context(Functor_name/2, 'для данных исходных данных вызов завершился неудачей'))).
	
c(Term):-
	cl(Term),
	description:log(Log_list),
	
	(
		(
			(
				member(baseline_data, Log_list);
				member(result, Log_list)
			),
			print_functor_name(Term)
		);
		true
	),

	(
		member(baseline_data, Log_list), print_baseline_data(Term);
		true
	),

	(		
		member(result, Log_list), print_result(Term);
		true
	),
	true.

ca(Term, Prefix):-
	c(Term), !,
	res(Term, Functor, Value, Unit),
	Name = Functor,
	good_object:add(Prefix, Name, Value, Unit), !,
	true.

