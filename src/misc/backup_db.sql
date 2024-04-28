USE master;
GO

IF OBJECT_ID('N3BackupDatabase', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE N3BackupDatabase;
END
GO

CREATE PROCEDURE N3BackupDatabase
    @DatabaseName NVARCHAR(128),
    @BackupFilePath NVARCHAR(260)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);

    -- Check if the database exists
    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @DatabaseName)
    BEGIN
        -- Construct the dynamic SQL for backup
        -- WITH INIT, FORMAT - Ensure we start a fresh backup file, even if the destination file exists
        -- SKIP - in case the target db is offline
        -- NOREWIND & NOREWIND - ensure no interruption to the db during the backup operation
        -- STATS = 10 - report to us the progress for every 10% of the backup operation
        SET @SQL = 'BACKUP DATABASE ' + QUOTENAME(@DatabaseName) +
                   ' TO DISK = ' + QUOTENAME(@BackupFilePath, '''') +
                   ' WITH INIT, FORMAT, NAME = N''' + @DatabaseName + ' Backup'', ' +
                   ' SKIP, NOREWIND, NOUNLOAD, STATS = 10';

        -- Execute the backup command
        PRINT 'Query: [' + @SQL + ']';
        EXEC sp_executesql @SQL;

        PRINT 'Backup of database [' + @DatabaseName + '] completed successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Database [' + @DatabaseName + '] does not exist. Backup operation aborted.';
    END
END
