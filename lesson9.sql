#___________________________________________________________________________________________
/*Создайте таблицу logs типа Archive.  
 *Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается 
 *- время и дата создания записи;
 *- название таблицы;
 *- идентификатор первичного ключа и содержимое поля name.*/
/*
delimiter ||
use shop||
drop table if exists logs||
create table logs (
	id bigint(20) unsigned not null auto_increment,
	created_at datetime default current_timestamp,
	table_name Varchar(20) not null, # название таблицы
	primary_key bigint(20) not null, # первичный ключ
	name varchar(255) not null, # наименование
	primary key (id)
  	
	
	)engine = Archive|| 

# создаем триггер на вставку записей в таблицу users
drop trigger if exists insert_users||
create trigger insert_users after insert on users
for each row
begin
	insert into logs set table_name='users', primary_key=new.id, name = new.name;
end||

# создаем триггер на вставку записей в таблицу catalogs
drop trigger if exists insert_catalogs||
create trigger insert_catalogs after insert on catalogs
for each row
begin
	insert into logs set table_name='catalogs', primary_key=new.id, name = new.name;
end||

# создаем триггер на вставку записей в таблицу products
drop trigger if exists insert_products||
create trigger insert_products after insert on products
for each row
begin
	insert into logs set table_name='products', primary_key=new.id, name = new.name;
end||

# тестовые вставки
insert into catalogs values (default, 'processors')||
insert into users values (default, 'Екатерина', '1978-05-12', default, default)||
insert into products values (default, 'processors', 'processors description', 122312, 3, default, default)||

# просмотр лога
select * from logs||
delimiter ;
*/
#___________________________________________________________________________________________
/*(по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/

delimiter ||
# создадим таблицу users1
drop table if exists users1||
create table users1 (
  id bigint(20) unsigned not null auto_increment,
  name varchar(255) default null COMMENT 'Имя покупателя',
  birthday_at date default null COMMENT 'Дата рождения покупателя',
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp on update current_timestamp,
  primary key (`id`)
) ENGINE=Archive COMMENT='Покупатели'||


drop procedure if exists add_num_rows||

create procedure add_num_rows(num int)
begin
	declare i int default 0;
	while i < num DO
		insert into users1 values (default, concat('user ', i),'1978-05-02',default, default);
		set i = i+1;
	end while;
end||

# в качестве параметра передадим функции требуемое для добавления количество строк (1 000 000 записей добавляется за 15 минут)
# если указываем Engine = InnoDB - время выполнения запроса около 30 минут на 1 000 000 записей.
call add_num_rows(10000)||
select * from users1|| #все записи таблицы users1
select count(*) from users1|| # количество записей таблицы users1
delimiter ;

