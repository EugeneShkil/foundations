% vim: set fenc=utf8 syntax=logtalk :
:-	module(print_result, []).
:-	encoding(utf8).

:- dynamic time_dir_name/1.
set_time_dir_name:-
	get_time(TimeStamp),
	stamp_date_time(TimeStamp, DateTime, 'UTC'),
	date_time_value(date, DateTime, date(Y, M, D)),
	date_time_value(time, DateTime, time(H, Mn, S)),
	atomic_list_concat([Y, M, D], '-', DDate),
	atomic_list_concat([H, Mn, S], '_', DTime),
	atomic_list_concat([DDate, DTime], '___', TDN),
	( retract(time_dir_name(_)); true ),
	asserta(time_dir_name(TDN)).

spaces(0, '').
spaces(Count, S):-
	Count > 0,
	Count_next is Count - 1,
	spaces(Count_next, S_next),
	atomic_list_concat([' ', S_next], S).


print_persistent_width(Width, Atom):-
	compound(Atom), write(Atom);
	nonvar(Atom),
	atom_chars(Atom, Chars_list),
	proper_length(Chars_list, Length),
	Count is Width - Length,
	spaces(Count, Spaces),
	atomic_list_concat([Atom, Spaces], Msg),
	write(Msg);
	write(Atom).

w(X):- write(X).
wd:- write(' | ').
wl:-
writeln('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------').

print_parameter_to_file(Prefix, Name, Value, Unit):-
	%wl, print_persistent_width(55, Prefix), wd, print_persistent_width(95, Name), wd, print_persistent_width(32, Value), wd, print_persistent_width(6, Unit), wd, nl,
	wl, w(Prefix), wd, w(Name), wd, w(Value), w(' '), w(Unit), nl.

print_current_parameters_to_file:-
	forall(
		good_object:good_object(Prefix, Name, Value, Unit),
		(
			(
				print_parameter_to_file(Prefix, Name, Value, Unit)
			); true
		)
	), wl, !; writeln('print_current_parameters_to_file !fail!').



mkdir(Dir):- exists_directory(Dir); make_directory(Dir).
save_current:-
	(
		
	time_dir_name(TDN),
	good_object:get_current(Mark, Mode, Foundation),
	working_directory(Dir, Dir),
	atomic_list_concat([Dir, '_RESULT', TDN], '/', SD1), mkdir(SD1),
	atomic_list_concat([SD1, Mark], '/', SD2), mkdir(SD2),
	atomic_list_concat([SD2, Mode], '/', SD3), mkdir(SD3),
	
	atomic_list_concat([SD3, '/', Foundation, '.txt'], FO),
	current_output(CO),
	append(FO),
	set_stream(current_output, encoding(utf8)),
	print_current_parameters_to_file,
	set_output(CO),
	true
	); true.
	

