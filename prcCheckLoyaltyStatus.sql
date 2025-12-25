-- Julia Lu Section 8 11/17/2025
USE jlu97;
    
DELIMITER //
DROP PROCEDURE IF EXISTS prcCheckLoyaltyStatus;

CREATE PROCEDURE prcCheckLoyaltyStatus (
    IN p_customer_id INT,
    OUT p_loyalty_status VARCHAR(10),
    OUT p_total_spent DECIMAL(10,2)
)
BEGIN
    
    SELECT sum(g.Price) INTO p_total_spent
    FROM RECEIPTS r
    JOIN ITEMS i
        ON i.Receipt = r.ReceiptNumber
    JOIN GOODS g
        ON g.Id = i.Item
    WHERE r.CustomerId = p_customer_id;
    
    IF p_total_spent IS NULL THEN
        SET p_total_spent = 0;
    END IF;
    
    IF p_total_spent < 25 THEN
        SET p_loyalty_status = 'Bronze';
    ELSEIF p_total_spent < 50 THEN
        SET p_loyalty_status = 'Silver';
    ELSE
        SET p_loyalty_status = 'Gold';
    END IF;

END//

DELIMITER ;