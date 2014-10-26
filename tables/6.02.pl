% vim: set fenc=utf8 syntax=prolog :
:-	module('6.02', []).
:-	encoding(utf8).

t( R, BD ):-
	R = result('объемный вес'(V_γ_н_з, 'тс/м^3')),
	(
		(
			BD = baseline_data([
				'учет взвешивающего действия воды'(УВВВ),
				'способ уплотнения грунта обратной засыпки'(СУГОЗ)		
			]),
			УВВВ = 'грунт в состоянии природной влажности',
			(
				СУГОЗ = 'ручное уплотнение',		V_γ_н_з = 1.55;
				СУГОЗ = 'механческое уплотнение',	V_γ_н_з = 1.7
			)
		);
		(
			BD = baseline_data([
				'учет взвешивающего действия воды'(УВВВ),
				'способ уплотнения грунта обратной засыпки'(СУГОЗ),
				'грунт'(['наименование'(GN)])
			]),
			УВВВ = 'с учетом взвешивающего действия воды',
			(
				(
					СУГОЗ = 'ручное уплотнение',
					(
						GN = 'глинистый',	V_γ_н_з = 1.0;
						GN = 'песчаный',	V_γ_н_з = 0.8
					)
				);
				(
					СУГОЗ = 'механческое уплотнение',
					(
						GN = 'глинистый',	V_γ_н_з = 1.1;
						GN = 'песчаный',	V_γ_н_з = 0.9
					)
				)
			)
		)
	).
