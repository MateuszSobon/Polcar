use Polcar
go

CREATE PROCEDURE GetTasksByUserAndDate
    @user_id INT,                    
    @end_date DATE,             
	@start_date DATE = null   
AS
BEGIN
    SET NOCOUNT ON;

	IF @start_date = null
	BEGIN
		SET @start_date = GETDATE()
	END

    SELECT TOP 10
        task_id,
        task_priority_id,
        task_user_id,
        task_date_add,
        task_date_finish,
        task_status_id
    FROM 
        Tasks
    WHERE 
        task_user_id = @user_id
        AND task_date_add BETWEEN @start_date AND @end_date
		AND task_active = 1
    ORDER BY 
        task_date_add; -- Sortowanie po dacie dodania
END;

go
CREATE PROCEDURE GetActiveUsers
    @user_role_admin bit = NULL,      
    @user_active BIT = NULL,             
    @user_group_id INT = NULL            
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id,
        user_name,
        user_surname,
        user_role_admin,
        user_group_id,
        user_active
    FROM 
        Users
    WHERE 
        (@user_role_admin IS NULL OR user_role_admin = @user_role_admin)              
        AND (@user_active IS NULL OR user_active = @user_active)    
        AND (@user_group_id IS NULL OR user_group_id = @user_group_id) 
    ORDER BY 
        user_id desc;
END;

go
CREATE PROCEDURE AddTask
    @task_priority INT,              
    @task_user_id INT,                
    @task_active BIT,                 
    @task_status_id INT = null              
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @task_user_id)
    BEGIN
        RAISERROR ('User ID does not exist.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM TaskStatusChanges WHERE status_id = @task_status_id)
    BEGIN
        RAISERROR ('Status ID does not exist.', 16, 1);
        RETURN;
    END

    INSERT INTO Tasks ([task_priority_id], task_user_id, task_date_add, task_date_finish, task_active, task_status_id)
    VALUES (@task_priority, @task_user_id, GETDATE(), null, @task_active, @task_status_id);

    PRINT 'Task added successfully.';
END;

go
CREATE PROCEDURE AddUser
    @user_name NVARCHAR(50),         
    @user_surname NVARCHAR(50),        
    @user_role NVARCHAR(50),           
    @user_group_id INT             
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Groups WHERE group_id = @user_group_id)
    BEGIN
        RAISERROR ('Group ID does not exist.', 16, 1);
        RETURN;
    END

    INSERT INTO Users (user_name, user_surname, user_role_admin, user_group_id, user_active)
    VALUES (@user_name, @user_surname, @user_role, @user_group_id, 1);

    PRINT 'User added successfully.';
END;
