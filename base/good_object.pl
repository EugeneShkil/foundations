% vim: set fenc=utf8 syntax=logtalk :
:-	module(good_object, [
		  getp/4
		, add/4
		, set_current/3
		, get_current/3
		, print_current_parameters/0
	]).
:-	encoding(utf8).

:- dynamic good_object/7.
:- dynamic current/3.

tl:- write(' __ ').
tp:- write(' %% ').
ts:- write('  ').
w(X):- write(X).

print_current:-	current(Mark, Mode, Foundation), write('current: \t mark - '), write(Mark), write('\t mode - '), write(Mode), write('\t foundation - '), writeln(Foundation); writeln('current not set'), true.

print_parameter(Mark, Mode, Foundation, Prefix, Name, Value, Unit):-
	w(Mark), tl, w(Mode), tl, w(Foundation), w(' :'),
	ts, w(Prefix), tp, w(Name), w(' :  [ '), w(Value), w(' ], '), w(Unit), writeln(';').

print_parameter(Prefix, Name, Value, Unit):-
	current(Mark, Mode, Foundation),
	print_parameter(Mark, Mode, Foundation, Prefix, Name, Value, Unit).

good_object(Prefix, Name, Value, Unit):-
	current(Mark, Mode, Foundation),
	good_object(Mark, Mode, Foundation, Prefix, Name, Value, Unit).


print_current_parameters:-
	print_current,
	forall(
		good_object(Prefix, Name, Value, Unit),
		(
			print_parameter(Prefix, Name, Value, Unit)
		)
	), !; writeln('print_current_parameters !fail!').


add( Mark, Mode, Foundation, Prefix, Name, Value, Unit):- assertz(	good_object(Mark, Mode, Foundation, Prefix, Name, Value, Unit)	).
add(Prefix, Name, Value, Unit):-	get_current(Mark, Mode, Foundation),	add( Mark, Mode, Foundation, Prefix, Name, Value, Unit).

getp(Mark, Mode, Foundation, Prefix, Name, Value, Unit):-		good_object(Mark, Mode, Foundation, Prefix, Name, Value, Unit).
getp(Prefix, Name, Value, Unit):-
	get_current(Mark, Mode, Foundation),
	getp(Mark, Mode, Foundation, Prefix, Name, Value, Unit),
	true.

%-----------------------------------------------------------------------
set_current(Mark, Mode, Foundation):-
	( retract(current(_,_,_)); true ),
	asserta(current(Mark, Mode, Foundation)),
	true.

%-----------------------------------------------------------------------
get_current(Mark, Mode, Foundation):-
	current(Mark, Mode, Foundation).
