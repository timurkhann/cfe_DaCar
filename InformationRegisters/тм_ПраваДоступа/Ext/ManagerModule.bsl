
Процедура ЗаписатьВыбранныеЗначения(ВыбранноеЗначение) Экспорт
	
	ВыбранныеПользователи = ВыбранноеЗначение.Пользователи;
	Объекты = СтрРазделить(ВыбранноеЗначение.Объекты, ",", Ложь);
	
	Для каждого Пользователь Из ВыбранныеПользователи Цикл
						
		Для каждого ОбъектЗаписи Из Объекты Цикл
			МЗ = СоздатьМенеджерЗаписи();
			МЗ.Пользователь = Пользователь;
			МЗ.Объект 		= ОбъектЗаписи;
			МЗ.Запись		= ВыбранноеЗначение.Запись;
			МЗ.Чтение		= ВыбранноеЗначение.Чтение;
			МЗ.SA			= ВыбранноеЗначение.SA;			
			МЗ.Записать();
		КонецЦикла;  
		
	КонецЦикла;  
		
КонецПроцедуры // ЗаписатьВыбранныеЗначения()

