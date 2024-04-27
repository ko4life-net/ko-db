SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[LEVEL_CHEAT] AS


DECLARE @strUserID char(21), @Level tinyint, @row tinyint, @LevelYesterday tinyint        
SET @strUserID = null
SET @Level = 0
SET @row = 0
SET @LevelYesterday = 0


DECLARE Backup_Cursor CURSOR FOR                                       
	SELECT strUserID, [Level]
	FROM USERDATA WHERE [Level] >= 20

	OPEN Backup_Cursor
	FETCH NEXT FROM Backup_Cursor INTO @strUserID, @Level

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @row = count(*) 
	FROM LEVEL_CHEAT_TEMP
	WHERE strUserID = @strUserID

	IF @row = 0 
	BEGIN
		INSERT INTO LEVEL_CHEAT_TEMP (strUserID, [Level], [LevelYesterday])
		VALUES (@strUserID, @Level, 0)
	END

	IF @row > 0
	BEGIN
		UPDATE LEVEL_CHEAT_TEMP
		SET [Level] = @Level WHERE strUserID = @strUserID
	END

	FETCH NEXT FROM Backup_Cursor INTO @strUserID, @Level
END

CLOSE Backup_Cursor
DEALLOCATE Backup_Cursor


DECLARE Backup_Yesterday_Cursor CURSOR FOR                       

	SELECT strUserID, [Level]
	FROM BK_TUE_USERDATA --WHERE [Level] >= 20

	OPEN Backup_Yesterday_Cursor
	FETCH NEXT FROM Backup_Yesterday_Cursor INTO @strUserID, @Level

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @row = count(*)
	FROM LEVEL_CHEAT_TEMP
	WHERE strUserID = @strUserID

	IF @row = 0 
	BEGIN
		INSERT INTO LEVEL_CHEAT (strUserID, [LevelYesterday])
		VALUES (@strUserID, @Level)
	END

	IF @row > 0
	BEGIN
		UPDATE LEVEL_CHEAT_TEMP
		SET [LevelYesterday] = @Level WHERE strUserID = @strUserID
	END

	FETCH NEXT FROM Backup_Yesterday_Cursor INTO @strUserID, @Level
END	

CLOSE Backup_Yesterday_Cursor
DEALLOCATE Backup_Yesterday_Cursor

DECLARE Backup_Compare_Cursor CURSOR FOR

	SELECT strUserID, [Level], [LevelYesterday]
	FROM LEVEL_CHEAT_TEMP WHERE ([Level] - [LevelYesterday]) >= 5

	OPEN Backup_Compare_Cursor
	FETCH NEXT FROM Backup_Compare_Cursor INTO @strUserID, @Level, @LevelYesterday

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @row = count(*)
	FROM LEVEL_CHEAT
	WHERE strUserID = @strUserID

	IF @row = 0
	BEGIN
		INSERT INTO LEVEL_CHEAT (strUserID, [Level], [LevelYesterday], [LevelDifference])
		VALUES (@strUserID, @Level, @LevelYesterday, @Level - @LevelYesterday)
	END

	FETCH NEXT FROM Backup_Compare_Cursor INTO  @strUserID, @Level, @LevelYesterday
END

CLOSE Backup_Compare_Cursor
DEALLOCATE Backup_Compare_Cursor


GO
