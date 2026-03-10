//DIMENSIONES

//Tabla Category
CREATE TABLE dim_category (
    category_id   NUMBER PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL
);
//Secuencia
CREATE SEQUENCE seq_dim_category START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
//Trigger
CREATE OR REPLACE TRIGGER trg_dim_category BEFORE
    INSERT ON dim_category
    FOR EACH ROW
BEGIN
    SELECT
        seq_dim_category.NEXTVAL
    INTO :new.category_id
    FROM
        dual;

END;
/

//Tabla Región
CREATE TABLE dim_region (
    region_id   NUMBER PRIMARY KEY,
    region_name VARCHAR2(100) NOT NULL
);
//Secuencia
CREATE SEQUENCE seq_dim_region START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
//Trigger
CREATE OR REPLACE TRIGGER trg_dim_region BEFORE
    INSERT ON dim_region
    FOR EACH ROW
BEGIN
    SELECT
        seq_dim_region.NEXTVAL
    INTO :new.region_id
    FROM
        dual;

END;
/

//Tabla Channel
CREATE TABLE dim_channel (
    channel_id   NUMBER PRIMARY KEY,
    channel_name VARCHAR2(50) NOT NULL
);
//Secuencia
CREATE SEQUENCE seq_dim_channel START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
//Trigger
CREATE OR REPLACE TRIGGER trg_dim_channel BEFORE
    INSERT ON dim_channel
    FOR EACH ROW
BEGIN
    SELECT
        seq_dim_channel.NEXTVAL
    INTO :new.channel_id
    FROM
        dual;

END;
/

//Tabla Customers
CREATE TABLE dim_customers (
    customer_id       NUMBER PRIMARY KEY,
    full_name         VARCHAR2(150),
    gender            VARCHAR2(10),
    age               NUMBER,
    city              VARCHAR2(100),
    registration_date DATE,
    customer_segment  VARCHAR2(50)
);
//Secuencia
CREATE SEQUENCE seq_dim_customers START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
//Trigger
CREATE OR REPLACE TRIGGER trg_dim_customers BEFORE
    INSERT ON dim_customers
    FOR EACH ROW
BEGIN
    SELECT
        seq_dim_customers.NEXTVAL
    INTO :new.customer_id
    FROM
        dual;

END;
/

//Tabla Products
CREATE TABLE dim_products (
    product_id   NUMBER PRIMARY KEY,
    product_name VARCHAR2(150) NOT NULL,
    category_id  NUMBER,
    brand        VARCHAR2(100),
    price        NUMBER(10, 2),
    cost         NUMBER(10, 2),
    CONSTRAINT fk_category FOREIGN KEY ( category_id )
        REFERENCES dim_category ( category_id )
);
//Secuencia
CREATE SEQUENCE seq_dim_products START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
//Trigger
CREATE OR REPLACE TRIGGER trg_dim_products BEFORE
    INSERT ON dim_products
    FOR EACH ROW
BEGIN
    SELECT
        seq_dim_products.NEXTVAL
    INTO :new.product_id
    FROM
        dual;

END;
/

//Tabla Date
CREATE TABLE dim_date (
    date_id    NUMBER PRIMARY KEY,
    full_date  DATE,
    day        NUMBER,
    month      NUMBER,
    month_name VARCHAR2(20),
    quarter    NUMBER,
    year       NUMBER,
    week_day   VARCHAR2(20)
);

//Tabla de Hechos
CREATE TABLE fact_sales (
    sale_id     NUMBER PRIMARY KEY,
    order_id    NUMBER,
    customer_id NUMBER,
    product_id  NUMBER,
    date_id     NUMBER,
    region_id   NUMBER,
    channel_id  NUMBER,
    quantity    NUMBER,
    unit_price  NUMBER(10, 2),
    discount    NUMBER(5, 2),
    total_sales NUMBER(12, 2),
    cost        NUMBER(12, 2),
    profit      NUMBER(12, 2),
    CONSTRAINT fk_customer FOREIGN KEY ( customer_id )
        REFERENCES dim_customers ( customer_id ),
    CONSTRAINT fk_product FOREIGN KEY ( product_id )
        REFERENCES dim_products ( product_id ),
    CONSTRAINT fk_date FOREIGN KEY ( date_id )
        REFERENCES dim_date ( date_id ),
    CONSTRAINT fk_region FOREIGN KEY ( region_id )
        REFERENCES dim_region ( region_id ),
    CONSTRAINT fk_channel FOREIGN KEY ( channel_id )
        REFERENCES dim_channel ( channel_id )
);
//Secuencia
CREATE SEQUENCE seq_fact_sales START WITH 1 INCREMENT BY 1;
//Trigger
CREATE OR REPLACE TRIGGER trg_fact_sales_id BEFORE
    INSERT ON fact_sales
    FOR EACH ROW
BEGIN
    :new.sale_id := seq_fact_sales.nextval;
END;
/

//INSERTAR DATOS
//Insertar datos en tabla Categoria
INSERT INTO dim_category ( category_name ) VALUES ( 'Electrónica' );

INSERT INTO dim_category ( category_name ) VALUES ( 'Accesorios Tecnológicos' );

INSERT INTO dim_category ( category_name ) VALUES ( 'Hogar Inteligente' );

INSERT INTO dim_category ( category_name ) VALUES ( 'Gaming' );

INSERT INTO dim_category ( category_name ) VALUES ( 'Oficina' );

COMMIT;

SELECT
    *
FROM
    fact_sales;

SELECT
    user
FROM
    dual;

SELECT
    owner,
    table_name
FROM
    all_tables
WHERE
    table_name LIKE 'DIM%';

SELECT
    owner,
    table_name
FROM
    all_tables
WHERE
    table_name = 'FACT_SALES';

GRANT
    CREATE VIEW
TO ecommerce_project;

//UNA VEZ IMPORTADA LA DATA PROCEDEMOS A REALIZAR LA VISTA
CREATE OR REPLACE VIEW vw_ecommerce_sales AS
    SELECT
        fs.sale_id,
        fs.date_id,
        d.full_date,
        d.month,
        d.month_name,
        d.year,
        fs.customer_id,
        c.gender,
        c.age,
        fs.product_id,
        p.product_name,
        p.brand,
        cat.category_name,
        fs.quantity,
        fs.unit_price,
        fs.total_amount
    FROM
             fact_sales fs
        JOIN dim_date      d ON fs.date_id = d.date_id
        JOIN dim_customers c ON fs.customer_id = c.customer_id
        JOIN dim_products  p ON fs.product_id = p.product_id
        JOIN dim_category  cat ON p.category_id = cat.category_id;

SELECT
    *
FROM
    vw_ecommerce_sales;