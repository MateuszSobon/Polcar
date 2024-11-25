INSERT INTO [dbo].[Groups] (group_opis)
VALUES ('Zespó³ pakowania'), ('Zespó³ zbierania zamówieñ'), ('Zespó³ reklamacji')

--------------------------
BEGIN TRAN
DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Users (user_name, user_surname, user_role_admin, user_group_id, user_active)
    VALUES (
        CONCAT('Jan ', @i),                       
        CONCAT('Kowalski ', @i),                    
        CASE 
            WHEN @i % 5 = 0 THEN 1                 
            ELSE 0                             
        END,
        CASE 
            WHEN @i % 3 = 0 THEN 1    
			WHEN @i % 5 = 0 THEN 2  
            ELSE 3                           
        END,                                
        CASE 
            WHEN @i % 6 = 0 THEN 0                 
            ELSE 1
        END                            
    );

    SET @i = @i + 1;
END;

SELECT * FROM Users
commit
----------
INSERT INTO [dbo].[TaskStatuses] ([status_opis]) VALUES ('nowy'), ('platnosc'), ('kompletowanie'), ('wysylka'), ('reklamacja')


---
BEGIN TRAN

DECLARE @userId INT = 1;
DECLARE @taskId INT = 1;

WHILE @userId <= 100
BEGIN
    DECLARE @taskCounter INT = 1;

    WHILE @taskCounter <= 1000
    BEGIN
        INSERT INTO Tasks (task_priority_id, task_user_id, task_date_add, task_date_finish, task_active, task_status_id)
        VALUES (
            CASE 
                WHEN @taskCounter % 3 = 0 THEN 1
                WHEN @taskCounter % 2 = 0 THEN 2
                ELSE 3
            END,
            @userId,                                      
            DATEADD(DAY, (@taskCounter % 365)*(-1), GETDATE()),  
            DATEADD(DAY, (@taskCounter % 365)*(-1)+ 10, GETDATE()), 
            CASE 
                WHEN @taskCounter % 3 = 0 THEN 1           
                ELSE 0
            END,
            @taskCounter % 5 + 1                                                  
        );

        SET @taskCounter = @taskCounter + 1;              
    END;

    SET @userId = @userId + 1;                            
END;


commit
