#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	Если Параметры.Свойство("Значение") Тогда
		ТекущееЗначение = Параметры.Значение;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Параметры.ЗакрыватьПриВыборе;
	Режим = Параметры.Режим;
	
	КодЯзыкаПрограммирования = ОбъектОбработки().УКО_ОбщегоНазначения_КодЯзыкаПрограммирования();
	
	Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа" Тогда
		ЗаголовокФормы = НСтр("ru = 'Выбор типа'; en = 'Type selection'");
	Иначе 
		ЗаголовокФормы = СтрШаблон(НСтр("ru = 'Редактирование типа (%1)'; en = 'Edit type (%1)'"), Параметры.Заголовок);
	КонецЕсли;
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, ЗаголовокФормы);
	
	УстановитьУсловноеОформление();
	
	ПервоначальноеЗаполнениеДерева();
	УстановитьТекущееЗначение();
	
	Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов" Тогда
		
		СписокВыбораДатаСостав = Элементы.ДатаСостав.СписокВыбора;
		СписокВыбораДатаСостав.Добавить(ЧастиДаты.ДатаВремя, НСтр("ru = 'Дата время'; en = 'Date time'"));
		СписокВыбораДатаСостав.Добавить(ЧастиДаты.Дата, НСтр("ru = 'Дата'; en = 'Date'"));
		СписокВыбораДатаСостав.Добавить(ЧастиДаты.Время, НСтр("ru = 'Время'; en = 'Time'"));
		
		СписокВыбораСтрокаТип = Элементы.СтрокаТип.СписокВыбора;
		СписокВыбораСтрокаТип.Добавить(ДопустимаяДлина.Переменная, НСтр("ru = 'Переменная'; en = 'Variable'"));
		СписокВыбораСтрокаТип.Добавить(ДопустимаяДлина.Фиксированная, НСтр("ru = 'Фиксированная'; en = 'Fixed'"));
		
		Составной = (ТекущееЗначение.Типы().Количество() > 1);
		
		ДатаСостав = ТекущееЗначение.КвалификаторыДаты.ЧастиДаты;
		
		СтрокаТип = ТекущееЗначение.КвалификаторыСтроки.ДопустимаяДлина;
		СтрокаДлина = ТекущееЗначение.КвалификаторыСтроки.Длина;
		СтрокаНеограниченная = (СтрокаДлина = 0);
		
		ЧислоДлина = ТекущееЗначение.КвалификаторыЧисла.Разрядность;
		ЧислоТочность = ТекущееЗначение.КвалификаторыЧисла.РазрядностьДробнойЧасти;
		ЧислоНеотрицательное = (ТекущееЗначение.КвалификаторыЧисла.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЭлементыФормы();
	
	Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов" Тогда
		
		УстановитьМаксимальнуюДлинуСтроки();
		
		Для Каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл 
			
			ИдентификаторСтроки = ОтмеченнаяСтрока.Значение;
			ОтметитьСтрокуВЭлементах(ИдентификаторСтроки, Истина);
			
			НайденнаяСтрока = Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			СтрокаРодитель = НайденнаяСтрока.ПолучитьРодителя();
			
			Если СтрокаРодитель <> Неопределено Тогда
				
				ИдентификаторСтрокиРодителя = СтрокаРодитель.ПолучитьИдентификатор();
				Если Не Элементы.Дерево.Развернут(ИдентификаторСтрокиРодителя) Тогда
					Элементы.Дерево.Развернуть(ИдентификаторСтрокиРодителя);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	
	Список.Очистить();
	Если ЗначениеЗаполнено(Поиск) Тогда
		ОбновитьСписокСервер();
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставнойПриИзменении(Элемент)
	
	Если Не Составной Тогда
		
		Если ЗначениеЗаполнено(ОтмеченныеСтроки) Тогда
			
			ИдентификаторПервойОтмеченнойСтроки = ОтмеченныеСтроки[0].Значение;
			СнятьВсеОтмеченныеДобавитьОдну(ИдентификаторПервойОтмеченнойСтроки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧислоДлинаПриИзменении(Элемент)
	
	Если ЧислоТочность > ЧислоДлина Тогда
		ЧислоТочность = ЧислоДлина/10;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧислоТочностьПриИзменении(Элемент)
	
	Если ЧислоДлина < ЧислоТочность Тогда
		ЧислоДлина = ЧислоТочность;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаНеограниченнаяПриИзменении(Элемент)
	
	СтрокаТип = ДопустимаяДлина.Переменная;
	
	Если СтрокаНеограниченная Тогда
		СтрокаДлина = 0;
	Иначе
		СтрокаДлина = 10;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаТипПриИзменении(Элемент)
	
	УстановитьМаксимальнуюДлинуСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаДлинаПриИзменении(Элемент)
	
	Если СтрокаДлина = 0 Тогда
		
		СтрокаНеограниченная = Истина;
		СтрокаТип = ДопустимаяДлина.Переменная;
		
	ИначеЕсли СтрокаДлина > 0 Тогда
		
		СтрокаНеограниченная = Ложь;
		
	КонецЕсли;
	
	УстановитьМаксимальнуюДлинуСтроки();
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ВыбраноЗначение(Элемент.ТекущиеДанные.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбораПередРазворачиванием(Элемент, Строка, Отказ)
	
	РазворачиваемаяСтрока = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Не РазворачиваемаяСтрока.Получено Тогда
		РазвернутьСтрокуКоллекцииСервер(РазворачиваемаяСтрока.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	УстановкаСнятиеПометки(ТекущиеДанные, ТекущиеДанные.ПолучитьИдентификатор());
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИдентификаторСтроки = Элементы.Список.ТекущиеДанные.Значение;
	ТекущаяСтрока = Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ВыбраноЗначение(ТекущаяСтрока.Значение);

КонецПроцедуры

&НаКлиенте
Процедура СписокПометкаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	УстановкаСнятиеПометки(ТекущиеДанные, ТекущиеДанные.Значение);
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекущаяСтрока = Дерево.НайтиПоИдентификатору(ИдентификаторТекущейСтроки());
	ВыбраноЗначение(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПервоначальноеЗаполнениеДерева()
	
	РежимВыборТипа = (Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа");
	РежимРедактированиеТипа = (Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеТипа");
	РежимРедактированиеОписанияТипов = (Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов");
	
	ОтображатьВсеДоступныеТипы = Ложь;
	ИспользуемыеПростыеТипы = Новый Соответствие;
	
	ИспользуемыеСсылочныеТипы = Новый Соответствие;
	
	Если РежимВыборТипа Тогда
		
		Если ЗначениеЗаполнено(ТекущееЗначение.Типы()) Тогда
			
			Для Каждого Тип Из ТекущееЗначение.Типы() Цикл 
				
				ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
				
				Если ОбъектМетаданных = Неопределено Тогда
					
					ИспользуемыеПростыеТипы.Вставить(Тип, Истина);
					
				Иначе
					
					ИмяОбъектаКоллекцииМетаданных = УКО_СтрокиКлиентСервер_РазборПрочитатьИдентификатор(ОбъектМетаданных.ПолноеИмя());
					ТипыКоллекции = ИспользуемыеСсылочныеТипы.Получить(ИмяОбъектаКоллекцииМетаданных);
					Если ТипыКоллекции = Неопределено Тогда
						ТипыКоллекции = Новый СписокЗначений;
					КонецЕсли;
					
					ТипыКоллекции.Добавить(Тип, Тип);
					ИспользуемыеСсылочныеТипы.Вставить(ИмяОбъектаКоллекцииМетаданных, ТипыКоллекции);
					
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе	
			
			ОтображатьВсеДоступныеТипы = Истина;
			
		КонецЕсли;
		
	Иначе 
		
		ОтображатьВсеДоступныеТипы = Истина;
		
	КонецЕсли;
	
	// Добавление простых типов
	ИсключаемыеТипы = СтрРазделить(Параметры.ИсключаемыеТипы, ",");
	ПростыеТипы = ПорядокПростыхТипов(КодЯзыкаПрограммирования, РежимРедактированиеТипа);
	
	Для Каждого ОписаниеТипа Из ПростыеТипы Цикл 
		
		Тип = Тип(ОписаниеТипа.Значение);
		Если ОтображатьВсеДоступныеТипы ИЛИ ИспользуемыеПростыеТипы.Получить(Тип) <> Неопределено Тогда
			
			ДобавитьСтрокуДерева(Дерево, ОписаниеТипа.Значение, ОписаниеТипа.Представление, УКО_ОбщегоНазначенияКлиентСервер_КартинкаТипа(Тип));
			
			Если Тип = Тип("Дата") И Не РежимРедактированиеОписанияТипов Тогда
				
				ТипСтрока = "МоментВремени";
				ПредставлениеТипа = НСтр("ru = 'МоментВремени'; en = 'PointInTime'", КодЯзыкаПрограммирования);
				Если ИсключаемыеТипы.Найти(ТипСтрока) = Неопределено Тогда
					ДобавитьСтрокуДерева(Дерево, ТипСтрока, ПредставлениеТипа, УКО_ОбщегоНазначенияКлиентСервер_КартинкаТипа(Тип(ТипСтрока)));
				КонецЕсли;
				
				ТипСтрока = "Граница";
				ПредставлениеТипа = НСтр("ru = 'Граница'; en = 'Boundary'", КодЯзыкаПрограммирования);
				Если ИсключаемыеТипы.Найти(ТипСтрока) = Неопределено Тогда
					ДобавитьСтрокуДерева(Дерево, ТипСтрока, ПредставлениеТипа, УКО_ОбщегоНазначенияКлиентСервер_КартинкаТипа(Тип(ТипСтрока)));
				КонецЕсли;
				
			КонецЕсли;
			
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавление ссылочных типов
	Если ОтображатьВсеДоступныеТипы Тогда
		
		ТипыОбъектов = УКО_МетаданныеКлиентСервер_ДоступныеТипыОбъекта(КодЯзыкаПрограммирования);
		Для Каждого ТипОбъекта Из ТипыОбъектов Цикл 
			
			КоллекцияМетаданных = Метаданные[ОбъектОбработки().УКО_Метаданные_ИмяКоллекции(ТипОбъекта)];
			Если КоллекцияМетаданных.Количество() Тогда
				СтрокаКоллекция = ДобавитьСтрокуДерева(Дерево, "", ТипОбъекта, БиблиотекаКартинок[ТипОбъекта], Ложь);
				ДобавитьСтрокуДерева(СтрокаКоллекция, "");
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ИспользуемыйСсылочныйТип Из ИспользуемыеСсылочныеТипы Цикл 
			ИспользуемыйСсылочныйТип.Значение.СортироватьПоПредставлению();
		КонецЦикла;
		
		ТипыОбъектов = УКО_МетаданныеКлиентСервер_ДоступныеТипыОбъекта(КодЯзыкаПрограммирования);
		Для Каждого ТипОбъекта Из ТипыОбъектов Цикл 
			
			ОписаниеТиповКоллекции = ИспользуемыеСсылочныеТипы.Получить(ТипОбъекта);
			Если ОписаниеТиповКоллекции = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			КартинкаКоллекции = БиблиотекаКартинок[ТипОбъекта];
			СтрокаКоллекция = ДобавитьСтрокуДерева(Дерево, Неопределено, ТипОбъекта, КартинкаКоллекции);
			
			Для Каждого ОписаниеТипа Из ОписаниеТиповКоллекции Цикл
				
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ОписаниеТипа.Значение);
				ДобавитьСтрокуДерева(СтрокаКоллекция, УКО_МетаданныеКлиентСервер_ТипСсылка(ТипОбъекта, ОбъектМетаданных.Имя, КодЯзыкаПрограммирования), ОбъектМетаданных.Имя, КартинкаКоллекции);
				
			КонецЦикла; 
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущееЗначение()
	
	Если Не ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеТипа" Тогда 
		
		УстановитьТекущуюСтроку(Дерево, ТекущееЗначение);
		
	ИначеЕсли Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов" Тогда 
		
		ОтметитьВыбранныеТипы(Дерево, ТекущееЗначение);
		
	ИначеЕсли Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа" Тогда 
		
		Если ТекущееЗначение.Типы().Количество() <= 20 Тогда
			Элементы.Дерево.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьВыбранныеТипы(КоллекцияСтрок, ОписаниеТипов)
	
	Для Каждого ВыбранныйТип Из ОписаниеТипов.Типы() Цикл 
		
		Для Каждого Строка Из КоллекцияСтрок.ПолучитьЭлементы() Цикл 
			
			Если Строка.Значение = "" Тогда
				
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ВыбранныйТип);
				ИмяОбъектаКоллекцииМетаданных = УКО_СтрокиКлиентСервер_РазборПрочитатьИдентификатор(ОбъектМетаданных.ПолноеИмя());			
				
				Если ИмяОбъектаКоллекцииМетаданных = Строка.Представление Тогда
					
					РазвернутьСтрокуКоллекцииСервер(Строка);
					
					Типы = Новый Массив;
					Типы.Добавить(ВыбранныйТип);
					
					ВыбранныйТипОписаниеТипов = Новый ОписаниеТипов(Типы);
					ОтметитьВыбранныеТипы(Строка, ВыбранныйТипОписаниеТипов);
					
					Прервать;

				КонецЕсли;
				
			ИначеЕсли Тип(Строка.Значение) = ВыбранныйТип Тогда
				
				ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
				ОтмеченныеСтроки.Добавить(ИдентификаторСтроки);
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьТекущуюСтроку(КоллекцияСтрок, Значение)
	
	Для Каждого Строка Из КоллекцияСтрок.ПолучитьЭлементы() Цикл 
		
		
		Если Строка.Значение = "" Тогда
			
			ОбъектМетаданных = Метаданные.НайтиПоТипу(Значение);
			ИмяОбъектаКоллекцииМетаданных = УКО_СтрокиКлиентСервер_РазборПрочитатьИдентификатор(ОбъектМетаданных.ПолноеИмя());			
			
			Если ИмяОбъектаКоллекцииМетаданных = Строка.Представление Тогда
				
				РазвернутьСтрокуКоллекцииСервер(Строка);
				
				УстановитьТекущуюСтроку(Строка, Значение);
				Прервать;
				
			КонецЕсли;
			
		ИначеЕсли Тип(Строка.Значение) = Значение Тогда
			
			Элементы.Дерево.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуДерева(СтрокаПриемник, Значение, Представление = "", Картинка = Неопределено, Получено = Истина)

	НоваяСтрока = СтрокаПриемник.ПолучитьЭлементы().Добавить();
	НоваяСтрока.Значение = Значение;
	НоваяСтрока.Картинка = Картинка;
	НоваяСтрока.Получено = Получено;
	
	Если ПустаяСтрока(Представление) Тогда
		Представление = Значение;
	КонецЕсли;
	НоваяСтрока.Представление = Представление;
	
    Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Процедура РазвернутьСтрокуКоллекцииСервер(Строка)

	Если ТипЗнч(Строка) = Тип("Число") Тогда
		РазворачиваемаяСтрока = Дерево.НайтиПоИдентификатору(Строка);
	Иначе
		РазворачиваемаяСтрока = Строка;
	КонецЕсли;
	
	Если РазворачиваемаяСтрока.Получено Тогда
		Возврат;
	КонецЕсли;

	ИмяОбъектаКоллекции = РазворачиваемаяСтрока.Представление;
	
	РазворачиваемаяСтрока.Получено = Истина;
	РазворачиваемаяСтрока.ПолучитьЭлементы().Очистить();
	
	КоллекцияМетаданных = Метаданные[ОбъектОбработки().УКО_Метаданные_ИмяКоллекции(ИмяОбъектаКоллекции)];
	
	СписокТипов = Новый СписокЗначений;
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл 
		СписокТипов.Добавить(УКО_МетаданныеКлиентСервер_ТипСсылка(ИмяОбъектаКоллекции, ОбъектМетаданных.Имя, КодЯзыкаПрограммирования), ОбъектМетаданных.Имя);
	КонецЦикла;
	СписокТипов.СортироватьПоПредставлению();
	
	Для Каждого ОписаниеТипа Из СписокТипов Цикл 
		ДобавитьСтрокуДерева(РазворачиваемаяСтрока, ОписаниеТипа.Значение, ОписаниеТипа.Представление, РазворачиваемаяСтрока.Картинка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПорядокПростыхТипов(КодЯзыкаПрограммирования, РедактированиеТипа = Истина)
	
	Результат = Новый СписокЗначений;
	Результат.Добавить("Число", НСтр("ru = 'Число'; en = 'Number'", КодЯзыкаПрограммирования));
	Результат.Добавить("Строка", НСтр("ru = 'Строка'; en = 'String'", КодЯзыкаПрограммирования));
	Результат.Добавить("Булево", НСтр("ru = 'Булево'; en = 'Boolean'", КодЯзыкаПрограммирования));
	Результат.Добавить("Дата", НСтр("ru = 'Дата'; en = 'Date'", КодЯзыкаПрограммирования));
	Результат.Добавить("УникальныйИдентификатор", НСтр("ru = 'УникальныйИдентификатор'; en = 'UUID'", КодЯзыкаПрограммирования));
	
	Если РедактированиеТипа Тогда
		
		Результат.Добавить("ХранилищеЗначения", НСтр("ru = 'ХранилищеЗначения'; en = 'ValueStorage'", КодЯзыкаПрограммирования));
		Результат.Добавить("Неопределено", НСтр("ru = 'Неопределено'; en = 'Undefined'", КодЯзыкаПрограммирования));
		Результат.Добавить("Null");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ОбновитьЭлементыФормы()
	
	ПоискЗаполнен = ЗначениеЗаполнено(Поиск);
	РежимРедактированиеОписанияТипов = (Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов");
	ИдентификаторСтроки = ИдентификаторТекущейСтроки();
	
	Элементы.Дерево.Видимость = Не ПоискЗаполнен;
	Элементы.Список.Видимость = ПоискЗаполнен;
	
	Элементы.Составной.Видимость = РежимРедактированиеОписанияТипов;
	Элементы.ДеревоПометка.Видимость = РежимРедактированиеОписанияТипов;
	Элементы.СписокПометка.Видимость = РежимРедактированиеОписанияТипов;
	
	
	Если РежимРедактированиеОписанияТипов Тогда
		
		ТипСтрокой = ""; ПометкаСтроки = Ложь;
		Если ИдентификаторСтроки <> Неопределено Тогда
			НайденнаяСтрока = Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
			ТипСтрокой = НайденнаяСтрока.Значение;
			ПометкаСтроки = НайденнаяСтрока.Пометка;
		КонецЕсли;
		
		ТипСтрокиДата = (ТипСтрокой = "Дата");
		ТипСтрокиЧисло = (ТипСтрокой = "Число");
		ТипСтрокиСтрока = (ТипСтрокой = "Строка");
		
		Элементы.ГруппаДата.Видимость = ТипСтрокиДата;
		Элементы.ГруппаДата.Доступность = ТипСтрокиДата И ПометкаСтроки;
		Элементы.ГруппаЧисло.Видимость = ТипСтрокиЧисло;
		Элементы.ГруппаЧисло.Доступность = ТипСтрокиЧисло И ПометкаСтроки;
		Элементы.ГруппаСтрока.Видимость = ТипСтрокиСтрока;
		Элементы.ГруппаСтрока.Доступность = ТипСтрокиСтрока И ПометкаСтроки;
		Элементы.СтрокаТип.Доступность = СтрокаДлина < 100 И Не СтрокаНеограниченная;
		
	КонецЕсли;
	
	Элементы.ФормаКомандаОК.Доступность = (ИдентификаторСтроки <> Неопределено);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ДеревоПометка", Новый Структура("Отображать", Ложь), "Дерево.Значение", "");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСервер()
	
	// Получим все строки коллекций
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл 
		
		РазвернутьСтрокуКоллекцииСервер(Строка);
		
	КонецЦикла;
	
	ДобавитьВСписок(Дерево);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписок(КоллекцияСтрок)
	
	Для Каждого Строка Из КоллекцияСтрок.ПолучитьЭлементы() Цикл 
		
		ЭтоГруппа = ЗначениеЗаполнено(Строка.ПолучитьЭлементы());
		
		Если ЭтоГруппа Тогда
			
			ДобавитьВСписок(Строка);
			
		Иначе
			Если СтрНайти(ВРег(Строка.Представление), ВРег(Поиск)) Тогда
				
				Список.Добавить(Строка.ПолучитьИдентификатор(), Строка.Представление, Строка.Пометка,Строка.Картинка);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбраноЗначение(Значение)
	
	Результат = Неопределено;
	
	Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов" Тогда
		
		Если Значение = Неопределено Тогда
			
			ВыбранныеТипы = Новый Массив;
			Для Каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл 
				НайденнаяСтрока = Дерево.НайтиПоИдентификатору(ОтмеченнаяСтрока.Значение);
				ВыбранныеТипы.Добавить(НайденнаяСтрока.Значение);
			КонецЦикла;
			
			Если ЧислоНеотрицательное Тогда
				ЗаданныйДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный;
			Иначе
				ЗаданныйДопустимыйЗнак = ДопустимыйЗнак.Любой;
			КонецЕсли;
			
			Результат = Новый ОписаниеТипов(СтрСоединить(ВыбранныеТипы, ","), Новый КвалификаторыЧисла(ЧислоДлина, ЧислоТочность, ЗаданныйДопустимыйЗнак),
			Новый КвалификаторыСтроки(СтрокаДлина, СтрокаТип), Новый КвалификаторыДаты(ДатаСостав));
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(Значение) Тогда
			
			Тип = Тип(Значение);
			Если Режим = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа" Тогда
				
				Типы = Новый Массив;
				Типы.Добавить(Тип);
				Результат = Новый ОписаниеТипов(Типы);
				
			Иначе
				
				Результат = Тип;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Возвращаем значение
	Если Результат <> Неопределено Тогда
		
		Если ЗакрыватьПриВыборе Тогда
			
			Закрыть(Результат);
			
		Иначе
			
			ОповеститьОВыборе(Результат);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаСнятиеПометки(Строка, Идентификатор)
	
	Если Составной Тогда
		
		Если Строка.Пометка Тогда
			ОтмеченныеСтроки.Добавить(Идентификатор);
		Иначе
			ОтмеченныеСтроки.Удалить(ОтмеченныеСтроки.НайтиПоЗначению(Идентификатор));
		КонецЕсли;
		
		ОтметитьСтрокуВЭлементах(Идентификатор, Строка.Пометка);
		
	Иначе
		
		СнятьВсеОтмеченныеДобавитьОдну(Идентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтмеченныеДобавитьОдну(Идентификатор)
	
	Для Каждого ОтмеченнаяСтрока Из ОтмеченныеСтроки Цикл 
		
		ОтметитьСтрокуВЭлементах(ОтмеченнаяСтрока.Значение, Ложь);
		
	КонецЦикла;
	
	ОтмеченныеСтроки.Очистить();
	ОтмеченныеСтроки.Добавить(Идентификатор);
	ОтметитьСтрокуВЭлементах(Идентификатор, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСтрокуВЭлементах(Идентификатор, Пометка)
	
	// Снимаем пометки в дереве
	НайденнаяСтрока = Дерево.НайтиПоИдентификатору(Идентификатор);
	НайденнаяСтрока.Пометка = Пометка;
	
	// Снимаем пометки в списке
	НайденныйЭлемент = Список.НайтиПоЗначению(Идентификатор);
	Если НайденныйЭлемент <> Неопределено Тогда
		НайденныйЭлемент.Пометка = Пометка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМаксимальнуюДлинуСтроки()
	
	Если СтрокаТип = ДопустимаяДлина.Переменная Тогда
		
		Максимум = 1024;
		
	Иначе
		
		Максимум = 100;
		
	КонецЕсли;
	
	Элементы.СтрокаДлина.МаксимальноеЗначение = Максимум;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДанныхПослеОжидания()

	ОбновитьЭлементыФормы();

КонецПроцедуры

&НаКлиенте
Функция ИдентификаторТекущейСтроки()
	
	Результат = Неопределено;
	Если ЗначениеЗаполнено(Поиск) Тогда
		
		СписокТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если СписокТекущиеДанные <> Неопределено Тогда
			Результат = СписокТекущиеДанные.Значение;
		КонецЕсли;
		
	Иначе
		
		Результат = Элементы.Дерево.ТекущаяСтрока;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура УКО_ФормыКлиентСервер_Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает строку ДокументСсылка.<Имя>, СправочникСсылка.<Имя>
//
// Параметры:
//   ИмяОбъектаКоллекции - Строка - Имя объект коллекции
//   ИмяОбъекта - Строка - Имя объекта
//   КодЯзыка - Строка - Код языка
//
// Возвращаемое значение:
//   Строка - Строка ссылочного типа метаданных
//
Функция УКО_МетаданныеКлиентСервер_ТипСсылка(ИмяОбъектаКоллекции, ИмяОбъекта, КодЯзыка = "ru") Экспорт
	
	Возврат СтрШаблон("%1%2.%3", ИмяОбъектаКоллекции, НСтр("ru = 'Ссылка'; en = 'Ref'", КодЯзыка), ИмяОбъекта);
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает доступные типы объекта
//
// Параметры:
//   КодЯзыка - Строка - Код языка
//
// Возвращаемое значение:
//   Массив - Строки доступных типов объектов
//
Функция УКО_МетаданныеКлиентСервер_ДоступныеТипыОбъекта(КодЯзыка = "ru") Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(НСтр("ru = 'Справочник'; en = 'Catalog'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'Документ'; en = 'Document'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'Перечисление'; en = 'Enum'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'ПланВидовХарактеристик'; en = 'ChartOfCharacteristicTypes'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'ПланСчетов'; en = 'ChartOfAccounts'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'ПланВидовРасчета'; en = 'ChartOfCalculationTypes'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'ПланОбмена'; en = 'ExchangePlan'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'БизнесПроцесс'; en = 'BusinessProcess'", КодЯзыка));
	Результат.Добавить(НСтр("ru = 'Задача'; en = 'Task'", КодЯзыка));
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЦифры()
	
	Возврат "0123456789";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает код английского языка
// Возвращаемое значение:
//   Строка	- Код английского языка
//
Функция УКО_ОбщегоНазначенияКлиентСервер_КодЯзыкаАнглийский() Экспорт
	Возврат "en";
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает код русского языка
// Возвращаемое значение:
//   Строка	- Код русского языка
//
Функция УКО_ОбщегоНазначенияКлиентСервер_КодЯзыкаРусский() Экспорт
	Возврат "ru";
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Получает картинку типа
//
// Параметры:
//  Тип  - Тип - Тип
//  ОписаниеТипов - ОписаниеТипов - Описание типов
//
// Возвращаемое значение:
//   Картинка - Картинка типа
//
Функция УКО_ОбщегоНазначенияКлиентСервер_КартинкаТипа(Тип, ОписаниеТипов = Неопределено) Экспорт
	
	Если Тип = Тип("Неопределено") Тогда 
		Картинка = Новый Картинка;
	ИначеЕсли Тип = Тип("Тип")
			ИЛИ Тип = Тип("ОписаниеТипов") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAA" + Символы.ВК + Символы.ПС + "AARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3" + Символы.ВК + Символы.ПС + "YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABoSURBVDhPY/j//z8DJZgizSCLB6EB" + Символы.ВК + Символы.ПС + "mpqa/52dHLFikBx6eGF4wczMFKTZG6QwNjbyPwiD2CAxkBxBA2Ca0Q2AGULQAGQF" + Символы.ВК + Символы.ПС + "yC7AFdV4Y2EkGwCKiYryov+geAdhEBs5dpADdBAmZVKzNgDOWtNtpSsLpgAAAABJ" + Символы.ВК + Символы.ПС + "RU5ErkJggg=="));
	ИначеЕсли Тип = Тип("Число") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAB+SURBVDhPY2AYBVhDwKFr538QdmnbAsbO7Vv/" + Символы.ВК + Символы.ПС + "EwoqkIIGmCKQJmQNaHyQHIp6mFq4JpgGm779YDEsBoCEMVyFYgDIC86tm8GuQncR" + Символы.ВК + Символы.ПС + "1Eb8BsA0gQzBYgBhLyDbTpYLQM4EGQKLDaRAhTkdvxfIiQW4HlC8w9IAsemAUDoZ" + Символы.ВК + Символы.ПС + "xPIAH+BkJrGgRacAAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("Строка") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAB1SURBVDhPY2AYLOA/0CEg3ECpg0CGgIFD1044" + Символы.ВК + Символы.ПС + "m5ChIFthLoBrcmnbQrQByAqpawDIGyBs37kTb9ggewHkXbArkL1ASnjAwwvZAFLC" + Символы.ВК + Символы.ПС + "A6sBSC5Adi3+KAf5G2QzWhhgDXBC0YwsT3TU4jKUqgaQZRjxgUhswAAA9DFDYfgs" + Символы.ВК + Символы.ПС + "T48AAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("Булево") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAFPSURBVDhPY2CgBvCfqN8QvsjwPwiHLTD47zhZ" + Символы.ВК + Символы.ПС + "/L/zFKn/QbP1/7tPUv7vPUn9v32X1P+AiQb/QWox7ARpJBZ4Nxv8p8gA4zwxTJc4" + Символы.ВК + Символы.ПС + "TZXA64CA7bL//bfJgtUYZoqBaRSXOEwSBwsG7ZX7H7xPDsUwkGan6RL/rVpFweL6" + Символы.ВК + Символы.ПС + "KRDasxrJKzADQIrcl8r+B2kCAeu9ImDN+rlC/09ePgIxIBliAMgl8LBwmAhxAUgR" + Символы.ВК + Символы.ПС + "yBC3JTJgQ9A1g9ToJSFcAjcgdK4B3NkgQ0A2YtMMUuRarA93CdyAoBkIA2AuUfcT" + Символы.ВК + Символы.ПС + "gTsbOVCcciAGgFwCNyAQmECIBQ7pemClIJfADfDtJN4A+0SIASCXwA0AJU/PKgNg" + Символы.ВК + Символы.ПС + "yEr8d8nT+68TLfJfL1b8v32G9n/jGPn/FrGq/3WCgXyg5tqpRWADQC7BSJGkugTD" + Символы.ВК + Символы.ПС + "AM9KiEtcS/UJusQ+URczU5GTswEMEielMbjVjwAAAABJRU5ErkJggg=="));
	ИначеЕсли Тип = Тип("ВидДвиженияНакопления") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAA" + Символы.ВК + Символы.ПС + "AARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3" + Символы.ВК + Символы.ПС + "YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAAAz0lEQVQ4T2P4//8/RRirICkYQyB4" + Символы.ВК + Символы.ПС + "n/x/EEYXx4UxBAJ3yP33WSMDZKKKw/C6dev+gzCMD5cAafTbJPsfRDvPkAQbYlIm" + Символы.ВК + Символы.ПС + "ClcIwiCNiYmJKGJwhtcKGbBGEDarFvlvkCeEYgA2zSCMwgFhx6kSYM3IYrg0gzCG" + Символы.ВК + Символы.ПС + "gIa/6H/dZGEgE8LHpxmEsQrCMCHNIIxVEISJ0QzCWAWJ1QzCGALYND9Ldvt/014N" + Символы.ВК + Символы.ПС + "ju84acDl4YpAGJfNIE2HxBjgeIYoL1wNikKQAch8YjBWQVIwVkHi8X8GAOxy2Avy" + Символы.ВК + Символы.ПС + "wzimAAAAAElFTkSuQmCC"));
	ИначеЕсли Тип = Тип("ВидДвиженияБухгалтерии")
			ИЛИ Тип = Тип("ВидСчета") Тогда 
		Картинка = БиблиотекаКартинок.ПланСчетов;
	ИначеЕсли Тип = Тип("Дата") Тогда 
		
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAGPSURBVDhPrZPLSwJRFMb7k3rRH1GuWrRrHbQO" + Символы.ВК + Символы.ПС + "bNIcpUarTdSqx6akkoxCQkMqyBatIoJIIyeK6F2Olho6z69zb1hN2gNq4Mc55zvn" + Символы.ВК + Символы.ПС + "fPfCcOvq/uPTk2Ne3MbAOFmXcL0zCuQPeV1LY/O2c3c3p0Eix9fRAHnNAyt/8qUW" + Символы.ВК + Символы.ПС + "X/DBbrAxAXmp69fE50W7wfxqDHJqH/LRD9BMNnMLaWSg2sAsXsEsXMFisQLVFf2t" + Символы.ВК + Символы.ПС + "rxZqGxjZNIxcGk/9XVAcLZznmRGY2WOU4rO8NqlvlZTvDbgRLTH4EsWK6fcGd3sw" + Символы.ВК + Символы.ПС + "PqBTrjiawSLTK7lVvKl9A/0yAY3QL7fxJHRCaWtCccpN9avGau0iATN/XsMgEoF2" + Символы.ВК + Символы.ПС + "GiOi7/EsSkuN0M6YHuO5SrmZkyENeT/9hZVlqMdhqGk7mdYG0pegUe81D8NQjiAF" + Символы.ВК + Символы.ПС + "PHaDueVFqKkgyqlZPPa003A9Jz/ejXIy+KaxnvFwgEG/y24wFQrx6+sXWzDu93+k" + Символы.ВК + Символы.ПС + "TxTsBpOhkFcY8MI/LBJu+AMuQqhC8jvRKzohiIL9Mf3lRb8A8+FJK+/UducAAAAA" + Символы.ВК + Символы.ПС + "SUVORK5CYII="));
		Если ОписаниеТипов <> Неопределено Тогда
			Если ОписаниеТипов.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.Время Тогда
				Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABh0RVh0U29mdHdhcmUAcGFpbnQubmV0" + Символы.ВК + Символы.ПС + "IDQuMC42/Ixj3wAAAcNJREFUOE+NU9suQ0EUPf/iDyTiI0g8eheJROIbCK8IEW2K" + Символы.ВК + Символы.ПС + "JkhoXB4qxKWkfdC4tklzSvUitIi6t6Vu1Vq6hjk9cwgeTiYzZ9Zlr71Ha2/VNPPX" + Символы.ВК + Символы.ПС + "2T/YPDM/h16HE119g2LlnufWu9wr4PnVJTinZqEfxHGXu8dToYCrTAZBfR9Drmnw" + Символы.ВК + Символы.ПС + "v5XEICgrYCekowTgrfSO12IRVU19yD+/IPf4hLv7PHwb23SikAgC9/IiguF9BUx1" + Символы.ВК + Символы.ПС + "EkjwdSaH9E0G3o1d8L50orE2p2vmG5jKJKCyBJ9d3iJ1fgXb2KSRicaA9GjcsE1l" + Символы.ВК + Символы.ПС + "aZsEB6m0UJbgo9MLrPl3RLAixG77MLIPeVGzGUxlElS32RFKnAplghOpc4QiCfQ4" + Символы.ВК + Символы.ПС + "Rj4JOnoHBDhXX6sE5gnG0DAcxsJmRAFftzRiL54ULTYc3GSzKjgQE8p0YFaOHp0h" + Символы.ВК + Символы.ПС + "cniCQDhaccBa2GeZtucLTGUSSNsSvJdIYtHrr2TALnBIWHMkmRbKVttmsB47xsDo" + Символы.ВК + Символы.ПС + "RKULrIMT5i0PCdO2BmYFu1d8ykQqk7i6vqXUnK2rETXTNpXdHh86v8IzBsk823Ri" + Символы.ВК + Символы.ПС + "G3eJPrNVTJuBsWba/vUtSCL5Gtlntorrv1/jT8/1r7MPBZCljqnY77MAAAAASUVO" + Символы.ВК + Символы.ПС + "RK5CYII="));
			ИначеЕсли ОписаниеТипов.КвалификаторыДаты.ЧастиДаты = ЧастиДаты.ДатаВремя Тогда
				Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOvwAADr8BOAVTJAAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAIuSURBVDhPrZPbTxNREMb5Y3xXo/HZZ9TE8GB8" + Символы.ВК + Символы.ПС + "8UFNaGJMrHcboNuKULsGGxUTKTWxSm2slhDTJVVMhBB80BgKQu1l2ULbZQu90QK9" + Символы.ВК + Символы.ПС + "bbef52yhTSOoD57kl8nMOfPNZCanre1/HHnxkQEJDhT+Yx9WZyxAfkH194rR9y11" + Символы.ВК + Символы.ПС + "v30aBgmqGM8cRnhcj1qe3zfmfW1Eq8DEM4Tfav4Zr4NpFXC85xD2zyL88y+QN5lU" + Символы.ВК + Символы.ПС + "An1s7+8CypYIZVNEjdpdiL8bb9yXN/cWqGZCqGZDyPVokD55TGX7BQslE0TRa1d9" + Символы.ВК + Символы.ПС + "hdzXiuk/C6hCJIlCkwJ8BBarHc+dbthcHgy9csEw8BRahu1uDJLOoLr2vQWZ+FTA" + Символы.ВК + Символы.ПС + "PGhDKp1FYVlAIJrARjik2tMXtU0RKiDHJ1EhyPEp5HTnkD5xBD3sEyTTGZRW4yhK" + Символы.ВК + Символы.ПС + "Ig5csCAhRCEEI+BjCXR2mevDdIyNoSJwBE/TRjywjrhAj1zYRrGi4LhxFOO+KOYi" + Символы.ВК + Символы.ПС + "KaxkS7hlerwjMOpGOehCOdQKNzGFZZZBsSQjKOVxtKMT3gUJ00tZTOru4Bqz08GI" + Символы.ВК + Символы.ПС + "+w3K/pco+e3YuNGBVPshlWHHOxRkBQev2BpMCzl4fCJ+SFu4rGfrHVidTrV9OfYZ" + Символы.ВК + Символы.ПС + "1fXZBvoHg1gS1xEJCpib59XK3JcAPsz4sSIlcUqjqwsMOZ0GXa8B/WaG0I1+UxdB" + Символы.ВК + Символы.ПС + "p1qyLohrSfC+RdL2bfi+ziNGktvPX8XZm/ebq9zvV9N9X2IGcP2eBVq9Cdq7D2li" + Символы.ВК + Символы.ПС + "I/kXf1WIeuufWvwAAAAASUVORK5CYII="));
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Тип = Тип("УникальныйИдентификатор") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAABFSURBVDhPY2AYPiA7O/s/CMN8BOMj0Q14fYvL" + Символы.ВК + Символы.ПС + "ADQDcRtCyACQQVA12A0hwQC4N1G8NKQMIC8M8AYgUgiTnw6GT5Yg2ScAOrt7BzPC" + Символы.ВК + Символы.ПС + "tocAAAAASUVORK5CYII="));
	ИначеЕсли Тип = Тип("ХранилищеЗначения") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwAAADsABataJCQAAAB90RVh0U29mdHdhcmUAUGFpbnQuTkVU" + Символы.ВК + Символы.ПС + "ID8/Pz8/PyAzLjUuNefKA2EAAAH5SURBVDhPrZPfT1JhGMf507qQOaVaxpRumZCQ" + Символы.ВК + Символы.ПС + "5fLGiyhlaxEGGmvFKjEhRTaXsxyWDLDjRpScZjWYVMOSOQMn1Fi1fuqn8542Fp20" + Символы.ВК + Символы.ПС + "G8/2XJy9z/t93u/387463X5+r5LnnCtxLxH3UZYiNrX+/Bfre857nexnpyaxGLGy" + Символы.ВК + Символы.ПС + "szHI90IfP8p3WLjVzsflU2TCnewpICa+L4RITR2nmhuglD5JadlDMtBOMW5hfvjg" + Символы.ВК + Символы.ПС + "/wVyD1xMnDcg3TCRvGZEnnYQPKsnpmzeVUB4E9MzSv0s3UYKdfA130NN7uZTYZSY" + Символы.ВК + Символы.ПС + "30hZsjHnNfDPHIR3Nq+SuNJGJetBCnawsWjlzXwnxUcuVeDlXTPjA81MDZm0NlTv" + Символы.ВК + Символы.ПС + "eaXRd5gva2MkAkaqj+28SypZZEeI+o7wNmohcEavliZIIfBkskv1Kc8OEuzXM+Nu" + Символы.ВК + Символы.ПС + "UZsTkxfw9R7A39fEyG4Cwvt20UEudZlxbxu5xAlycRvZmJUX9y08f6iIXjyEPGNW" + Символы.ВК + Символы.ПС + "c9CcIB0yU33azYe8l9TEMSoZO5UlO5tpG6VUF+Vnl+oo77lbtQLSdRPbhd4GAp+z" + Символы.ВК + Символы.ПС + "Perl+ZvEtKtFKyDS31Imbq3crBNYX7CyplweQWJd9jeQ0FgQ6YuJ30pzdQKVlF1l" + Символы.ВК + Символы.ПС + "L0jUVmcbSGgFhgxOQWA1HWbM0UTU04o4atjZzKhDjxwPMXz6N4mY0rufD1j3C7vu" + Символы.ВК + Символы.ПС + "vw0TxEc9AAAAAElFTkSuQmCC"));
	ИначеЕсли Тип = Тип("МоментВремени") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwQAADsEBuJFr7QAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0" + Символы.ВК + Символы.ПС + "IDQuMC4xNzNun2MAAADuSURBVDhPY/j//z9FGIXjbmHBEaqlZQaikcXxYTjDxdqa" + Символы.ВК + Символы.ПС + "N0lW9k4BH9/vZBmZ2/4GBjzICnFhBgcHh/8gDDTgfz4///8SLq7/QEP+u1pZgcUJ" + Символы.ВК + Символы.ПС + "YbhJIBeAbC7k5f2dIi19O1BPjxvZJlwYhROvoMAWpapqCqKRxfFhrIKkYKyCMKyS" + Символы.ВК + Символы.ПС + "1N+gXT0ZyMSUcwKKg+QxJJCxcd5EIIVdDoRB8lglYBhoA5DCLgfCIHmsEjAMUgDE" + Символы.ВК + Символы.ПС + "NhHVq8DOhYo1QPk2IHmsGmEYpADkV4a0mRgYGgbYNcIwSAHIJopcgC6GjAkaQI1Y" + Символы.ВК + Символы.ПС + "aAD5FV0chCFh0N8AAGaTn8a00cVlAAAAAElFTkSuQmCC"));
	ИначеЕсли Тип = Тип("Граница") Тогда 
		Картинка = Новый Картинка(Base64Значение("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAALGPC/xh" + Символы.ВК + Символы.ПС + "BQAAAAlwSFlzAAAOwQAADsEBuJFr7QAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0" + Символы.ВК + Символы.ПС + "IDQuMC4xNzNun2MAAADzSURBVDhPY/j//z8KdnBwAFKoYvgwCidMQ4Pbxcrqf5CO" + Символы.ВК + Символы.ПС + "DheyOD4MZ8QrKIilSkndz+fn/58oJ3fTzdKSKEPATnawt//vYW7+v4CP738JF9f/" + Символы.ВК + Символы.ПС + "XCGh/y7W1v/BcgQw3KQYJSWxFCmpu3kCAiAXXHe3sOBEtgkXRuFEqqmxgmz2NzBg" + Символы.ВК + Символы.ПС + "QRbHhzEEQM5CF8OHMQSQDVBJ6m/Qrp4M5yNjJ6A4SB5DAtkA47yJcDY2DJLHEERz" + Символы.ВК + Символы.ПС + "AZyNDYPkMQTRDQBim4jqVWDnQsUaoHwbkDxBA0B+ZUibiYGhYUDYAJBNFLkAxsaG" + Символы.ВК + Символы.ПС + "CRpAjVhoAPkVxkfGkDDobwAAFxmTw3vLbs8AAAAASUVORK5CYII="));
	Иначе
		
		Картинка = УКО_ОбщегоНазначенияВызовСервера_КартинкаТипа(Тип);
		
	КонецЕсли;
	
	Возврат Картинка;
	
КонецФункции
&НаСервереБезКонтекста
// Получает картинку по типу
//
// Параметры:
//  Тип  - Тип - Тип
//
// Возвращаемое значение:
//   Картинка - Картинка типа
//
Функция УКО_ОбщегоНазначенияВызовСервера_КартинкаТипа(Тип) Экспорт
	
	Если Тип = Тип("ТаблицаЗначений") Тогда 
		Результат = БиблиотекаКартинок.ВнешнийИсточникДанныхТаблица;
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
			
		Если ОбъектМетаданных <> Неопределено Тогда
			ИмяОбъектаКоллекцииМетаданных = УКО_СтрокиКлиентСервер_РазборПрочитатьИдентификатор(ОбъектМетаданных.ПолноеИмя());
			Результат = БиблиотекаКартинок[ИмяОбъектаКоллекцииМетаданных];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Чтение идентификатора строки
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачальныйИндекс - Число - Начальный индекс
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Строка	- Прочитанный идентификатор
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьИдентификатор(Строка, НачальныйИндекс = 1, СмещатьИндекс = Истина) Экспорт
	
	НаборСимволовИдентификатор = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + УКО_СтрокиКлиентСервер_НаборСимволовЦифры() + "_";
	НаборСимволовИдентификаторПервыйСимвол = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + "_";
	
	Для Индекс = НачальныйИндекс По СтрДлина(Строка) Цикл 
		
		Символ = Сред(Строка, Индекс, 1);
		Если Индекс = НачальныйИндекс Тогда
			НаборСимволов = НаборСимволовИдентификаторПервыйСимвол;
		Иначе
			НаборСимволов = НаборСимволовИдентификатор;
		КонецЕсли;
		
		Если Не СтрНайти(НаборСимволов, Символ) Тогда 
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Сред(Строка, НачальныйИндекс, Индекс - НачальныйИндекс); 
	
	Если СмещатьИндекс Тогда
		НачальныйИндекс = Индекс;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает набор символов букв русского и английского языков
// Возвращаемое значение:
//   Строка - Набор символов букв
Функция УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы()
	
	НаборСимволовРусскиеБуквы = "ЙЦУКЕ" + Символ(1025) + "НГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"; //1025 - Код символа буквы ежик, елка
	НаборСимволовРусскиеБуквы = НаборСимволовРусскиеБуквы + НРег(НаборСимволовРусскиеБуквы);
	
	Возврат НаборСимволовРусскиеБуквы + УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы();
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы()
	
	НаборСимволов = "QWERTYUIOPASDFGHJKLZXCVBNM";
	Возврат НаборСимволов + НРег(НаборСимволов);
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
