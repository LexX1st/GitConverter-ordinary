
&Вместо("ИмпортироватьВерсиюВEDT")
Процедура Ordinary_ИмпортироватьВерсиюВEDT(ВерсияХранилища, Параметры) Экспорт
	
	Попытка
		ПродолжитьВызов(ВерсияХранилища, Параметры);
	Исключение
		
		Если ЭтоОшибкаОбычноегоПриложения(Параметры) Тогда
			// Копируем файл дампа в каталог проекта EDT чтобы был доступен для формирования частичной выгрузки
			ИмяФайлаИсточника = Параметры.КаталогВременныхФайлов + "ConfigDumpInfo.xml";
			ИмяФайлаПриемника = Параметры.КаталогФайловПроекта + "ConfigDumpInfo.xml";
			Файл = Новый Файл(ИмяФайлаИсточника);
			Если Файл.Существует() Тогда
				КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
			КонецЕсли;
		Иначе
			ВызватьИсключение СтрШаблон(НСтр("ru = 'При импорте в 1C:EDT возникли ошибки. Подробнее см. файл лога:
				|%1'", Параметры.ИмяФайлаЛогов));
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

// Зачитывает лог, чтобы убедиться что это ошибка конвертации обычного приложения
// 
// Параметры:
// 	Параметры - Описание
// Возвращаемое значение:
// 	Описание
Функция ЭтоОшибкаОбычноегоПриложения(Параметры)
	
	ФайлЛога = Новый ТекстовыйДокумент();
	ФайлЛога.Прочитать(Параметры.ИмяФайлаЛогов, КодировкаТекста.UTF8);
	
	НомерСтроки = ФайлЛога.КоличествоСтрок();
	ЗачитыватьСтрок = 7;
	
	ПрочинаоСтрок = 0;
	
	Пока НомерСтроки > 0 И ПрочинаоСтрок < ЗачитыватьСтрок  Цикл
		СтрокаЛога = ФайлЛога.ПолучитьСтроку(НомерСтроки);
		НомерСтроки = НомерСтроки -1;
		ПрочинаоСтрок = ПрочинаоСтрок + 1;
		
		Если ПустаяСтрока(СтрокаЛога) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрНайти(СтрокаЛога, "Основной режим запуска ""OrdinaryApplication"" не поддерживаются.") Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции
