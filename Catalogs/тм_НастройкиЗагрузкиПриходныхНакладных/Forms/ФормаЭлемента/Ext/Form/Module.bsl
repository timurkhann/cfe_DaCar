
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Типы = Новый Массив;
	Типы.Добавить("Артикул");
	Типы.Добавить("Наименование");	
	Типы.Добавить("Производитель");
	Типы.Добавить("Количество");	
	Типы.Добавить("Цена");
	Типы.Добавить("Сумма");

	Элементы.ПорядокКолонокExcel.ПодчиненныеЭлементы.ПорядокКолонокExcelИмяКолонки.СписокВыбора.ЗагрузитьЗначения(Типы);

КонецПроцедуры

&НаКлиенте
Процедура НомерСтрокиНачалаЗагрузкиПриИзменении(Элемент)
	
	Если Объект.НомерСтрокиНачалаЗагрузки = 0 Тогда
		Объект.НомерСтрокиНачалаЗагрузки = 1;	
	КонецЕсли; 
	
КонецПроцедуры
