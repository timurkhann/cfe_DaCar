﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура тм_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	// TODO: Нужно ли восстанавливать
	//
	// Устанавливаем на создание первым тип номенклатуры "Работа"
	//Если Параметры.Свойство("ДополнительныеПараметры") Тогда
	//	Если Параметры.ДополнительныеПараметры.Свойство("ТипВладельца") Тогда
	//		Если Параметры.ДополнительныеПараметры.ТипВладельца = "ЗаказПокупателя" Тогда
	//			Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
	//				Если Параметры.ЗначенияЗаполнения.Свойство("ТипНоменклатуры") Тогда
	//					ДоступныеТипыНоменклатуры = Новый Массив;
	//					ДоступныеТипыНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Работа);
	//					ДоступныеТипыНоменклатуры.Добавить(Перечисления.ТипыНоменклатуры.Услуга);
	//					Параметры.ЗначенияЗаполнения.ТипНоменклатуры = Новый ФиксированныйМассив(ДоступныеТипыНоменклатуры);
	//				КонецЕсли; 
	//			КонецЕсли; 				
	//		КонецЕсли; 
	//	КонецЕсли; 		          
	//КонецЕсли; 	
	
КонецПроцедуры

&НаСервере
Процедура тм_ПередЗаписьюНаСервереПеред(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
		Возврат;
	КонецЕсли; 
	
	Права = тм_КЭШ.ПолучитьПраваОбъекта("Номенклатура", Пользователи.ТекущийПользователь());
	
	Если Не Права.Запись Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Недостаточно прав на запись номенклатуры";
		Сообщение.Сообщить(); 
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти 
