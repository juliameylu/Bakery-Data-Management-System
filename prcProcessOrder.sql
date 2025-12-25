USE jlu97;
    
DROP PROCEDURE IF EXISTS prcProcessOrder;
DELIMITER //

CREATE PROCEDURE prcProcessOrder (
    IN p_customer_id INT,
    IN p_item_list VARCHAR(255),
    IN p_new_receipt_num INT,
    OUT p_final_cost DECIMAL(10,2)
)
BEGIN
	DECLARE pos INT;
    DECLARE item_id VARCHAR(100);
	DECLARE rest_of_str VARCHAR(255) DEFAULT p_item_list;
    
    DECLARE temp_price DECIMAL(10,2);
    DECLARE item_count INT DEFAULT 0;
    DECLARE ordinal INT;
    
    DECLARE loyalty_status VARCHAR(10);
	DECLARE total_spent DECIMAL(10,2);
    
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
        ROLLBACK;
        SET p_final_cost = 0.00;
        RESIGNAL;
    END;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_final_cost = 0.00;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transaction failed due to a database error. Changes rolled back.';
	END;
    
    SET p_final_cost = 0.00;
    
    START TRANSACTION;
    
    INSERT INTO RECEIPTS(ReceiptNumber, Date, CustomerId) VALUES (p_new_receipt_num, CURDATE(), p_customer_id);
    CALL prcCheckLoyaltyStatus(p_customer_id, loyalty_status, total_spent);
    
	WHILE rest_of_str <> '' AND item_count < 4 DO
		SET pos = LOCATE(',', rest_of_str);
        
        IF pos = 0 THEN
			SET item_id = rest_of_str;
            SET rest_of_str = '';
		ELSE
			SET item_id = SUBSTRING(rest_of_str, 1, pos - 1);
            SET rest_of_str = SUBSTRING(rest_of_str, pos + 1);
		END IF;
        
        SET item_id = TRIM(item_id);
		SET temp_price = NULL;
		SELECT Price INTO temp_price
        FROM GOODS
        WHERE Id = item_id;

        IF temp_price IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid item ID.';
        END IF;
        
        SELECT IFNULL(MAX(Ordinal),0) + 1 INTO ordinal
        FROM ITEMS 
        WHERE Receipt = p_new_receipt_num;
        
        INSERT INTO ITEMS(Receipt, Ordinal, Item) VALUES (p_new_receipt_num, ordinal, item_id);

        SET p_final_cost = p_final_cost + temp_price;
        SET item_count = item_count + 1;
	END WHILE;
    
    IF item_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No items provided.';
    END IF;
    
    IF loyalty_status = 'Gold' THEN
		SET p_final_cost = p_final_cost * 0.85;
	ELSEIF loyalty_status = 'Silver' THEN
		SET p_final_cost = p_final_cost * 0.90;
	END IF;
    SET p_final_cost = ROUND(p_final_cost, 2);
	-- no discount for bronze because if customer spends 0, shouldn't get discount
    
	COMMIT;

END//

DELIMITER ;