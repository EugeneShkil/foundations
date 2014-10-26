% vim: set fenc=utf8 syntax=prolog :
:-	module('6.01', []).
:-	encoding(utf8).


t(R, BD):-
	R = result('коэффициент безопасности по грунту'(К_г, 'д.е.')),
	(
		(
			BD = baseline_data([
				'тип расчета'('расчет по деформациям'),
				'источник нормативных характеристик грунта'('таблицы 1,2 приложения 1')
			]), К_г = 1.0
		);
		(
			BD = baseline_data([
				'тип расчета'('расчет по деформациям'),
				'источник нормативных характеристик грунта'('иные статистически обоснованные таблицы'),
				'коэффициент безопасности установленный на основании результатов обработки данных, используемых для составления этих таблиц'(К_г_уст)
			]), К_г = К_г_уст
		);
		(
			BD = baseline_data([
				'тип расчета'('расчет по несущей способности'),
				'наименование характеристики грунта'(NHG),
				GP
			]),
			(
				GP = 'грунт'(['наименование'('песчаный')]),
				(
					NHG = 'γ (объемный вес)',		К_г = 1.0;
					NHG = 'φ (угол внутреннего трения)',	К_г = 1.1;
					NHG = 'C (удельное сцепление)',		К_г = 4.0
				);
				GP = 'грунт'(['наименование'('глинистый'), 'вид'(V), 'J_L (консистенция)'(J_L, 'д.е.')]),
				(
					( V = 'супесь', J_L =< 0.25; ( V = 'суглинок'; V = 'глина' ), J_L =< 0.5 ),
					(
						NHG = 'γ (объемный вес)',		К_г = 1.0;
						NHG = 'φ (угол внутреннего трения)',	К_г = 1.1;
						NHG = 'C (удельное сцепление)',		К_г = 2.4
					);
					( V = 'супесь', J_L > 0.25; ( V = 'суглинок'; V = 'глина' ), J_L > 0.5 ),
					(
						NHG = 'γ (объемный вес)',		К_г = 1.0;
						NHG = 'φ (угол внутреннего трения)',	К_г = 1.1;
						NHG = 'C (удельное сцепление)',		К_г = 3.3
					)
				)
			)
		)
	).
