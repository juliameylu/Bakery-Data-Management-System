CREATE TABLE CUSTOMERS(
    Id int PRIMARY KEY,
    FirstName varchar(100) NOT NULL,
    LastName varchar(100) NOT NULL
);

CREATE TABLE GOODS(
    Id varchar(100) PRIMARY KEY,
    Flavor varchar(100) NOT NULL,
    Food varchar(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE RECEIPTS(
    ReceiptNumber int PRIMARY KEY,
    ReceiptDate date NOT NULL,
    CustomerId int NOT NULL,
    CONSTRAINT `FK_RECEIPTS_CUSTOMERS_Id`
        FOREIGN KEY (CustomerId) 
        REFERENCES CUSTOMERS(Id)
);

CREATE TABLE ITEMS(
    PRIMARY KEY (Receipt, Ordinal),
    Receipt int NOT NULL,
    Ordinal int NOT NULL,
    Item varchar(100) NOT NULL,
    CONSTRAINT `FK_ITEMS_RECEIPTS_ReceiptNum`
        FOREIGN KEY (Receipt) 
        REFERENCES RECEIPTS(ReceiptNumber),
    CONSTRAINT `FK_ITEMS_GOODS_Id`
        FOREIGN KEY (Item) 
        REFERENCES GOODS(Id)
);