CREATE TABLE Groups (
    group_id INT IDENTITY(1,1) PRIMARY KEY,
    group_opis NVARCHAR(255) NOT NULL,
    aud_data DATETIME DEFAULT GETDATE(),
    aud_login NVARCHAR(50)
);

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY, 
    user_name NVARCHAR(50) NOT NULL,
    user_surname NVARCHAR(50) NOT NULL,
    user_role_admin BIT NOT NULL,
    user_group_id INT NOT NULL,
    user_active BIT NOT NULL DEFAULT 1,
    aud_data DATETIME DEFAULT GETDATE(), 
    aud_login NVARCHAR(50)

	CONSTRAINT FK_user_group_id_group_id FOREIGN KEY (user_group_id) REFERENCES [Groups](group_id)
);


CREATE TABLE TaskStatusChanges (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_opis NVARCHAR(255) NOT NULL,
    status_user_id INT NOT NULL,
	aud_data DATETIME DEFAULT GETDATE(),
    aud_login NVARCHAR(50),

    CONSTRAINT FK_status_user_id_user_id FOREIGN KEY (status_user_id) REFERENCES Users(user_id)
);

CREATE TABLE Tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    task_priority_id INT NOT NULL,
    task_user_id INT NOT NULL,
    task_date_add DATETIME DEFAULT GETDATE(),
    task_date_finish DATETIME NULL,
    task_active BIT NOT NULL DEFAULT 1,
    task_status_id INT NOT NULL,
    aud_data DATETIME DEFAULT GETDATE(),
    aud_login NVARCHAR(50),

    CONSTRAINT FK_task_user_id_user_id FOREIGN KEY (task_user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_task_status_id_status_id FOREIGN KEY (task_status_id) REFERENCES [dbo].[TaskStatuses](status_id)
);


CREATE TABLE TaskStatuses (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_opis NVARCHAR(255) NOT NULL,
    aud_data DATETIME DEFAULT GETDATE(),
    aud_login NVARCHAR(50)
);

GO
CREATE TRIGGER trgUsersAudit
ON Users
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET 
        aud_data = GETDATE(),
        aud_login = SYSTEM_USER
    FROM Users
    INNER JOIN Inserted ON Users.user_id = Inserted.user_id;
END;

GO
CREATE TRIGGER trgGroupsAudit
ON Groups
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Groups
    SET 
        aud_data = GETDATE(),
        aud_login = SYSTEM_USER
    FROM Groups
    INNER JOIN Inserted ON Groups.group_id = Inserted.group_id;
END;

GO
CREATE TRIGGER trgTasksAudit
ON Tasks
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Tasks
    SET 
        aud_data = GETDATE(),
        aud_login = SYSTEM_USER
    FROM Tasks
    INNER JOIN Inserted ON Tasks.task_id = Inserted.task_id;
END;

GO
CREATE TRIGGER trgTaskStatusChangesAudit
ON TaskStatusChanges
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE TaskStatusChanges
    SET 
        aud_data = GETDATE(),
        aud_login = SYSTEM_USER
    FROM TaskStatusChanges
    INNER JOIN Inserted ON TaskStatusChanges.status_id = Inserted.status_id;
END;

GO
CREATE TRIGGER trgTaskStatusesAudit
ON TaskStatuses
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE TaskStatuses
    SET 
        aud_data = GETDATE(),
        aud_login = SYSTEM_USER
    FROM TaskStatuses
    INNER JOIN Inserted ON TaskStatuses.status_id = Inserted.status_id;
END;

CREATE INDEX IDX_Users_UserGroupId ON Users(user_group_id);
CREATE INDEX IDX_Tasks_TaskUserId ON Tasks(task_user_id);
CREATE INDEX IDX_Tasks_TaskStatusId ON Tasks(task_status_id);
CREATE INDEX IDX_TaskStatusChanges_StatusUserId ON TaskStatusChanges(status_user_id);