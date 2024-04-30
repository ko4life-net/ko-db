SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CHAR_SELECT]
  @AccountID varchar(21),
  @Password varchar(13),
  @nRet smallint OUTPUT

AS

DECLARE @Nation tinyint, @CharNum smallint
SET @Nation = 0
SET @CharNum = 0

SELECT
  @Nation = bNation,
  @CharNum = bCharNum
FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
IF @@ROWCOUNT = 0 OR @CharNum = 0
  BEGIN
    SET @nRet = 1
    RETURN
  END
ELSE
  BEGIN
    SET @nRet = @Nation + 1
    RETURN
  END
