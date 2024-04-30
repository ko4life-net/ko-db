SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UPDATE_WAREHOUSE]
  @accountid varchar(21),
  @Money int,
  @dwTime int,
  @byItem binary(1600),
  @bySerial binary(1600)
AS
UPDATE WAREHOUSE
SET
  nMoney = @Money,
  dwTime = @dwTime,
  byItem = @byItem,
  bySerial = @bySerial
WHERE strAccountID = @accountid

GO
