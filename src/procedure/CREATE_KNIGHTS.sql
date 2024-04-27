SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CREATE_KNIGHTS]

@nRet		smallint OUTPUT, 
@index 		smallint,
@nation		tinyint,
@community	tinyint,
@strName 	char(21), 
@strChief	char(21)

AS

DECLARE @Row tinyint, @knightsindex smallint, @knightsname char(21)
	SET @Row = 0	SET @knightsindex = 0  SET @knightsname = ''

	SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @index or  IDName = @strName
	
	IF @Row > 0 or @index = 0
	BEGIN
		SET @nRet =  3
		RETURN
	END

	--SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDName = @strName
	
	--IF @Row > 0
--	BEGIN
	--	SET @nRet =  3
		--RETURN
--	END
	
BEGIN TRAN	

	INSERT INTO KNIGHTS ( IDNum, Nation, Flag, IDName, Chief  ) 
	VALUES	 (@index, @nation, @community, @strName, @strChief )

	INSERT INTO KNIGHTS_USER ( sIDNum, strUserID  ) 
	VALUES	 (@index,  @strChief )
	
	IF @@ERROR <> 0
	BEGIN	 
		ROLLBACK TRAN 
		SET @nRet =  6
		RETURN
	END

--	UPDATE USERDATA SET Knights = @index, Fame = 1 WHERE strUserId = @strChief	-- 1 == Chief Authority
	
	IF @@ERROR <> 0
	BEGIN	 
		ROLLBACK TRAN 
		SET @nRet =  6
		RETURN
	END

COMMIT TRAN
SET @nRet =  0


GO
