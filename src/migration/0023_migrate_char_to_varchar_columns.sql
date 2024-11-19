-- 1) Update all char(n) columns to varchar(n)

-- Temporarily drop problematic indexes
DROP INDEX [IX_rating_rank] ON [dbo].[KNIGHTS_RATING];
DROP INDEX [IX_rating_name] ON [dbo].[KNIGHTS_RATING];

GO
DECLARE @SQL nvarchar(MAX) = N'';

SELECT @SQL +=
    N'BEGIN TRY' + CHAR(13) + CHAR(10) +
    N'    DECLARE @ConstraintSQL nvarchar(MAX) = N'''';' + CHAR(13) + CHAR(10) +
    N'    DECLARE @KeySQL nvarchar(MAX) = N'''';' + CHAR(13) + CHAR(10) +

    -- Step 1: Drop constraints
    N'    SELECT @ConstraintSQL += N''ALTER TABLE ' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) +
    N' DROP CONSTRAINT '' + QUOTENAME(dc.name) + N'';'' + CHAR(13) + CHAR(10) ' +
    N'    FROM sys.default_constraints dc ' +
    N'    WHERE dc.parent_object_id = OBJECT_ID(''' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N''') ' +
    N'      AND dc.parent_column_id = COLUMNPROPERTY(OBJECT_ID(''' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N'''), ''' + COLUMN_NAME + N''', ''ColumnId'');' + CHAR(13) + CHAR(10) +
    N'    EXEC sp_executesql @ConstraintSQL;' + CHAR(13) + CHAR(10) +

    -- Step 2: Drop primary and unique key constraints
    N'    SELECT @KeySQL += N''ALTER TABLE ' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) +
    N' DROP CONSTRAINT '' + QUOTENAME(k.name) + N'';'' + CHAR(13) + CHAR(10) ' +
    N'    FROM sys.key_constraints k ' +
    N'    WHERE k.parent_object_id = OBJECT_ID(''' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N''') ' +
    N'      AND EXISTS (SELECT 1 FROM sys.index_columns ic ' +
    N'                  WHERE ic.object_id = k.parent_object_id ' +
    N'                    AND ic.index_id = k.unique_index_id ' +
    N'                    AND ic.column_id = COLUMNPROPERTY(OBJECT_ID(''' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N'''), ''' + COLUMN_NAME + N''', ''ColumnId''));' + CHAR(13) + CHAR(10) +
    N'    EXEC sp_executesql @KeySQL;' + CHAR(13) + CHAR(10) +

    -- Step 3: Alter the column with preserved nullability
    N'    ALTER TABLE ' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) +
    N'    ALTER COLUMN ' + QUOTENAME(COLUMN_NAME) +
    N'    VARCHAR(' +
        CASE
            WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX'
            ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar)
        END +
    N') ' +
    CASE IS_NULLABLE
        WHEN 'YES' THEN 'NULL'
        ELSE 'NOT NULL'
    END + N';' + CHAR(13) + CHAR(10) +

    N'END TRY' + CHAR(13) + CHAR(10) +
    N'BEGIN CATCH' + CHAR(13) + CHAR(10) +
    N'    PRINT ''Error occurred while processing table ' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N', column ' + QUOTENAME(COLUMN_NAME) + N'.'';' + CHAR(13) + CHAR(10) +
    N'    PRINT ERROR_MESSAGE();' + CHAR(13) + CHAR(10) +
    N'END CATCH;' + CHAR(13) + CHAR(10) +
    N'GO' + CHAR(13) + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'char';

-- Execute each block independently
DECLARE @Cmd nvarchar(MAX);
DECLARE @Pos int;

SET @Pos = CHARINDEX('GO', @SQL);

WHILE @Pos > 0
  BEGIN
    SET @Cmd = LEFT(@SQL, @Pos - 1);  -- Extract a single batch
    EXEC sp_executesql @Cmd;          -- Execute it independently
    --PRINT @SQL;
    SET @SQL = STUFF(@SQL, 1, @Pos + 2, '');  -- Remove the executed batch
    SET @Pos = CHARINDEX('GO', @SQL); -- Find the next batch
  END
GO

-- Restore dropped indexes, PKs and constraints
ALTER TABLE [dbo].[KNIGHTS] ADD CONSTRAINT [IX_KNIGHTS] UNIQUE NONCLUSTERED ([IDName])
CREATE INDEX [IX_rating_rank] ON [dbo].[KNIGHTS_RATING] ([nRank]) ON [PRIMARY]
CREATE INDEX [IX_rating_name] ON [dbo].[KNIGHTS_RATING] ([strName]) ON [PRIMARY]
ALTER TABLE [dbo].[ACCOUNT_CHAR] ADD CONSTRAINT [PK_ACCOUNT_CHAR] PRIMARY KEY ([strAccountID]);
ALTER TABLE [dbo].[USERDATA] ADD CONSTRAINT [PK_USERDATA] PRIMARY KEY ([strUserId]);
ALTER TABLE [dbo].[WAREHOUSE] ADD CONSTRAINT [PK_WAREHOUSE] PRIMARY KEY ([strAccountID]);

GO

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- 2) Improve consistentcy with the data in these columns by stripping accidental newline feeds (\n) and trim trailing empty space
--    due to the conversion from char to varchar, since char fills them with spaces based on the column size it used to be originally
DECLARE @SQL2 nvarchar(MAX) = N'';

-- CHAR(10) / 0x0A -> \n
-- CHAR(13) / 0x0D -> \r
SELECT @SQL2 +=
    N'UPDATE ' + QUOTENAME(TABLE_SCHEMA) + N'.' + QUOTENAME(TABLE_NAME) + N' ' +
    N'SET ' + QUOTENAME(COLUMN_NAME) + N' = RTRIM(REPLACE(REPLACE(' + QUOTENAME(COLUMN_NAME) + N', CHAR(13), ''''), CHAR(10), '''')) ' +
    N'WHERE ' + QUOTENAME(COLUMN_NAME) + N' LIKE ''% '' ' +
    N'OR ' + QUOTENAME(COLUMN_NAME) + N' LIKE ''%' + CHAR(10) + N'%'' ' +
    N'OR ' + QUOTENAME(COLUMN_NAME) + N' LIKE ''%' + CHAR(13) + N'%''; ' + CHAR(13) + CHAR(10)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE IN ('char', 'varchar');

EXEC sp_executesql @SQL2;
GO

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- 3) Alter stored procedures columns references

--
-- CREATE_KNIGHTS
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CREATE_KNIGHTS]
  @nRet smallint OUTPUT,
  @index smallint,
  @nation tinyint,
  @community tinyint,
  @strName varchar(21),
  @strChief varchar(21)
AS

DECLARE @Row tinyint, @KnightsIndex smallint, @KnightsName varchar(21)
SET @Row = 0 SET @KnightsIndex = 0 SET @KnightsName = ''

SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @index OR IDName = @strName

IF @Row > 0 OR @index = 0
  BEGIN
    SET @nRet = 3
    RETURN
  END

--SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDName = @strName

--IF @Row > 0
--	BEGIN
--	SET @nRet =  3
--RETURN
--	END

BEGIN TRAN

INSERT INTO KNIGHTS (IDNum, Nation, Flag, IDName, Chief)
VALUES (@index, @nation, @community, @strName, @strChief)

INSERT INTO KNIGHTS_USER (sIDNum, strUserID)
VALUES (@index, @strChief)

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 6
    RETURN
  END

--	UPDATE USERDATA SET Knights = @index, Fame = 1 WHERE strUserId = @strChief	-- 1 == Chief Authority

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 6
    RETURN
  END

COMMIT TRAN
SET @nRet = 0

GO
GO

--
-- CREATE_NEW_CHAR
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CREATE_NEW_CHAR]

  @nRet smallint OUTPUT,
  @AccountID varchar(21),
  @index tinyint,
  @CharID varchar(21),
  @Race tinyint,
  @Class smallint,
  @Hair tinyint,
  @Face tinyint,
  @Str tinyint,
  @Sta tinyint,
  @Dex tinyint,
  @Intel tinyint,
  @Cha tinyint

AS

DECLARE @Row tinyint, @Nation tinyint, @Zone tinyint, @PosX int, @PosZ int
SET @Row = 0 SET @Nation = 0 SET @Zone = 0 SET @PosX = 0 SET @PosZ = 0

SELECT
  @Nation = bNation,
  @Row = bCharNum
FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID

IF @Row >= 5 SET @nRet = 1

IF @Nation = 1 AND @Race > 10 SET @nRet = 2
ELSE IF @Nation = 2 AND @Race < 10 SET @nRet = 2
ELSE IF @Nation != 1 AND @Nation != 2 SET @nRet = 2

IF @nRet > 0
  RETURN

  SELECT @Row = COUNT(*) FROM USERDATA WHERE strUserId = @CharID
IF @Row > 0
  BEGIN
    SET @nRet = 3
    RETURN
  END

SET @Zone = @Nation
SELECT
  @PosX = InitX,
  @PosZ = InitZ
FROM ZONE_INFO WHERE ZoneNo = @Zone

BEGIN TRAN
IF @index = 0
  UPDATE ACCOUNT_CHAR SET strCharID1 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID
ELSE IF @index = 1
  UPDATE ACCOUNT_CHAR SET strCharID2 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID
ELSE IF @index = 2
  UPDATE ACCOUNT_CHAR SET strCharID3 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID
ELSE IF @index = 3
  UPDATE ACCOUNT_CHAR SET strCharID4 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID
ELSE IF @index = 4
  UPDATE ACCOUNT_CHAR SET strCharID5 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID


INSERT INTO USERDATA (strUserId, Nation, Race, [Class], HairColor, Face, Strong, Sta, Dex, Intel, Cha, Zone, PX, PZ)
VALUES (@CharID, @Nation, @Race, @Class, @Hair, @Face, @Str, @Sta, @Dex, @Intel, @Cha, @Zone, @PosX, @PosZ)


IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 4
    RETURN
  END

COMMIT TRAN
SET @nRet = 0

GO
GO

--
-- DELETE_CHAR
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[DELETE_CHAR]
  @AccountID varchar(21),
  @index tinyint,
  @CharID varchar(21),
  @SocNo varchar(15),
  @nRet smallint OUTPUT
AS

DECLARE
  @bCharNum tinyint,
  @charid1 varchar(21),
  @charid2 varchar(21),
  @charid3 varchar(21),
  @charid4 varchar(21),
  @charid5 varchar(21),
  @strSocNo varchar(15)
DECLARE @KnightsIndex smallint
SET @bCharNum = 0
SET @KnightsIndex = 0

SELECT @strSocNo = strSocNo FROM [dbo].[TB_USER] WHERE strAccountID = @AccountID
IF @SocNo != @strSocNo
  BEGIN
    SET @nRet = 0
    RETURN
  END

DECLARE
  @Nation tinyint,
  @Race tinyint,
  @Class smallint,
  @HairColor tinyint,
  @Rank tinyint,
  @Title tinyint,
  @Level tinyint,
  @Exp int,
  @Loyalty int
DECLARE
  @Face tinyint,
  @City tinyint,
  @Knights smallint,
  @Fame tinyint,
  @Hp smallint,
  @Mp smallint,
  @Sp smallint,
  @Strong tinyint,
  @Sta tinyint,
  @Dex tinyint
DECLARE
  @Intel tinyint,
  @Cha tinyint,
  @Authority tinyint,
  @Points tinyint,
  @Gold int,
  @Zone tinyint,
  @Bind smallint,
  @PX int,
  @PZ int,
  @PY int,
  @dwTime int
DECLARE @bySkill binary(10), @byItem binary(400), @bySerial binary(400), @Members smallint

BEGIN TRAN

IF @index = 0
  UPDATE ACCOUNT_CHAR SET strCharID1 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 1
  UPDATE ACCOUNT_CHAR SET strCharID2 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 2
  UPDATE ACCOUNT_CHAR SET strCharID3 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 3
  UPDATE ACCOUNT_CHAR SET strCharID4 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 4
  UPDATE ACCOUNT_CHAR SET strCharID5 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 0
    RETURN
  END

SELECT
  @charid1 = strCharID1,
  @charid2 = strCharID2,
  @charid3 = strCharID3,
  @charid4 = strCharID4,
  @charid5 = strCharID5
FROM ACCOUNT_CHAR
WHERE strAccountID = @AccountID
-- 캐릭터가 하나도 없으면 해당 레코드를 지운다.. -> 국가선택 다시 할수 있다
IF @charid1 IS NULL AND @charid2 IS NULL AND @charid3 IS NULL AND @charid4 IS NULL AND @charid5 IS NULL
  BEGIN
    DELETE FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
    IF @@ERROR != 0
      BEGIN
        ROLLBACK TRAN
        SET @nRet = 0
        RETURN
      END
  END

SELECT
  @Nation = Nation,
  @Race = Race,
  @Class = [Class],
  @HairColor = HairColor,
  @Rank = Rank,
  @Title = Title,
  @Level = [Level],
  @Exp = [Exp],
  @Loyalty = Loyalty,
  @Face = Face,
  @City = City,
  @Knights = Knights,
  @Fame = Fame,
  @Hp = Hp,
  @Mp = Mp,
  @Sp = Sp,
  @Strong = Strong,
  @Sta = Sta,
  @Dex = Dex,
  @Intel = Intel,
  @Cha = Cha,
  @Authority = Authority,
  @Points = Points,
  @Gold = Gold,
  @Zone = [Zone],
  @Bind = Bind,
  @PX = PX,
  @PZ = PZ,
  @PY = PY,
  @dwTime = dwTime,
  @bySkill = bySkill,
  @byItem = byItem,
  @bySerial = bySerial
FROM USERDATA WHERE strUserId = @CharID

INSERT INTO DELETED_USERDATA (
  strAccountID,
  strUserId,
  Nation,
  Race,
  [Class],
  HairColor,
  Rank,
  Title,
  [Level],
  [Exp],
  Loyalty,
  Face,
  City,
  Knights,
  Fame,
  Hp,
  Mp,
  Sp,
  Strong,
  Sta,
  Dex,
  Intel,
  Cha,
  Authority,
  Points,
  Gold,
  [Zone],
  Bind,
  PX,
  PZ,
  PY,
  dwTime,
  bySkill,
  byItem,
  bySerial
)
VALUES (
  @AccountID,
  @CharID,
  @Nation,
  @Race,
  @Class,
  @HairColor,
  @Rank,
  @Title,
  @Level,
  @Exp,
  @Loyalty,
  @Face,
  @City,
  @Knights,
  @Fame,
  @Hp,
  @Mp,
  @Sp,
  @Strong,
  @Sta,
  @Dex,
  @Intel,
  @Cha,
  @Authority,
  @Points,
  @Gold,
  @Zone,
  @Bind,
  @PX,
  @PZ,
  @PY,
  @dwTime,
  @bySkill,
  @byItem,
  @bySerial
)

DELETE FROM USERDATA WHERE strUserId = @CharID
IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 0
    RETURN
  END

DELETE FROM KNIGHTS_USER WHERE strUserID = @CharID
SELECT @Members = Members FROM KNIGHTS WHERE IDNum = @Knights
IF @Members <= 1
  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @Knights
ELSE
  UPDATE KNIGHTS SET Members = Members - 1 WHERE IDNum = @Knights

COMMIT TRAN
SET @nRet = 1

GO
GO

--
-- EXEC_KNIGHTS_USER
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- create by sungyong 2002.09.16

ALTER PROCEDURE [dbo].[EXEC_KNIGHTS_USER]
AS

SET NOCOUNT ON
DECLARE @strUserId varchar(21)
DECLARE @KnightsIndex smallint
DECLARE job1 CURSOR FOR

SELECT
  strUserId,
  Knights
FROM USERDATA

OPEN job1
FETCH NEXT FROM job1
INTO @strUserId, @KnightsIndex
WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @KnightsIndex != 0
      BEGIN
        INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@KnightsIndex, @strUserId)
      END

    FETCH NEXT FROM job1
    INTO @strUserId, @KnightsIndex
  END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF

GO
GO

--
-- KNIGHTS_RATING_UPDATE
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Created By Sungyong 2002. 10. 14

ALTER PROCEDURE [dbo].[KNIGHTS_RATING_UPDATE] AS

IF
  EXISTS (
    SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[rating_temp]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1
  )
  DROP TABLE [dbo].[rating_temp]
CREATE TABLE [dbo].[rating_temp] (
  [nRank] [int] IDENTITY (1, 1) NOT NULL,
  [shIndex] [smallint] NULL,
  [strName] [varchar](21) NULL,
  [nPoints] [int] NULL,
) ON [PRIMARY]


INSERT INTO rating_temp SELECT
  IDNum,
  IDName,
  Points
FROM KNIGHTS ORDER BY Points DESC

CREATE INDEX [IX_rating_rank] ON [dbo].[rating_temp] ([nRank]) ON [PRIMARY]
CREATE INDEX [IX_rating_name] ON [dbo].[rating_temp] ([strName]) ON [PRIMARY]

IF
  EXISTS (
    SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[KNIGHTS_RATING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1
  )
  DROP TABLE [dbo].[KNIGHTS_RATING]
EXEC sp_rename 'rating_temp', 'KNIGHTS_RATING'

GO
GO

--
-- LOAD_ACCOUNT_CHARID
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LOAD_ACCOUNT_CHARID]
  @Accountid varchar(21)
AS

SELECT
  strCharID1,
  strCharID2,
  strCharID3,
  strCharID4,
  strCharID5
FROM ACCOUNT_CHAR WHERE strAccountID = @Accountid

RETURN @@ROWCOUNT

GO
GO

--
-- LOAD_CHAR_INFO
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- Scripted by Samma
-- 2002.01.18

ALTER PROCEDURE [dbo].[LOAD_CHAR_INFO]
  @CharId varchar(21),
  @nRet smallint OUTPUT
AS

SELECT @nRet = COUNT(strUserId) FROM USERDATA WHERE strUserId = @CharId
IF @nRet = 0
  RETURN

  SELECT
    Race,
    [Class],
    HairColor,
    [Level],
    Face,
    Zone,
    byItem
  FROM USERDATA WHERE strUserId = @CharId

SET @nRet = 1
RETURN

GO
GO

--
-- LOAD_USER_DATA
--
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [dbo].[LOAD_USER_DATA]
  @id varchar(21),
  @nRet smallint OUTPUT
AS

SET @nRet = 0

SELECT @nRet = COUNT(strUserId) FROM USERDATA WHERE strUserId = @id
IF @nRet = 0
  RETURN

  SELECT
    Nation,
    Race,
    [Class],
    HairColor,
    Rank,
    Title,
    [Level],
    [Exp],
    Loyalty,
    Face,
    City,
    Knights,
    Fame,
    Hp,
    Mp,
    Sp,
    Strong,
    Sta,
    Dex,
    Intel,
    Cha,
    Authority,
    Points,
    Gold,
    [Zone],
    Bind,
    PX,
    PZ,
    PY,
    dwTime,
    bySkill,
    byItem,
    bySerial
  FROM USERDATA WHERE strUserId = @id

SET @nRet = 1
RETURN

GO
GO

--
-- NATION_SELECT
--
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[NATION_SELECT]
  @nRet smallint OUTPUT,
  @AccountID varchar(21),
  @Nation tinyint
AS

DECLARE @Row tinyint, @CharNum smallint
SET @Row = 0

BEGIN TRAN

SELECT @Row = COUNT(*) FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
IF @Row > 0
  UPDATE ACCOUNT_CHAR SET bNation = @Nation WHERE strAccountID = @AccountID
ELSE
  INSERT INTO ACCOUNT_CHAR (strAccountID, bNation) VALUES (@AccountID, @Nation)

SELECT @Row = COUNT(*) FROM WAREHOUSE WHERE strAccountID = @AccountID
IF @Row = 0
  INSERT INTO WAREHOUSE (strAccountID) VALUES (@AccountID)

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = -2
    RETURN
  END

COMMIT TRAN
SET @nRet = 1

GO
GO

--
-- UPDATE_KNIGHTS
--
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UPDATE_KNIGHTS]

  @nRet smallint OUTPUT,
  @Type tinyint,
  @UserId varchar(21),
  @KnightsIndex smallint,
  @Domanation tinyint

AS

DECLARE @Row tinyint
DECLARE @Members tinyint
DECLARE @KnightsNumber smallint
DECLARE @ViceChief_1 varchar(21)
DECLARE @ViceChief_2 varchar(21)
DECLARE @ViceChief_3 varchar(21)
SET @Row = 0
SET @KnightsNumber = 0

SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @KnightsIndex

IF @Row = 0
  BEGIN
    SET @nRet = 7
    RETURN
  END

SELECT
  @Members = Members,
  @ViceChief_1 = ViceChief_1,
  @ViceChief_2 = ViceChief_2,
  @ViceChief_3 = ViceChief_3
FROM KNIGHTS
WHERE IDNum = @KnightsIndex
IF @Members >= 24
  BEGIN
    SET @nRet = 8
    RETURN
  END

SELECT @Row = COUNT(*) FROM USERDATA WHERE strUserId = @UserId
IF @Row = 0
  BEGIN
    SET @nRet = 2
    RETURN
  END

--SELECT @ViceChief_1=ViceChief_1, @ViceChief_2=ViceChief_2, @ViceChief_3=ViceChief_3  FROM KNIGHTS WHERE IDNum = @KnightsIndex

BEGIN TRAN
IF @Type = 18					-- JOIN
  BEGIN
    UPDATE KNIGHTS SET Members = Members + 1 WHERE IDNum = @KnightsIndex
    INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@KnightsIndex, @UserId)
  END
ELSE IF @Type = 19 OR @Type = 20 OR @Type = 23	-- WITHDRAW, REMOVE, REJECT
  BEGIN
    IF @Members <= 1
      UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @KnightsIndex
    ELSE
      UPDATE KNIGHTS SET Members = Members - 1 WHERE IDNum = @KnightsIndex
    DELETE FROM KNIGHTS_USER WHERE strUserID = @UserId
    IF @ViceChief_1 = @UserId
      UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_2 = @UserId
      UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_3 = @UserId
      UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @KnightsIndex
  END
ELSE IF @Type = 25				-- Change Chief, 부단장중에 한명이 단장으로 승격시에는 부단장 데이타변수에서 부단장 이름을 빼준다
  BEGIN
    UPDATE KNIGHTS SET Chief = @UserId WHERE IDNum = @KnightsIndex
    IF @ViceChief_1 = @UserId
      UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_2 = @UserId
      UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_3 = @UserId
      UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @KnightsIndex
  END
ELSE IF @Type = 26				-- Change Vice Chief
  BEGIN
    IF @ViceChief_1 IS NOT NULL AND @ViceChief_2 IS NOT NULL AND @ViceChief_3 IS NOT NULL
      BEGIN
        SET @nRet = 8
        COMMIT TRAN
        RETURN
      END

    IF @ViceChief_1 IS NULL
      UPDATE KNIGHTS SET ViceChief_1 = @UserId WHERE IDNum = @KnightsIndex
    ELSE IF @ViceChief_2 IS NULL
      UPDATE KNIGHTS SET ViceChief_2 = @UserId WHERE IDNum = @KnightsIndex
    ELSE IF @ViceChief_3 IS NULL
      UPDATE KNIGHTS SET ViceChief_3 = @UserId WHERE IDNum = @KnightsIndex
  END
--	ELSE IF @Type = 27				-- Change Officer
--	UPDATE KNIGHTS SET ViceChief_2 = @UserId WHERE IDNum = @KnightsIndex

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 2
    RETURN
  END

IF @Type = 20	-- REMOVE
  UPDATE USERDATA SET Knights = -1, Fame = 0 WHERE strUserId = @UserId
/*
	IF @Type = 18
		BEGIN
			SELECT @KnightsNumber = Knights FROM USERDATA WHERE strUserId = @UserId
			IF @KnightsNumber <> 0
			BEGIN
				ROLLBACK TRAN
				SET @nRet =  5
				RETURN
			END
			UPDATE USERDATA SET Knights = @KnightsIndex, Fame = 5   WHERE strUserId = @UserId	-- TRAINEE
		END
	ELSE IF @Type = 19 or @Type = 20 or @Type = 23	-- WITHDRAW, REMOVE, REJECT
		UPDATE USERDATA SET Knights = 0, Fame = 0  WHERE strUserId = @UserId
	ELSE IF @Type = 22				-- ADMIT
		UPDATE USERDATA SET Fame = 3  WHERE strUserId = @UserId
	ELSE IF @Type = 24				-- Punish
		UPDATE USERDATA SET Fame = 6   WHERE strUserId = @UserId
	ELSE IF @Type = 25				-- Change Chief
		UPDATE USERDATA SET Fame = 1  WHERE strUserId = @UserId
	ELSE IF @Type = 26				-- Change Vice Chief
		UPDATE USERDATA SET Fame = 2  WHERE strUserId = @UserId
	ELSE IF @Type = 27				-- Change Officer
		UPDATE USERDATA SET Fame = 4  WHERE strUserId = @UserId



	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		SET @nRet =  5
		RETURN
	END	*/

COMMIT TRAN
SET @nRet = 0

GO
GO
