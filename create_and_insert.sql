-- CREATE EXTENSION GENERATE UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CREATE A CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
	id uuid DEFAULT uuid_generate_v4 (), 
	name_customer VARCHAR(50),
	address TEXT,
	phone_number VARCHAR(10),
	NIK VARCHAR(12) PRIMARY KEY,
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW(),
	deletedAt TIMESTAMP,
	UNIQUE(NIK)
);

-- CREATE A ACCOUNTS TABLE
CREATE TYPE type_account AS ENUM ('Giro', 'Tabungan', 'Deposito');
CREATE TABLE IF NOT EXISTS accounts (
	id uuid DEFAULT uuid_generate_v4 () PRIMARY KEY,
	type_account type_account,
	no_account VARCHAR(15),
	user_id VARCHAR(12), 
	pin_account INT,
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW(),
	deletedAt TIMESTAMP,
	UNIQUE(no_account),
	CONSTRAINT fk_accounts
      FOREIGN KEY(user_id) 
	  REFERENCES customers(NIK)
);

-- CREATE A TRANSACTIONS TABLE
CREATE TYPE type_transaction AS ENUM ('Deposit', 'Withdraw', 'Transfer');
CREATE TABLE IF NOT EXISTS transactions (
	id_transaction uuid DEFAULT uuid_generate_v4 () PRIMARY KEY,
	sender_account VARCHAR(15),
	type_transaction type_transaction,
	receiver_account VARCHAR(15),
	amount DECIMAL(15,2),
	date_transaction TIMESTAMP NOT NULL DEFAULT NOW(),
	createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
	updatedAt TIMESTAMP DEFAULT NOW(),
	deletedAt TIMESTAMP,
	UNIQUE(sender_account),
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
	'Dewi Lestari',
	'Medan',
	'0867836223',
	'123456789021'
);

CALL createCustomer(
	'Sri Tanjung',
	'Jakarta',
	'0877917892134',
	'2233258799'
);

CALL createCustomer(
	'Kevin Maretina',
	'Madiun',
	'0825682174679',
	'2485867098'
);

CALL createCustomer(
	'Anwar Santoso',
	'Magetan',
	'0813582174777',
	'4586867703'
);

CALL createCustomer(
	'Gunawan',
	'Nganjuk',
	'0834562999093',
	'3312366778'
);

CALL createCustomer(
	'Joko',
	'Gresik',
	'0834662899963',
	'5312366778'
);

-- CREATE PROCEDURE ON UPDATED CUSTOMER
CREATE OR REPLACE PROCEDURE updateCustomer (
	customerName VARCHAR,
	customerAddress TEXT,
	customerPhoneNumber VARCHAR,
	customerNIK VARCHAR
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customers
	SET name_customer = customerName,
		address = customerAddress,
		phone_number = customerPhoneNumber,
		updatedAt = NOW()
	WHERE
		NIK = customerNIK;
	COMMIT;
END;
$$;

-- CALL PROCEDURE UPDATE CUSTOMER
CALL updateCustomer(
	'Sri Tanjung',
	'Jakarta',
	'0877917892',
	'123456789021'
);

-- CREATE PROCEDURE ON DELETE CUSTOMER
CREATE OR REPLACE PROCEDURE deleteCustomer (
	customerNIK VARCHAR
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customers
	SET	deletedAt = NOW()
	WHERE NIK = customerNIK;
	COMMIT;
END;
$$;

-- CALL PROCEDURE DELETE CUSTOMER
CALL deleteCustomer(
	'123456789021'
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
	VALUES (noAccount, typeAccount::type_account, userId, pinAccount);
	COMMIT;
END;
$$;

-- CALL PROCEDURE CREATE ACCOUNT
CALL createAccount (
	'202310170987652',
	'Giro',
	'123456789021',
	123456
);

-- CREATE PROCEDURE ON UPDATED ACCOUNT
CREATE OR REPLACE PROCEDURE updateAccount (
	pinAccount INT,
	noAccount VARCHAR,
	userId VARCHAR
)
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE accounts
	SET 
		pin_account = pinAccount,
		updatedAt = NOW()
	WHERE 
		no_account = noAccount
		AND user_id = userId;
	COMMIT;
END;
$$;

-- CALL UPDATED ACCOUNT && UPDATE PIN VIA NO.ACCOUNT AND USER ID
CALL updateAccount(
	456789, 					
	'202310170987650',
	'3312366778'
);


-- CREATE INDEXING ON ACCOUNTS TABLE
CREATE INDEX index_account
ON accounts(no_account, type_account, user_id);

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
	VALUES (accSender, typeTransaction::type_transaction, accReceiver, thisAmount);
	COMMIT;
END;
$$;

-- CALL ADD TRANSACTION
CALL addTransaction(
	'202310170987652',
	'Deposit',
	'202310170987652',
	2000
);

-- CREATE INDEXING ON TRANSACTIONS TABLE
CREATE INDEX index_transaction
ON transactions(sender_account, receiver_account);
