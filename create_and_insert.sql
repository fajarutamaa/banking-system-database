-- CREATE EXTENSION GENERATE UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CREATE A CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
	no_id SERIAL NOT NULL,
	id_customer uuid DEFAULT uuid_generate_v4 (),
	name_customer VARCHAR(50),
	address TEXT,
	phone_number VARCHAR(13),
	NIK VARCHAR(10) PRIMARY KEY,
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW(),
	UNIQUE(NIK)
);

-- CREATE A ACCOUNTS TABLE
CREATE TABLE IF NOT EXISTS accounts (
	no_id SERIAL NOT NULL,
	id_account uuid DEFAULT uuid_generate_v4 () PRIMARY KEY,
	no_account VARCHAR(15),
	type_account VARCHAR(20) CHECK(type_account IN('Giro', 'Tabungan', 'Deposito')),
	user_id VARCHAR(10),
	pin_account INT CHECK(pin_account> 000000 AND pin_account < 999999),
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	UNIQUE(no_account),
	CONSTRAINT fk_accounts
      FOREIGN KEY(user_id) 
	  REFERENCES customers(NIK)
);

-- CREATE A TRANSACTIONS TABLE 
CREATE TABLE IF NOT EXISTS transactions (
	id_transaction uuid DEFAULT uuid_generate_v4 () PRIMARY KEY,
	sender_account VARCHAR(25),
	type_transaction VARCHAR(20) CHECK (type_transaction IN ('Deposit', 'Withdraw', 'Transfer')),
	receiver_account VARCHAR(25),
	amount DECIMAL(15,2),
	code_transaction UUID DEFAULT uuid_generate_v4(),
	date_transaction TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_transaction
		FOREIGN KEY(sender_account)
		REFERENCES accounts(no_account)
);


-- CREATE PROCEDURE ON CREATE ACCOUNT
CREATE OR REPLACE PROCEDURE createCustomer (
	customerName VARCHAR,
	customerAddress TEXT,
	customerPhoneNumber VARCHAR,
	customerNIK VARCHAR
)
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO customers(name_customer,address,phone_number,NIK)
	VALUES(customerName, customerAddress, customerPhoneNumber, customerNIK);
	COMMIT;
END;
$$;


-- CALL PROCEDURE CREATE CUSTOMER
CALL createCustomer(
	'Sri Lestari',
	'Medan',
	'086783622',
	'1234567890'
);

-- CREATE PROCEDURE ON UPDATED CUSTOMER
CREATE OR REPLACE PROCEDURE updateCustomer (
	customerName VARCHAR,
	customerAddress TEXT,
	customerPhoneNumber VARCHAR,
	customerNIK VARCHAR,
	noId INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customers
	SET name_customer = customerName,
		address = customerAddress,
		phone_number = customerPhoneNumber,
		NIK = customerNIK
	WHERE
		no_id = noId;
	COMMIT;
END;
$$;

-- CALL PROCEDURE UPDATE CUSTOMER
CALL updateCustomer(
	'Doni Ismail',
	'Bogor',
	'0987625538',
	'donijaya@gmail.com',
	1
);

-- CREATE INDEXING ON CUSTOMERS TABLE
CREATE INDEX index_customers 
ON customers(name_customer, address);


-- CREATE PROCEDURE ON CREATE ACCOUNT
CREATE OR REPLACE PROCEDURE createAccount (
	noAccount VARCHAR,
	typeAccount VARCHAR,
	userId VARCHAR,
	pinAccount INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO accounts(no_account, type_account, user_id, pin_account)
	VALUES (noAccount, typeAccount, userId, pinAccount);
	COMMIT;
END;
$$;

-- CALL PROCEDURE CREATE ACCOUNT
CALL createAccount 
	'202310170987654',
	'Giro',
	'1234567890',
	'123456'
);

SELECT * FROM accounts;

-- CREATE PROCEDURE ON UPDATED ACCOUNT
CREATE OR REPLACE PROCEDURE UpdateAccount (
	pinAccount INT,
	noId INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE accounts
	SET 
		pin_account = pinAccount
	WHERE 
		no_id = noId;
	COMMIT;
END;
$$;

-- CALL UPDATED ACCOUNT
CALL updateAccount(
	'Tabungan',
	'123456',
	2
);

-- CREATE INDEXING ON ACCOUNTS TABLE
CREATE INDEX index_account
ON accounts(type_account, user_id);


-- CREATE PROCEDURE ON ADD TRANSACTIONS
CREATE OR REPLACE PROCEDURE addTransaction (
	accSender VARCHAR,
	typeTransaction VARCHAR,
	accReceiver VARCHAR,
	thisAmount DECIMAL
)
	LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO transactions(sender_account, type_transaction, receiver_account, amount)
	VALUES (accSender, typeTransaction, accReceiver, thisAmount);
	COMMIT;
END;
$$;

-- CALL ADD TRANSACTION
CALL addTransaction(
	'202310170987654',
	'Deposit',
	'202310170987654',
	1000
);


-- CREATE INDEXING ON TRANSACTIONS TABLE
CREATE INDEX index_transaction
ON transactions(sender_account, receiver_account);
