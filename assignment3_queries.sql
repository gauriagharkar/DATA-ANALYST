/* Assignment No:03 */ 

use assignment;
select *from orders;

/* Que.01 */ 

DELIMITER //
CREATE PROCEDURE order_status(month1 varchar(20), year1 int)
BEGIN
select orderNumber,orderDate,status from orders
where year(orderdate)=year1 and month(orderDate)=month1;
END //
DELIMITER ;
call order_status(01,2004); /* Month 01-Jan , Year 2004 */

call order_status(04,2005); /* Month 04-April , Year 2005 */

/* Que.02 */ 

select*from customers;

select*from orders;

DELIMITER //
CREATE PROCEDURE cancel()
BEGIN
Create table if not exists cancellations(
id int PRIMARY KEY auto_increment,
customernumber int, FOREIGN KEY(customerNumber)REFERENCES customers(customerNumber),
orderNumber int, FOREIGN KEY(orderNumber)REFERENCES orders(orderNumber));
insert into cancellations(customernumber,orderNumber)
select customerNumber,orderNumber from orders where status='Cancelled';
END //
DELIMITER ;

call cancel();
select*from cancellations;

/* Que.03 a) */

DELIMITER $$ 
CREATE FUNCTION get_data(customernumber int) RETURNS varchar(200) CHARSET utf8mb4
BEGIN
declare P_status varchar(20);
select 
case
when sum(amount) < 25000 then 'Silver'
when sum(amount) between 25000 and 50000 then 'Gold'
when sum(amount) > 50000 then 'Platinum'
end as purchasestatus
into P_status from payments where customerNumber=customerNumber group by customerNumber;
RETURN P_status;
END $$
DELIMITER ;

select get_data(customerNumber) as total_purchase_status 
from customers;
select customerNumber,customerName,get_data(customerNumber) as total_purchase_status 
from customers;
 
 /* Que.3 b) */
 
 select customers.customerNumber,customerName,
case
when amount < 25000 then 'silver'
when amount between 25000 and 50000 then 'Gold'
when amount > 50000 then 'Platinum'
end as purchasestatus from payments
inner join customers ON payments.customerNumber=customers.customerNumber;
 
/* Que.04 */

select *from movies;
select *from rentals;
 
 /* Update Trigger */
 
DELIMITER //
Create trigger movren_trg_update
AFTER UPDATE on movies for each row 
Begin 
UPDATE rentals SET rentals.movieid=NEW.id
where rentals.movieid=OLD.id;
END;
//

select *from movies;
select *from rentals;

update movies set id=90 where title like 'Marley and me' and category like 'Romance';

select *from movies;
select *from rentals;

/* Delete Trigger */

DELIMITER //
Create trigger movren_trg_delete
AFTER DELETE on movies for each row 
Begin 
DELETE from rentals where rentals.movieid=OLD.id;
END;
//

delete from movies where id=90;

select *from movies;
select *from rentals;

/* Que. 05 */

select * from(
select fname, salary, dense_rank() 
over(order by salary desc)r from employee)a 
where a.r=3;

#IF we have duplicate salary values then rank will skip the next row_num this might create some data issue while fetching the record

select * from(
select fname, salary, rank() 
over(order by salary desc)r from employee)a 
where a.r=3;

/* Que. 06 */

select * from(
select *, dense_rank() 
over(order by salary desc)r from employee)a;
