USE jlu97;

DROP TABLE IF EXISTS GOODS_LOG;
CREATE TABLE GOODS_LOG (
	LogID INT AUTO_INCREMENT PRIMARY KEY,
    GoodID VARCHAR(100),
    LogTime DATETIME,
    CONSTRAINT `FK_GOODS_LOG_GOODS_Id`
		FOREIGN KEY (GoodID)
        REFERENCES GOODS(Id)
);

DROP TRIGGER IF EXISTS trg_LogNewGood;
DELIMITER //
CREATE TRIGGER trg_LogNewGood
AFTER INSERT ON GOODS
FOR EACH ROW
BEGIN
	INSERT INTO GOODS_LOG(GoodID, LogTime) VALUES (NEW.Id, NOW());
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS prcAddNewGood;
DELIMITER //
CREATE PROCEDURE prcAddNewGood (
    IN p_id VARCHAR(100),
    IN p_flavor VARCHAR(100),
    IN p_food VARCHAR(100),
    IN p_price DECIMAL(10,2)
)
BEGIN
	DECLARE id_exists INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transaction failed due to a database error. Changes rolled back.';
    END;
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO id_exists
    FROM GOODS
    WHERE Id = p_id;
    
    IF id_exists > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Good already exists.';
	END IF;
    
    IF p_price <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Price invalid.';
	END IF;
	
    INSERT INTO GOODS(Id, Flavor, Food, Price) VALUES (p_id, p_flavor, p_food, p_price);
    COMMIT;
    SELECT 'Success: Good added successfully.' AS Result;

END//

DELIMITER ;




