
Процедура ЗафиксироватьВремяОткрытия(ПараметрыЗаписи) Экспорт

	МЗ = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, ПараметрыЗаписи);
	МЗ.Записать();
	
КонецПроцедуры
 
Процедура УдалитьЗапись(ПараметрыУдаления) Экспорт

	НЗ = СоздатьНаборЗаписей();
	
	Отбор = НЗ.Отбор;
	Отбор.УникальныйИдентификатор.Использование = Истина;
	Отбор.УникальныйИдентификатор.Значение = ПараметрыУдаления.УникальныйИдентификатор;
	
	НЗ.Прочитать();
	НЗ.Очистить();
	НЗ.Записать();
	
КонецПроцедуры

Функция ПолучитьИнформациюПоДокументу(ПараметрыЗапроса) Экспорт

	НЗ = СоздатьНаборЗаписей();
	
	Отбор = НЗ.Отбор;
	Отбор.УникальныйИдентификатор.Использование = Истина;
	Отбор.УникальныйИдентификатор.Значение = ПараметрыЗапроса.УникальныйИдентификатор;
	НЗ.Прочитать();
	
	Если НЗ.Количество() = 0 Тогда
		Пользователь = Справочники.Пользователи.ПустаяСсылка();
	Иначе
		Пользователь = НЗ[0].Пользователь;
	КонецЕсли; 
	 	 
	Возврат Пользователь;

КонецФункции // ()
 
 
