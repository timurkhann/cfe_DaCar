
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	тм_СообщенияПользователям.ПользовательОтКого = Пользователи.ТекущийПользователь();
	тм_СообщенияПользователям.ИдентификаторСообщения = XMLСтрока(Новый УникальныйИдентификатор);
	
	СоздатьГруппу = Неопределено;
	Параметры.Свойство("СоздатьГруппу", СоздатьГруппу);
	Если СоздатьГруппу <> Неопределено И СоздатьГруппу = Истина Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.Группа;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.Пользователю;	
		тм_СообщенияПользователям.ПользовательКому = Параметры.ПользовательКому;
		ЭтотОбъект.Заголовок = "Группа";	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница.Имя = "Группа" Тогда
		Если Не ЗначениеЗаполнено(тм_СообщенияПользователям.НаименованиеГруппы) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле Кому'"),, "ПользовательКому", "тм_СообщенияПользователям"); 
			Возврат;
		КонецЕсли;
	Иначе		
		Если Не ЗначениеЗаполнено(тм_СообщенияПользователям.ПользовательКому) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле Кому'"),, "ПользовательКому", "тм_СообщенияПользователям"); 
			Возврат;
		ИначеЕсли ПустаяСтрока(тм_СообщенияПользователям.Сообщение) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле Сообщение'"),, "Сообщение", "тм_СообщенияПользователям"); 
			Возврат;	
		КонецЕсли; 
	КонецЕсли; 
	
	ЗаписатьНаСервере();
	Оповестить("ОбновитьСписокЧата");
//	Оповестить("ЗакрытьФорму");
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Если Элементы.Страницы.ТекущаяСтраница.Имя = "Пользователю" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	тм_СообщенияПользователям.Прочитано КАК Прочитано
			|ИЗ
			|	РегистрСведений.тм_СообщенияПользователям КАК тм_СообщенияПользователям
			|ГДЕ
			|	тм_СообщенияПользователям.ПользовательКому = &ПользовательКому
			|	И тм_СообщенияПользователям.ПользовательОтКого = &ПользовательОтКого
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	тм_СообщенияПользователям.Прочитано
			|ИЗ
			|	РегистрСведений.тм_СообщенияПользователям КАК тм_СообщенияПользователям
			|ГДЕ
			|	тм_СообщенияПользователям.ПользовательОтКого = &ПользовательКому
			|	И тм_СообщенияПользователям.ПользовательКому = &ПользовательОтКого";
		
		Запрос.УстановитьПараметр("ПользовательКому", тм_СообщенияПользователям.ПользовательКому);
		Запрос.УстановитьПараметр("ПользовательОтКого", тм_СообщенияПользователям.ПользовательОтКого);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Есть ранее созданные чаты. Удалите старые или продолжайте общение в старых :)'")); 
			Возврат ;
		КонецЕсли; 
	Иначе
		тм_СообщенияПользователям.ЭтоГруппа = Истина;
		тм_СообщенияПользователям.Сообщение =  СтрШаблон("Создана новая группа: '%1'", тм_СообщенияПользователям.НаименованиеГруппы);		
	КонецЕсли;
	
	МЗ = РегистрыСведений.тм_СообщенияПользователям.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, тм_СообщенияПользователям);
	МЗ.Период = ТекущаяДатаСеанса();
	МЗ.Записать();
	
КонецПроцедуры
