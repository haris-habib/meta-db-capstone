TASK 1
CREATE VIEW OrdersView AS (
SELECT o.order_id , o.quantity , o.quantity*m.price total_cost
FROM orders as o LEFT JOIN menus as m ON o.item_id = m.item_id
);

SELECT * FROM OrdersView;

TASK 2
SELECT c.customer_id , CONCAT(c.first_name , " " , c.last_name) as "full name" , o.order_id , o.quantity*m.price as total_cost, m.name , t.name 
FROM customers as c 
INNER JOIN bookings as b ON b.customer_id = c.customer_id
INNER JOIN tables as tb ON b.table_id = tb.table_id
INNER JOIN orders as o on b.booking_id= o.booking_id
INNER JOIN menus as m on o.item_id = m.item_id
INNER JOIN meal_type as t on m.type_id = t.type_id;



SELECT name from meal_type WHERE name = any (SELECT meal_type.name from orders inner join menus 
on orders.item_id =  menus.item_id inner join meal_type on menus.type_id = meal_type.type_id where quantity >= 2)


DELIMITER //
CREATE PROCEDURE CheckTableBooking(IN date_time DATETIME, IN table_no INT)
BEGIN 
    SELECT 
        CASE  
            WHEN EXISTS(
                SELECT booking_date, table_id 
                FROM bookings 
                WHERE table_id = table_no AND booking_date = date_time
            ) THEN 
                 "The table is already booked" 
            ELSE 
                 "The table is not yet booked"
         END as result;
END //
DELIMITER ;


call checktablebooking("2024-01-18 08:00:00" , 1)

DELIMITER //

CREATE PROCEDURE addbooking(IN customerid INT, IN date_time DATETIME, IN table_no INT)
BEGIN
    START TRANSACTION;

    INSERT INTO bookings (customer_id, booking_date, table_id)
    VALUES (customerid, date_time, table_no);

    IF customerid = ALL (SELECT customer_id FROM bookings WHERE booking_date = date_time AND table_id = table_no) THEN
        SELECT 'The booking is confirmed';
        COMMIT;
    ELSE
        SELECT 'The table is booked by someone else';
        ROLLBACK;
    END IF;

END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE cancelbooking(IN id INT)
BEGIN
    DELETE FROM bookings WHERE booking_id = id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE maxquantity()
BEGIN
    SELECT MAX(quantity) , item_id FROM Orders;
END //

DELIMITER ;



