% vim: set fenc=utf8 syntax=logtalk :
:-	module('f_6.44', []).
:-	encoding(utf8).

f(
	result('C_о (расчетное значение удельного сцепления грунта засыпки)'(C_о, U)),
	baseline_data([
		'C_I (расчетное значение удельного сцепления грунта)'(C_I, U),
		'η (коэффициент согласно таблицы №6.11)'(Кη, 'д.е.')
	])
):-
	C_о is C_I * Кη.

