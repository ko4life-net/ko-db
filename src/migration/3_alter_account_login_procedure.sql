SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ACCOUNT_LOGIN]
  @AccountID varchar(21),
  @Password varchar(13),
  @nRet smallint OUTPUT

AS

DECLARE @pwd varchar(13)

SET @pwd = NULL

SELECT @pwd = strPasswd FROM [dbo].[TB_USER] WHERE strAccountID = @AccountID
IF @pwd IS NULL
  BEGIN
    SET @nRet = 2
    RETURN
  END

ELSE IF @pwd != @Password
  BEGIN
    SET @nRet = 3
    RETURN
  END

SET @nRet = 1 -- success
