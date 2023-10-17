-- CREATE TABLE CUSTOMERS
CREATE TABLE IF NOT EXISTS customers (
	id_customer BIGSERIAL NOT NULL PRIMARY KEY,
	name_customer VARCHAR(50),
	address TEXT,
	phone_number VARCHAR(13),
	email VARCHAR(50),
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW()
);


--CREATE STORED PROCEDURE ON CREATE CUSTOMERS
CREATE OR REPLACE PROCEDURE createCustomer (
	customerName VARCHAR,
	customerAddress TEXT,
	customerPhoneNumber VARCHAR,
	customerEmail VARCHAR
)
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO customers(name_customer,address,phone_number,email)
	VALUES(customerName, customerAddress, customerPhoneNumber, customerEmail);
	COMMIT;
END;
$$;

-- CALL PROCEDURE CREATE CUSTOMER
CALL createCustomer(
	'Sri Lestari',
	'Medan',
	'086783622',
	'Lestario27@gmail.com'
);

--CREATE STORED PROCEDURE ON UPDATE CUSTOMERS
CREATE OR REPLACE PROCEDURE updateCustomer (
	customerName VARCHAR,
	customerAddress TEXT,
	customerPhoneNumber VARCHAR,
	customerEmail VARCHAR,
	idCustomer INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customers
	SET name_customer = customerName,
		address = customerAddress,
		phone_number = customerPhoneNumber,
		email = customerEmail
	WHERE
		id_customer = idCustomer;
	COMMIT;
END;
$$;

-- CALL PROCEDURE UPDATE CUSTOMERS
CALL updateCustomer(
	'Doni Ismail',
	'Bogor',
	'0987625538',
	'donijaya@gmail.com',
	1
);

-- CREATE INDEXING FOR TABLE CUSTOMERS
CREATE INDEX index_customers 
ON customers(name_customers, address);

-- DELETE ALL DATA ON TABLE CUSTOMERS
DELETE FROM customers;

-- VIEW ALL DATA FROM TABLE CUSTOMERS
SELECT * FROM customers;

ALTER SEQUENCE customers_id_customer_seq RESTART WITH 1;

-- CREATE TABLE ACCOUNTS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE IF NOT EXISTS accounts (
	id_account BIGSERIAL NOT NULL PRIMARY KEY,
	type_account VARCHAR(20) CHECK(type_account='Giro' OR type_account='Tabungan' OR type_account='Deposito' ),
	pin_account INT CHECK(pin_account> 000000 AND pin_account < 999999),
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	no_account uuid DEFAULT uuid_generate_v4 (),
	balance DECIMAL
);


-- CREATE STORED PROCEDURE CREATE ACCOUNT
CREATE OR REPLACE PROCEDURE createAccount (
	typeAccount VARCHAR,
	pinAccount INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO accounts(type_account, pin_account)
	VALUES (typeAccount, pinAccount);
	COMMIT;
END;
$$;

-- CALL PROCEDURE CREATE ACCOUNT
CALL createAccount(
	'Giro',
	'222222'
);

-- CREATE STORED PROCEDURE UPDATE
CREATE OR REPLACE PROCEDURE UpdateAccount (
	typeAccount VARCHAR,
	pinAccount INT,
	idAccount INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE accounts
	SET 
		type_account = typeAccount, 
		pin_account = pinAccount
	WHERE 
		id_account = idAccount;
	COMMIT;
END;
$$;

CALL updateAccount(
	'Tabungan',
	'123456',
	2
);

-- CREATE INDEXING FOR TABLE ACCOUNT
CREATE INDEX index_account
ON accounts(type_account);


-- CREATE TABLE TRANSACTIONS
CREATE TABLE IF NOT EXISTS transactions (
	id_transaction BIGSERIAL NOT NULL PRIMARY KEY,
	date_transaction TIMESTAMP NOT NULL DEFAULT NOW(),
	type_transaction VARCHAR(20) CHECK (type_transaction='Deposit' OR type_transaction='Withdraw' OR type_transaction='Transfer'),
	amount DECIMAL,
	code_transaction
);


--CREATE PROCEDURE ADD TRANSACTION
CREATE OR REPLACE PROCEDURE addTransaction (

)
	LANGUAGE pgplsql
AS $$
BEGIN


END;
$$;

-- CALL
CALL

-- CREATE INDEXING
CREATE INDEX index_transaction
ON transactions();