--retrieving the list of orders along with the customer name and staff name for each order.
SELECT
    o.order_id,
    (SELECT CONCAT(first_name, ' ', last_name) FROM sales.customers WHERE customer_id = o.customer_id) AS customer_name,
    (SELECT CONCAT(first_name, ' ', last_name) FROM sales.staffs WHERE staff_id = o.staff_id) AS staff_name
FROM
    sales.orders o;



	--Create a view that returns the total quantity and sales amount for each product
	CREATE VIEW production.product_sales AS
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.list_price) AS sales_amount
FROM
    production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id, p.product_name;


	---Creation of a stored procedure that accepts a customer ID and returns the total number of orders placed by that customer.
	CREATE PROCEDURE GetTotalOrdersByCustomer
    @customerID INT,
    @totalOrders INT OUTPUT
AS
BEGIN
    SELECT @totalOrders = COUNT(*) 
    FROM sales.orders
    WHERE customer_id = @customerID;
END;



---Query to find the top 5 customers who have placed the most orders.
SELECT TOP 5
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(*) AS total_orders
FROM
    sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    total_orders DESC;



---Create a view that shows the product details along with the total sales quantity and revenue for each product.
CREATE VIEW production.product_sales_summary AS
SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    p.category_id,
   
