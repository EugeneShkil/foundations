% vim: set fenc=utf8 syntax=logtalk :
:-	module('f_6.03', []).
:-	encoding(utf8).


f(
	result('C_з (расчетное значение удельного сцепления грунта засыпки)'(C_з, U)),
	baseline_data([
		'C_I_II (расчетное значение удельного сцепления грунта)'(C_I_II, U)
	])
):-
	C_з is C_I_II * 0.5.

