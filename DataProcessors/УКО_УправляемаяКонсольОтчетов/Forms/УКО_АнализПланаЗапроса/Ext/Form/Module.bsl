#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, СтрШаблон(НСтр("ru = 'План выполнения запроса (%1)'; en = 'The execution plan of a query (%1)'"), Параметры.Имя));
	
	СписокВыбора = Элементы.ОтображатьВТерминах.СписокВыбора;
	СписокВыбора.Добавить("1С", НСтр("ru = '1С'; en = '1С'"));
	СписокВыбора.Добавить("СУБД", НСтр("ru = 'СУБД'; en = 'DBMS'"));
	ОтображатьВТерминах = "1С";
	
	ЗаполнитьДанныеИзТехнологическогоЖурнала(Параметры.ИмяФайла, Строка(Параметры.UID));
	
	СортироватьПланЗапросаПо = ОбъектОбработки().УКО_АнализПланаЗапроса_ЗаполнитьСписокСортировкиПлана(Элементы.СортироватьПланЗапросаПо, ТипСУБД);
	СортироватьПланЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоДанных

&НаКлиенте
Процедура ПланЗапросаПриАктивизацииСтроки(Элемент)
	
	ОбновитьЭлементыУправления();

КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВТерминахПриИзменении(Элемент)
	
	ОбновитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПланЗапросаПоПриИзменении(Элемент)
	
	СортироватьПланЗапроса();
	РаскрытьВеткиДереваВСоответствииСДанными (ПланЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПланЗапроса

&НаКлиенте
Процедура ПланЗапросаПередРазворачиванием(Элемент, Строка, Отказ)
	
	СтрокаДанных = ПланЗапроса.НайтиПоИдентификатору(Строка);
	СтрокаДанных.Развернуто = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПланЗапросаПередСворачиванием(Элемент, Строка, Отказ)

	СтрокаДанных = ПланЗапроса.НайтиПоИдентификатору(Строка);
	Если СтрокаДанных <> Неопределено Тогда
		СтрокаДанных.Развернуто = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	СвернутьВсеСтроки(ПланЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	Для Каждого Строка Из ПланЗапроса.ПолучитьЭлементы() Цикл 
		Элементы.ПланЗапроса.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеИзТехнологическогоЖурнала(ПолноеИмяФайла, UIDМетки)
	
	ДеревоПланЗапроса = РеквизитФормыВЗначение("ПланЗапроса");
	
	Результат = ОбъектОбработки().УКО_АнализПланаЗапроса_ПолучитьДанные(ПолноеИмяФайла, UIDМетки, Параметры.ОписанияТиповПараметров);
	ТипСУБД = Результат.ТипСУБД;
		
	Если ЗначениеЗаполнено(Результат.Дерево) Тогда
		
		КореньДерева = Результат.Дерево.Строки[0];

		ЗаполнитьДанныеДерева(КореньДерева, ДеревоПланЗапроса);
		
		Элементы.ПланЗапросаОператор.ТекстПодвала = СтрШаблон(НСтр("ru = 'Всего: %1'; en = 'Total: %1'"), КореньДерева.Количество);
		
		Если ТипСУБД = "Перечисление.УКО_СУБД.Файловая" Тогда
			
			Элементы.ПланЗапросаВремяВыполнения.ТекстПодвала = Формат(КореньДерева.ВремяВыполнения, "ЧН=0,0");
			Элементы.ПланЗапросаВремяРазбора.ТекстПодвала = КореньДерева.ВремяРазбора;
			
		ИначеЕсли ТипСУБД = "Перечисление.УКО_СУБД.MicrosoftSQL" Тогда
			
			Элементы.ПланЗапросаСтоимость.ТекстПодвала = КореньДерева.Стоимость;
			Элементы.ПланЗапросаЗатратыВводВывод.ТекстПодвала = КореньДерева.ЗатратыВводВывод;
			Элементы.ПланЗапросаЗагрузкаЦП.ТекстПодвала = КореньДерева.ЗагрузкаЦП;
			
		ИначеЕсли ТипСУБД = "Перечисление.УКО_СУБД.PostgreSQL" Тогда
			
			Элементы.ПланЗапросаСтоимость1.ТекстПодвала = КореньДерева.Стоимость;
			
		КонецЕсли;
		
		SQLТекстЗапроса = КореньДерева.SQLЗапрос;
		SQLТекстЗапроса1C = КореньДерева.SQLЗапрос1С;

	КонецЕсли;
	
	// Оформление строк
	УсловноеОформление.Элементы.Очистить();
	ОформитьМусорныеСтроки(ДеревоПланЗапроса);
	ОформитьНезначимыеСтроки(ДеревоПланЗапроса, ТипСУБД);
	
	Если ТипСУБД = "Перечисление.УКО_СУБД.Файловая" Тогда
		ИмяПоляСтоимость = "ВремяВыполнения";
	ИначеЕсли ТипСУБД = "Перечисление.УКО_СУБД.MicrosoftSQL" Тогда
		ОформитьПолеДанныеСтрок(ДеревоПланЗапроса);
		ИмяПоляСтоимость = "Стоимость";
	ИначеЕсли ТипСУБД = "Перечисление.УКО_СУБД.PostgreSQL" Тогда
		ИмяПоляСтоимость = "Стоимость";
	КонецЕсли;
	
	ОформитьСамыеДорогиеСроки(ДеревоПланЗапроса, ИмяПоляСтоимость);
	
	ЗначениеВРеквизитФормы(ДеревоПланЗапроса, "ПланЗапроса");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеДерева(СтрокаИсточник, СтрокаПриемник)
	
	Для Каждого Строка Из СтрокаИсточник.Строки Цикл 
		НоваяСтрока = СтрокаПриемник.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		ЗаполнитьДанныеДерева(Строка, НоваяСтрока);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлементыУправления()
	
	ТекущиеДанные = Элементы.ПланЗапроса.ТекущиеДанные;
	ОтображатьВТерминах1С = ОтображатьВТерминах = "1С";
	ОтображатьВТерминахСУБД = ОтображатьВТерминах = "СУБД";
	ЭтоФайловаяСУБД = (ТипСУБД = "Перечисление.УКО_СУБД.Файловая");
	ЭтоMicrosoftSQLСУБД = (ТипСУБД = "Перечисление.УКО_СУБД.MicrosoftSQL");
	ЭтоPostgreSQLСУБД = (ТипСУБД = "Перечисление.УКО_СУБД.PostgreSQL");
	ИерархияПланаЗапроса = Не ЭтоФайловаяСУБД;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ОтображатьВТерминах1С Тогда
			ОписаниеОператора = ТекущиеДанные.План1С;
		Иначе
			ОписаниеОператора = ТекущиеДанные.План;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОтображатьВТерминах1С Тогда
		ТекстЗапроса = SQLТекстЗапроса1C;
	Иначе
		ТекстЗапроса = SQLТекстЗапроса;
	КонецЕсли;
	
	Элементы.ПланЗапросаКонтекст.Видимость  = ОтображатьВТерминахСУБД;
	Элементы.ПланЗапросаКонтекст1С.Видимость  = ОтображатьВТерминах1С;
	
	Элементы.ПланЗапросаГруппаПоказателиФайловойСУБД.Видимость = ЭтоФайловаяСУБД;
	Элементы.ПланЗапросаГруппаПоказателиMicrosoftSQLСУБД.Видимость = ЭтоMicrosoftSQLСУБД;
	Элементы.ПланЗапросаГруппаПоказателиPostgreSQLСУБД.Видимость = ЭтоPostgreSQLСУБД;

	Элементы.СвернутьВсе.Видимость = ИерархияПланаЗапроса;
	Элементы.РазвернутьВсе.Видимость = ИерархияПланаЗапроса;

КонецПроцедуры

&НаСервере
Процедура СортироватьПланЗапроса()
	
	// Сортировка планов
	Если СортироватьПланЗапросаПо = "Стоимости" Тогда
		Сортировка = "Стоимость Убыв";
	ИначеЕсли СортироватьПланЗапросаПо = "ВремениВыполнения" Тогда
		Сортировка = "ВремяВыполнения Убыв";
	ИначеЕсли СортироватьПланЗапросаПо = "Порядку" Тогда
		Сортировка = "НомерСтроки Возр";
	ИначеЕсли СортироватьПланЗапросаПо = "ВремениВводаВывода" Тогда
		Сортировка = "ЗатратыВводВывод Убыв";
	КонецЕсли;
	
	ДеревоПланЗапроса = РеквизитФормыВЗначение("ПланЗапроса");
	ДеревоПланЗапроса.Строки.Сортировать(Сортировка, Истина);
	ЗначениеВРеквизитФормы(ДеревоПланЗапроса, "ПланЗапроса");
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсеСтроки(Строка)
	
	Для Каждого ВложеннаяСтрока Из Строка.ПолучитьЭлементы() Цикл 
		СвернутьВсеСтроки(ВложеннаяСтрока);
		Элементы.ПланЗапроса.Свернуть(ВложеннаяСтрока.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьМусорныеСтроки(Строка)
	
	Для Каждого ВложеннаяСтрока Из Строка.Строки Цикл 
		
		ОформитьМусорныеСтроки(ВложеннаяСтрока);
		
		Если СтрНачинаетсяС(ВложеннаяСтрока.Контекст, "Config.") Тогда
			
			ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ПланЗапроса", Новый Структура("ЦветТекста", WebЦвета.Серый), "ПланЗапроса.UID", ВложеннаяСтрока.UID);
				
			// Дополнительно также оформим родителей строки, если в них по одной строке
			Родитель = ВложеннаяСтрока.Родитель;
			Пока Родитель <> Неопределено Цикл 
				
				Если Родитель.Строки.Количество() = 1 Тогда
					ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ПланЗапроса", Новый Структура("ЦветТекста", WebЦвета.Серый), "ПланЗапроса.UID", Родитель.UID);
				Иначе 
					Прервать;
				КонецЕсли;
			
				Родитель = Родитель.Родитель;
				
			КонецЦикла;
			
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьНезначимыеСтроки(Строка, ТипСУБД)
	
	Для Каждого ВложеннаяСтрока Из Строка.Строки Цикл 
		
		Если ТипСУБД = "Перечисление.УКО_СУБД.Файловая" Тогда
			НезначимаяСтрока = (ВложеннаяСтрока.ВремяВыполнения = 0);
		Иначе
			НезначимаяСтрока = (ВложеннаяСтрока.Стоимость = 0);
		КонецЕсли;
		
		Если НезначимаяСтрока Тогда
			ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ПланЗапроса", Новый Структура("ЦветТекста", WebЦвета.Серый), "ПланЗапроса.UID", ВложеннаяСтрока.UID);
		КонецЕсли;
		
		ОформитьНезначимыеСтроки(ВложеннаяСтрока, ТипСУБД);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьПолеДанныеСтрок(Строка)
	
	Для Каждого ВложеннаяСтрока Из Строка.Строки Цикл 
		
		Если ВложеннаяСтрока.СтрокиФакт = 0 Тогда
			Отношение = 1;
		Иначе
			Отношение = ВложеннаяСтрока.СтрокиПлан / ВложеннаяСтрока.СтрокиФакт;
		КонецЕсли;

		Если ЗначениеЗаполнено(Отношение)
			И ЗначениеЗаполнено(ВложеннаяСтрока.Родитель)
			И (Отношение > 2 ИЛИ Отношение < 0.5)
			И (ВложеннаяСтрока.Оператор <> "Compute Scalar") Тогда
			
			ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ПланЗапросаДанныеСтрок", Новый Структура("ЦветТекста", WebЦвета.Красный), "ПланЗапроса.UID", ВложеннаяСтрока.UID);
		
		КонецЕсли;
		
		ОформитьПолеДанныеСтрок(ВложеннаяСтрока);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьСамыеДорогиеСроки(Строка, ИмяПоляСтоимость)
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("UID");
	ТаблицаЗначений.Колонки.Добавить(ИмяПоляСтоимость);
	
	ОбходДереваПолучениеТаблицыСтрок(Строка, ТаблицаЗначений, ИмяПоляСтоимость);
	
	Если ЗначениеЗаполнено(ТаблицаЗначений) Тогда 
		
		ТаблицаЗначений.Сортировать(СтрШаблон("%1 Убыв", ИмяПоляСтоимость));
		КоличествоВыделяемыхСтрок = Цел(ТаблицаЗначений.Количество()/4);
		КоличествоВыделяемыхСтрок = Макс(КоличествоВыделяемыхСтрок, 1);
		
		Для ИндексСтроки = 0 По КоличествоВыделяемыхСтрок - 1 Цикл 
			
			ОбъектОбработки().УКО_Формы_ДобавитьУсловноеОформление(УсловноеОформление, "ПланЗапроса", Новый Структура("Шрифт", УКО_ОбщегоНазначенияКлиентСервер_ШрифтЖирный120()),
																	"ПланЗапроса.UID", ТаблицаЗначений[ИндексСтроки].UID);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбходДереваПолучениеТаблицыСтрок(Строка, ТаблицаЗначений, ИмяПоляСтоимость)
	
	Для Каждого ВложеннаяСтрока Из Строка.Строки Цикл 
		
		ОбходДереваПолучениеТаблицыСтрок(ВложеннаяСтрока, ТаблицаЗначений, ИмяПоляСтоимость);
		
		Если ЗначениеЗаполнено(ВложеннаяСтрока[ИмяПоляСтоимость]) Тогда
			НоваяСтрока = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВложеннаяСтрока);
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьВеткиДереваВСоответствииСДанными (Строка)
	
	Для Каждого ВложеннаяСтрока Из Строка.ПолучитьЭлементы() Цикл
		
		Если ВложеннаяСтрока.Развернуто Тогда
			Элементы.ПланЗапроса.Развернуть(ВложеннаяСтрока.ПолучитьИдентификатор());
		Иначе
			Элементы.ПланЗапроса.Свернуть(ВложеннаяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		
		РаскрытьВеткиДереваВСоответствииСДанными (ВложеннаяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
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
// Чтение строки до символа
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   Символ - Строка - Стоп символ
//   НачальныйИндекс - Число - Начальный индекс
//   Направление - НаправлениеПоиска - Направление поиска (по умолчанию: НаправлениеПоиска.СНачала)
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Строка	- Прочитанная строка до стоп символа
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьДоСимвола(Строка, Символ, НачальныйИндекс = Неопределено, Направление = Неопределено, СмещатьИндекс = Истина) Экспорт
	
	Если Направление = Неопределено Тогда
		Индекс = СтрНайти(Строка, Символ, , НачальныйИндекс);
	Иначе
		Индекс = СтрНайти(Строка, Символ, Направление, НачальныйИндекс);
	КонецЕсли;
	
	Если Направление = НаправлениеПоиска.СКонца Тогда
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = СтрДлина(Строка);
		КонецЕсли;
		
		Результат = Сред(Строка, Индекс + 1, НачальныйИндекс - Индекс); 
		
	Иначе
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = 1;
		КонецЕсли;
		
		Результат = Сред(Строка, НачальныйИндекс, Индекс - НачальныйИндекс); 
		
	КонецЕсли;
	
	Если СмещатьИндекс Тогда
		НачальныйИндекс = Индекс;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает Описание типов строка)
// Параметры:
//   ДлинаСтроки - Число - Длина строки
// Возвращаемое значение:
//   ОписаниеТипов - Описание типов строка
Функция УКО_ОбщегоНазначенияКлиентСервер_ОписаниеТиповСтрока(ДлинаСтроки = 0) Экспорт
	
	Возврат Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаСтроки));
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает Описание типов Число
// Параметры:
//   ЧислоРазрядов - Число - Число разрядов
//   ЧислоРазрядовДробнойЧасти - Число - Число разрядов дробной части
// Возвращаемое значение:
//   ОписаниеТипов - Описание типов Число
Функция УКО_ОбщегоНазначенияКлиентСервер_ОписаниеТиповЧисло(ЧислоРазрядов = 0, ЧислоРазрядовДробнойЧасти = 0) Экспорт
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(ЧислоРазрядов, ЧислоРазрядовДробнойЧасти));
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Прочитать блок, PlanSQL='select'
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачалоБлока - Строка - Текст начала читаемого блока
//   КонецБлока - Строка - Текст конца читаемого блока
//   НачальныйИндекс - Число - Начальный индекс
//
// Возвращаемое значение:
//   Булево	- Истина, Искомый текст найден
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьБлок(Строка, НачалоБлока, КонецБлока, НачальныйИндекс = 1) Экспорт
	
	Результат = "";
	Если УКО_СтрокиКлиентСервер_РазборНайтиТекст(Строка, НачалоБлока, НачальныйИндекс) Тогда
		
		СимволБлока = УКО_СтрокиКлиентСервер_РазборПрочитатьСимвол(Строка, НачальныйИндекс, Ложь);
		Если СимволБлока = Символ(34) ИЛИ СимволБлока = "'" Тогда
			УКО_СтрокиКлиентСервер_РазборПропуститьНаборСимволов(Строка, СимволБлока, НачальныйИндекс);
		Иначе
			СимволБлока = "";
		КонецЕсли;
		
		ИндексНачалаБлока = НачальныйИндекс;
		ИскомыйТекстКонецБлока = СимволБлока + КонецБлока;
		УКО_СтрокиКлиентСервер_РазборНайтиТекст(Строка, ИскомыйТекстКонецБлока, НачальныйИндекс);
		ИндексКонцаБлока = НачальныйИндекс - СтрДлина(ИскомыйТекстКонецБлока);
		
		Результат = Сред(Строка, ИндексНачалаБлока, ИндексКонцаБлока - ИндексНачалаБлока);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает пустой UID "00000000000000000000000000000000"
//
// Возвращаемое значение:
//   Строка - Пустой UID
//
Функция УКО_СтрокиКлиентСервер_ПустойUID() Экспорт
	
	Возврат "00000000000000000000000000000000";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_РазборПропуститьСимвол(Строка, Символ, НачальныйИндекс, СмещатьИндекс = Истина)
	
	Результат = "";
	
	Если Сред(Строка, НачальныйИндекс, 1) = Символ Тогда
		
		Результат = Символ;
		
		Если СмещатьИндекс Тогда
			НачальныйИндекс = НачальныйИндекс + 1;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Чтение набора символов
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НаборСимволов - Строка - Набор символов
//   НачальныйИндекс - Число - Начальный индекс
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Строка	- Прочитанная строка
//
Функция УКО_СтрокиКлиентСервер_РазборПропуститьНаборСимволов(Строка, НаборСимволов, НачальныйИндекс = 1, СмещатьИндекс = Истина) Экспорт
	
	Результат = "";
	
	Для Индекс = 1 По СтрДлина(НаборСимволов) Цикл 
		Результат = Результат + УКО_СтрокиКлиентСервер_РазборПропуститьСимвол (Строка, Сред(НаборСимволов, Индекс, 1), НачальныйИндекс, СмещатьИндекс);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Найти текст, пропустить
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   Текст - Строка - Искомый текст
//   НачальныйИндекс - Число - Начальный индекс
//   НомерВхождения - Число - Номер вхождения
//
// Возвращаемое значение:
//   Булево	- Истина, Искомый текст найден
//
Функция УКО_СтрокиКлиентСервер_РазборНайтиТекст(Строка, Текст, НачальныйИндекс = 1, НомерВхождения = 1) Экспорт
	
	Индекс = СтрНайти(Строка, Текст,, НачальныйИндекс, НомерВхождения);
	Если ЗначениеЗаполнено(Индекс) Тогда
		УКО_СтрокиКлиентСервер_РазборПропуститьНаборСимволов(Строка, Текст, Индекс);
		НачальныйИндекс = Индекс;
		Возврат Истина
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Чтение символа
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачальныйИндекс - Число - Начальный индекс
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Строка	- Прочитанный символ
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьСимвол(Строка, НачальныйИндекс = 1, СмещатьИндекс = Истина) Экспорт
	
	Результат = Сред(Строка, НачальныйИндекс, 1);
	
	Если СмещатьИндекс Тогда
		НачальныйИндекс = НачальныйИндекс + 1;
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

Функция УКО_СтрокиКлиентСервер_НаборСимволовЦифры()
	
	Возврат "0123456789";
	
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
// Чтение шестнадцатеричного числа из строки
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачальныйИндекс - Число - Начальный индекс
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Число	- Прочитанное целое число
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьШестнадцатеричноеЧисло(Строка, НачальныйИндекс = Неопределено, СмещатьИндекс = Истина) Экспорт
	
	Если НачальныйИндекс = Неопределено Тогда
		НачальныйИндекс = 1;
	КонецЕсли;
	
	Для Индекс = НачальныйИндекс По СтрДлина(Строка) Цикл 
		
		Если Не СтрНайти(УКО_СтрокиКлиентСервер_НаборСимволовШестнадцатеричныеЦифры(), Сред(Строка, Индекс, 1)) Тогда 
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
// Чтение целого число из строки
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачальныйИндекс - Число - Начальный индекс
//   Направление - НаправлениеПоиска - Направление поиска (по умолчанию: НаправлениеПоиска.СНачала)
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Число	- Прочитанное целое число
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьЦелоеЧисло(Строка, НачальныйИндекс = Неопределено, Направление = Неопределено, СмещатьИндекс = Истина) Экспорт
	
	Если Направление = НаправлениеПоиска.СКонца Тогда
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = СтрДлина(Строка);
		КонецЕсли;
		
		Индекс = НачальныйИндекс;
		Пока Индекс > 0 Цикл 
			
			Если Не СтрНайти(УКО_СтрокиКлиентСервер_НаборСимволовЦифры(), Сред(Строка, Индекс, 1)) Тогда 
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс - 1;
		КонецЦикла;
		
		Результат = Сред(Строка, Индекс + 1, НачальныйИндекс - Индекс); 
		
	Иначе
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = 1;
		КонецЕсли;
		
		Для Индекс = НачальныйИндекс По СтрДлина(Строка) Цикл 
			
			Если Не СтрНайти(УКО_СтрокиКлиентСервер_НаборСимволовЦифры(), Сред(Строка, Индекс, 1)) Тогда 
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Результат = Сред(Строка, НачальныйИндекс, Индекс - НачальныйИндекс); 
		
	КонецЕсли;
	
	Если СмещатьИндекс Тогда
		НачальныйИндекс = Индекс;
	КонецЕсли;
	
	Возврат Число(Результат);
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Чтение незначащих символов (пробел, табуляция, перенос строки)
//
// Параметры:
//   Строка - Строка - Разбираемая строка
//   НачальныйИндекс - Число - Начальный индекс
//   Направление - НаправлениеПоиска - Направление поиска (по умолчанию: НаправлениеПоиска.СНачала)
//   СмещатьИндекс - Булево - Смещать индекс (по умолчанию: Истина)
//
// Возвращаемое значение:
//   Строка	- Прочитанные незначимые символы
//
Функция УКО_СтрокиКлиентСервер_РазборПрочитатьНезначимые(Строка, НачальныйИндекс = Неопределено, Направление = Неопределено, СмещатьИндекс = Истина) Экспорт
	
	Если Направление = НаправлениеПоиска.СКонца Тогда
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = СтрДлина(Строка);
		КонецЕсли;
		
		Индекс = НачальныйИндекс;
		Пока Индекс > 0 Цикл 
			
			Если Не СтрНайти(УКО_СтрокиКлиентСервер_НаборСимволовЦифры(), Сред(Строка, Индекс, 1)) Тогда 
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс - 1;
		КонецЦикла;
		
		Результат = Сред(Строка, Индекс + 1, НачальныйИндекс - Индекс); 
		
	Иначе
		
		Если НачальныйИндекс = Неопределено Тогда
			НачальныйИндекс = 1;
		КонецЕсли;
		
		Для Индекс = НачальныйИндекс По СтрДлина(Строка) Цикл 
			
			Если Не СтрНайти(УКО_СтрокиКлиентСервер_НаборНезначащихСимволов(), Сред(Строка, Индекс, 1)) Тогда 
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Результат = Сред(Строка, НачальныйИндекс, Индекс - НачальныйИндекс); 
		
	КонецЕсли;
	
	Если СмещатьИндекс Тогда
		НачальныйИндекс = Индекс;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает фрагмент текста запроса, отделяющего один запрос от другого (используется в пакетных запросах).
//
// Возвращаемое значение:
//  Строка - разделитель запросов. ///////////////////////////////////////////////////////////////////////////////
//
Функция УКО_ЗапросКлиентСервер_РазделительПакетов() Экспорт
	
	Возврат "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборНезначащихСимволов()
	
	Возврат Символы.ПС + Символы.ВК + Символы.Таб + " ";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает число из строки 36-E6 в 0.000006
//
// Параметры:
//   Строка - Строка - Экспоненциальное число
//
// Возвращаемое значение:
//   Число - Число
//
Функция УКО_СтрокиКлиентСервер_ЭкспоненциальноеЧисло(Строка) Экспорт

	Результат = 0;
	Строка = ВРег(СокрЛП(Строка));
	Если СтрДлина(Строка) > 0 Тогда 
		
		ИндексЭкспоненты  = СтрНайти(Строка, "E");
		Если ИндексЭкспоненты = 0 Тогда 
			
			Результат = Число(Строка);
			
		Иначе
			
			ЧислоДоЭкспоненты = Число(Лев(Строка, ИндексЭкспоненты - 1));
			ЧислоПослеЭкспоненты = Число(Сред(Строка, ИндексЭкспоненты + 1));
			Результат =  ЧислоДоЭкспоненты * Pow(10 ,ЧислоПослеЭкспоненты);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовШестнадцатеричныеЦифры()
	
	Возврат "0123456789ABCDEFabcdef";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает шрифт жирный 120%
// Возвращаемое значение:
//   Шрифт - Шрифт
Функция УКО_ОбщегоНазначенияКлиентСервер_ШрифтЖирный120() Экспорт
	Возврат Новый Шрифт(,,Истина,,,,120);
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
