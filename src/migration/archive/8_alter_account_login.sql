SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
    BEGIN TRAN
    INSERT INTO TB_USER (strAccountID, strPasswd, strSocNo)
    VALUES (@AccountID, @Password, 1)
    COMMIT TRAN
    SET @nRet = 1
    RETURN
  END

ELSE IF @pwd != @Password
  BEGIN
    SET @nRet = 3
    RETURN
  END

SET @nRet = 1 -- success
