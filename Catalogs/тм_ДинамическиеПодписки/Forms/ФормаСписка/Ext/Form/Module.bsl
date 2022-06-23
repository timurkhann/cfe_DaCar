﻿
&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для каждого Строка Из Строки Цикл
		Если Строка.Ключ.Ссылка.ЭтоГруппа Тогда
			Продолжить;	
		КонецЕсли;      
		Для каждого СтрокиПодписок Из Строка.Ключ.ИсточникиПодписки Цикл                                       
			мИсточникПодписки = СтрЗаменить(СтрокиПодписок.ИсточникПодписки, "Документ.", "");
			мИсточникПодписки = СтрЗаменить(мИсточникПодписки, "Справочник.", "");
			Строка.Значение.Данные.ИсточникПодписки = ?(ПустаяСтрока(Строка.Значение.Данные.ИсточникПодписки), мИсточникПодписки, Строка.Значение.Данные.ИсточникПодписки + "; " + мИсточникПодписки); 
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры
