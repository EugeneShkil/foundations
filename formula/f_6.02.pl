% vim: set fenc=utf8 syntax=logtalk :
:-	module('f_6.02', []).
:-	encoding(utf8).


f(
	result('φ_з (расчетное значение угла внутреннего трения грунта засыпки)'(Vφ_з, U)),
	baseline_data([
		'φ_I_II (расчетное значение угла внутреннего трения грунта)'(Vφ_I_II, U)
	])
):-
	Vφ_з is Vφ_I_II * 0.8.

