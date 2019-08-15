#______________________________________________________________________________________
/*Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
 * в зависимости от текущего времени суток. 
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", 
 * с 00:00 до 6:00 — "Доброй ночи".
*/

delimiter //
drop function if exists hello//

create function hello(time_ TIME)
returns varchar(15) deterministic
begin
	declare word varchar(15);
	if (time_ >= '06:00:00' and time_ <'12:00:00') then set word = 'Доброе утро!';
	elseif (time_ >= '12:00:00' and time_ <'18:00:00') then set word = 'Добрый день!';
	elseif (time_ >= '18:00:00' and time_ <='23:59:59') then set word = 'Добрый вечер!';
	else set word = 'Доброй ночи!';
	end if;
return word;
end//

select hello('07:09:56')// # доброе утро!
select hello('4:00:00')// # доброй ночи!
select hello('12:00:00')// # добрый день!
select hello('19:30:00')// # добрый вечер
select hello('17:59:59')// # добрый день!
delimiter ;

#______________________________________________________________________________________
/*В таблице products есть два текстовых поля: name с названием товара 
 * и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

delimiter //
use shop//
# триггер на создание записи
drop trigger if exists not_null_create//
create trigger not_null_create before insert on products
for each row
begin
	declare name_def varchar(255) default 'name';
	declare descrip varchar(255) default 'description';
	set new.name = coalesce (new.name, name_def);
	set new.description = coalesce (new.description, descrip);
end//

# триггер на обновление записи
drop trigger if exists not_null_update//
create trigger not_null_update before update on products
for each row
begin
	declare name_def varchar(255) default 'name';
	declare descrip varchar(255) default 'description';
	set new.name = coalesce (new.name, old.name, name_def);
	set new.description = coalesce (new.description, old.description, descrip);
end//
delimiter ;

#______________________________________________________________________________________
/*(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 * Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 * Вызов функции FIBONACCI(10) должен возвращать число 55.
 */
delimiter //
use sample//

drop function if exists fibonacci//

create function fibonacci(num int)
returns int deterministic
begin
	declare x int default 0; # переменная для итерации в рамках num
	declare fib int default 0; # переменная для сохранения суммы
	while x <= num do
		set fib = fib + x; # подсчитываем сумму на каждой итерации
		set x = x+1; # увеличиваем "счетчик"
	end while;
return fib;
	
end//


select fibonacci(5), fibonacci(10)//









