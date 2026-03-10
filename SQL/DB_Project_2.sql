SELECT * FROM dim_channel; 
SELECT COUNT(*) FROM dim_date;
SELECT COUNT(*) FROM dim_customers;
SELECT COUNT(*) FROM dim_category;
SELECT COUNT(*) FROM dim_products;
DESC fact_sales;
DROP TABLE fact_sales CASCADE CONSTRAINTS;

CREATE TABLE fact_sales (
    sale_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    customer_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    unit_price NUMBER(10,2),
    total_amount NUMBER(10,2),

    CONSTRAINT fk_sales_date
        FOREIGN KEY (date_id) REFERENCES dim_date(date_id),

    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
);

SELECT MIN(date_id), MAX(date_id), COUNT(*)
FROM dim_date;

SELECT date_id
FROM dim_date;

SELECT DISTINCT product_id
FROM FACT_SALES
WHERE product_id NOT IN (
    SELECT product_id FROM DIM_PRODUCTS
);

SELECT table_name
FROM user_tables
ORDER BY table_name;

SELECT DISTINCT date_id
FROM FACT_SALES
WHERE date_id NOT IN (
    SELECT date_id FROM DIM_DATE
);

DESC fact_sales;

SELECT MIN(product_id), MAX(product_id), COUNT(*)
FROM DIM_PRODUCTS;

SELECT MIN(customer_id), MAX(customer_id), COUNT(*)
FROM DIM_CUSTOMERS;

SELECT trigger_name, status
FROM user_triggers
WHERE table_name = 'FACT_SALES';

SELECT sequence_name
FROM user_sequences
WHERE sequence_name = 'SEQ_FACT_SALES';

CREATE OR REPLACE TRIGGER TRG_FACT_SALES_ID
BEFORE INSERT ON FACT_SALES
FOR EACH ROW
BEGIN
    IF :NEW.SALE_ID IS NULL THEN
        SELECT SEQ_FACT_SALES.NEXTVAL
        INTO :NEW.SALE_ID
        FROM dual;
    END IF;
END;
/

SELECT last_number
FROM user_sequences
WHERE sequence_name = 'SEQ_FACT_SALES';

SELECT * 
FROM DIM_DATE
WHERE DATE_ID = 20230101;

SELECT COUNT(*) FROM DIM_CUSTOMERS;

SELECT MIN(DATE_ID), MAX(DATE_ID)
FROM DIM_DATE;

SELECT DISTINCT DATE_ID
FROM FACT_SALES
WHERE DATE_ID NOT IN (
    SELECT DATE_ID
    FROM DIM_DATE
);

SELECT COUNT(*)
FROM DIM_DATE
WHERE DATE_ID = 20230101;

INSERT INTO FACT_SALES
(DATE_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, TOTAL_AMOUNT)
VALUES
(20230101, 10, 5, 2, 500, 1000);

SELECT * FROM FACT_SALES;



