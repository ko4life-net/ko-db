SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CREATE_NEW_CHAR]

@nRet		smallint OUTPUT, 
@AccountID 	char(21), 
@index 		tinyint,
@CharID	char(21),
@Race 		tinyint, 
@Class 	smallint, 
@Hair 		tinyint,
@Face 		tinyint, 
@Str 		tinyint, 
@Sta 		tinyint, 
@Dex 		tinyint,
@Intel 		tinyint, 
@Cha 		tinyint

AS

DECLARE @Row tinyint, @Nation tinyint, @Zone tinyint, @PosX int, @PosZ int
	SET @Row = 0	SET @Nation = 0  SET @Zone = 0  SET @PosX = 0 SET @PosZ = 0

	SELECT @Nation = bNation, @Row = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
	
	IF @Row >= 5	SET @nRet =  1
	
	IF @Nation = 1 AND @Race > 10	SET @nRet = 2
	ELSE IF @Nation = 2 AND @Race < 10	SET @nRet = 2
	ELSE IF @Nation <>1 AND @Nation <> 2	SET @nRet = 2

	IF @nRet > 0
		RETURN
	
	SELECT @Row = COUNT(*) FROM USERDATA WHERE strUserId = @CharID
	IF @Row > 0 
	BEGIN
		SET @nRet =  3
		RETURN
	END

	SET @Zone = @Nation
	SELECT @PosX = InitX, @PosZ = InitZ  FROM ZONE_INFO WHERE ZoneNo = @Zone

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
	

	INSERT INTO USERDATA (strUserId, Nation, Race, Class, HairColor, Face, Strong, Sta, Dex, Intel, Cha, Zone, PX, PZ ) 
	VALUES	 (@CharID, @Nation, @Race, @Class, @Hair, @Face, @Str, @Sta, @Dex, @Intel, @Cha, @Zone, @PosX, @PosZ )
	
	
	IF @@ERROR <> 0
	BEGIN	 
		ROLLBACK TRAN 
		SET @nRet =  4
		RETURN
	END
	
COMMIT TRAN
SET @nRet =  0
GO
