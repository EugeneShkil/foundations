% vim: set fenc=utf8 syntax=logtalk :
:-	module(process, []).
:-	encoding(utf8).

'список обозначений опор'(Список_опор):- setof(Mark, description:'опора'(Mark, _), Список_опор).
'список расчетных режимов'(Список_расчетных_режимов):- setof(Mode, description:'расчетные режимы'(Mode), Список_расчетных_режимов).
'список фундаментов'(Список_фундаментов):- setof(Foundation, foundations:'параметр'('тип'(Foundation), _), Список_фундаментов).

add_foundation_parameters(Foundation):-
	forall(
		foundations:'параметр'('тип'(Foundation), P),
		(
			P =.. [Name, Value, Unit], Prefix = 'фундамент',
			good_object:add(Prefix, Name, Value, Unit),
			true
		)
	), !.

add_ground_parameters(Mark, Prefix):-
	Term =.. [ Prefix, 'инженерно-геологический элемент'(IGE)],
	description:'опора'(Mark, Term),

	forall(
		description:'инженерно-геологические элементы'(IGE, P),
		(
			(
				P =.. [Name, Value, Unit],
				good_object:add(Prefix, Name, Value, Unit)
			);
			(
				P =.. [Name, Value],
				good_object:add( Prefix, Name, Value, string)
			);
			(
				P =.. [Name],
				good_object:add( Prefix, Name, '-', string)
			)
		)
	).
		
add_ground_parameters(Mark):-
	add_ground_parameters(Mark, 'грунт засыпки'),
	add_ground_parameters(Mark, 'грунт основания').

add_tower_parameters(Mark):-
	forall(
		description:'опора'(Mark, Param),
		(
			( Param =.. [F, V], good_object:add('опора', F, V, string) );
			( Param =.. [F, V, U], good_object:add('опора', F, V, U) );
			true
		)
	).
	

/*''
available_foundament(T):-
	description:'тип_металлической_опоры'(ТМО),
	foundations:'допустимый фундамент для опоры'('тип'(ТМО), T).
*/


process:-
	'список обозначений опор'(Список_опор),	'список расчетных режимов'(Список_расчетных_режимов), 'список фундаментов'(Список_фундаментов), !,
	print_result:set_time_dir_name,
	forall(
		(
			member(Mark, Список_опор),
			member(Foundation, Список_фундаментов),
			member(Mode, Список_расчетных_режимов),
			
			true
		),
		(
			good_object:set_current(Mark,Mode,Foundation),
			add_foundation_parameters(Foundation),
			add_tower_parameters(Mark),
			add_ground_parameters(Mark),
			'load_capacity_with_the_pull-out':'расчет допустимой выдергивающей нагрузки по несущей способности',
			%good_object:print_current_parameters,
			print_result:save_current,			
			true
		)
	),
	%good_object:print_parameters,
	true.
