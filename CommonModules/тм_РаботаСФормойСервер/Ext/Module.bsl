
Процедура ДобавитьИнформациюДополнительныхРеквизитов(ЗаказНаряд, ДанныеПанелиКонтактнойИнформации) Экспорт

	// Удалим ранее добавленные дополнительные реквизиты 
	СтрокиУдаления = ДанныеПанелиКонтактнойИнформации.НайтиСтроки(Новый Структура("ТипОтображаемыхДанных", "ДопРеквизитыЗН"));
	Для каждого СтрокаУдаления Из СтрокиУдаления Цикл
		
		ДанныеПанелиКонтактнойИнформации.Удалить(СтрокаУдаления);	
		
	КонецЦикла;   
	
	ДополнительныеРеквизитыЗН = РегистрыСведений.тм_ДополнительныеРеквизитыЗаказНаряда.Получить(Новый Структура("ЗаказНаряд", ЗаказНаряд));
	ДополнительныйКомментарий = ДополнительныеРеквизитыЗН.ДополнительныйКомментарий;
		
	Если ПустаяСтрока(ДополнительныйКомментарий) Тогда
		
		Возврат;
		
	КонецЕсли; 
	
	ЗаписьКИ 							= ДанныеПанелиКонтактнойИнформации[0];
	НоваяСтрока 						= ДанныеПанелиКонтактнойИнформации.Добавить();
	НоваяСтрока.Отображение 			= "Дополнительный комментарий:" + Символы.ПС + ДополнительныйКомментарий;
	НоваяСтрока.ПредставлениеКИ 		= ДополнительныйКомментарий;
	НоваяСтрока.ИндексПиктограммы 		= 11;
	НоваяСтрока.ТипОтображаемыхДанных 	= "ДопРеквизитыЗН"; 
	НоваяСтрока.ВладелецКИ 				= ЗаписьКИ.ВладелецКИ;

КонецПроцедуры
 
Процедура ОтключитьВидимостьЭлементов(Форма, ИмяЭлемента) Экспорт
	
	Если ИмяЭлемента = "ФормаОбщаяКомандатм_Чат" Тогда
		Если Форма.ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаСписка" Тогда
			НаименованиеПанели = "КоманднаяПанель";
			ФормаОбщаяКомандатм_Чат = Форма.Элементы[НаименованиеПанели].ПодчиненныеЭлементы.ГруппаГлобальныеКомандыЗаказПокупателя.ПодчиненныеЭлементы.Найти(ИмяЭлемента);
		ИначеЕсли  Форма.ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаСпискаЗаказНаряда" Тогда
			НаименованиеПанели = "ГруппаКоманднаяПанель";	
			ФормаОбщаяКомандатм_Чат = Форма.Элементы[НаименованиеПанели].ПодчиненныеЭлементы.ГруппаГлобальныеКомандыЗаказПокупателя.ПодчиненныеЭлементы.Найти(ИмяЭлемента);
		ИначеЕсли Форма.ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаЗаказНаряда" Тогда
			НаименованиеПанели = "ГруппаГлобальныеКоманды";	
			ФормаОбщаяКомандатм_Чат = Форма.КоманднаяПанель.ПодчиненныеЭлементы[НаименованиеПанели].ПодчиненныеЭлементы.Найти(ИмяЭлемента);
		ИначеЕсли Форма.ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаДокумента" Тогда
			НаименованиеПанели = "КомандыГлобальные";	
			ФормаОбщаяКомандатм_Чат = Форма.Элементы.ПодчиненныеЭлементы[НаименованиеПанели].ПодчиненныеЭлементы.Найти(ИмяЭлемента);			
		КонецЕсли; 
		
		Если ФормаОбщаяКомандатм_Чат <> Неопределено Тогда
			ФормаОбщаяКомандатм_Чат.Видимость	= Ложь;	
		КонецЕсли; 	
			
	КонецЕсли; 
	
КонецПроцедуры

