-- BAKERY-1
SELECT Flavor, Food, PRICE
FROM goods
WHERE 1 <= PRICE AND PRICE <= 2 AND Food = 'Cookie'
ORDER BY Flavor;

-- BAKERY-2
SELECT Flavor, Food, PRICE
FROM goods
WHERE Food = 'Pie' OR 
    (3.4 <= PRICE AND PRICE <= 3.65) OR 
    (Food = 'Croissant' AND Flavor <> 'Apple')
ORDER BY PRICE;

-- BAKERY-3
SELECT DISTINCT C.FirstName, C.LastName
FROM customers C
JOIN receipts R
ON C.CId = R.Customer
WHERE SaleDate = '2007-10-24'
ORDER BY C.LastName;

-- BAKERY-4
SELECT MIN(Flavor) AS flavor, MAX(Flavor) AS flavor
FROM goods
WHERE Food = 'Eclair'
GROUP BY Price
HAVING COUNT(DISTINCT Flavor) = 2;

-- BAKERY-5
SELECT DISTINCT G.Flavor, G.Food
FROM goods G
JOIN items I
ON I.Item = G.GId
JOIN receipts R
ON I.Receipt = R.RNumber
WHERE R.SaleDate = '2007-10-09'
    AND G.Food = 'Croissant'
ORDER BY G.Flavor;

-- BAKERY-6
SELECT I.receipt, G.Flavor, G.Food, R.SaleDate
FROM items I
INNER JOIN goods G
ON I.item = G.gid
INNER JOIN receipts R
ON R.RNumber = I.receipt
WHERE G.Food = 'Cake'
GROUP BY I.receipt, G.Food, G.Flavor, I.item, R.saleDate
HAVING COUNT(I.item) >= 2
ORDER BY R.SaleDate ASC;

-- BAKERY-7
SELECT R.SaleDate
FROM receipts R
JOIN customers C
ON R.Customer = C.CId
WHERE C.FirstName = 'MIGDALIA' AND C.LastName = 'STADICK'
GROUP BY R.SaleDate
HAVING COUNT(DISTINCT R.RNumber) >= 2
ORDER BY R.SaleDate;


-- BAKERY 1.
UPDATE GOODS
SET Price = Price - 2.00
WHERE (Flavor = 'Lemon' OR Flavor = 'Napoleon')
    AND Food = 'Cake';

-- BAKERY 2.
UPDATE GOODS
SET Price = Price * 1.15
WHERE (Flavor = 'Apricot' OR Flavor = 'Chocolate')
    AND Price < 5.95;

-- BAKERY 3.
CREATE TABLE PAYMENTS(
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    Receipt int NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentSettled TIMESTAMP NOT NULL,
    PaymentType varchar(100) NOT NULL,
    CONSTRAINT `FK_PAYMENTS_RECEIPTS_ReceiptNum`
        FOREIGN KEY (Receipt)
        REFERENCES RECEIPTS(ReceiptNumber),
    CONSTRAINT `PAYMENT_UNIQUE`
        UNIQUE (Receipt, Amount, PaymentSettled, PaymentType)
);

