SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[NATION_SELECT]
  @nRet smallint OUTPUT,
  @AccountID char(21),
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
