:- module(
		calculate, []
	).
% vim: set fenc=utf8 syntax=logtalk :
:-	encoding(utf8).

%:-	set_stream(current_output, encoding(utf8)).
%:-	set_stream(user_error, encoding(utf8)).

:-
	working_directory(WD, WD),
							asserta(user:file_search_path(working_directory, WD)),
	prolog_load_context(directory, BASE),
							asserta(user:file_search_path(base, BASE)),
	atom_concat(WD, '/calculations', Calculations),	asserta(user:file_search_path(calculations, Calculations)),
	atom_concat(WD, '/data', Data),			asserta(user:file_search_path(data, Data)),
	atom_concat(WD, '/formula', Formula),		asserta(user:file_search_path(formula, Formula)),
	atom_concat(WD, '/tables', Tables),		asserta(user:file_search_path(tables, Tables));
	throw(error(representation_error(not_add_file_search_patch), context(calculate:add_file_search_paths/0, 'ERROR_MESSAGE: not work'))).

:-
	use_module(working_directory(baseline_data)),

	use_module(base(functions)),
	use_module(base(good_object)),
	use_module(base(framework)),
	use_module(base(print_result)),

	use_module(data(foundations)),
	use_module(tables(table)),
	use_module(formula(formula)),
	use_module(calculations('load_capacity_with_the_pull-out')),

	use_module(base(process)),
	true.

console_splash:-
	nl, nl, nl,
	writeln('+----------------[  CALCULATE FOUNDATION  ]----------------+'),
	writeln('+----------------------------------------------------------+'),
	nl,nl.

run_term:- 
	process:process;
	throw(error(representation_error('process:process fail'), context(calculate:run_term/0, 'ERROR_MESSAGE: process:process fail'))).

%run_term:- fail.
%run_term:- true.
%run_term:-	throw(error(representation_error('test'), context(calculate:run_term/0, 'ERROR_MESSAGE: test throw error'))).

recover(E):-
	writeln('========================='),
	writeln(E),
	writeln('===== print_message ====='),
	print_message(error, E),
	writeln('===== print_message ====='),
	fail.

end:-
	writeln('_____________ END _____________'), halt(0);
	write('Press "Enter" to exit	'), flush,
	get0(_),
	writeln('_____________ END _____________'),
	statistics, halt(0).
	
calculate:-
	console_splash,
	catch(run_term, E, recover(E)), end;
	writeln('main goal "calculate" is fail'), end.
