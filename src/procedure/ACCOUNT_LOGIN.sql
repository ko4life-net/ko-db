SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ACCOUNT_LOGIN]
@AccountID	varchar(21),
@Password	varchar(13),
@nRet		smallint	OUTPUT

AS


DECLARE @Nation tinyint, @CharNum smallint
SET @Nation = 0
SET @CharNum = 0

DECLARE @pwd varchar(13)

SET @pwd = null

SELECT @pwd = strPasswd FROM [dbo].[TB_USER] WHERE strAccountID = @AccountID
IF @pwd IS null
BEGIN
	SET @nRet = 0
	RETURN
END

ELSE IF @pwd <> @Password
BEGIN
	SET @nRet = 0
	RETURN
END

SELECT @Nation = bNation, @CharNum = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
IF @@ROWCOUNT = 0
BEGIN
	SET @nRet = 1
	RETURN
END
IF @CharNum = 0
BEGIN
	SET @nRet = 1
	RETURN
END
ELSE 
BEGIN
	SET @nRet = @Nation+1
	RETURN
END



GO
