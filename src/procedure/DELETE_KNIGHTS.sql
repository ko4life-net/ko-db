﻿SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DELETE_KNIGHTS]
  @nRet smallint OUTPUT,
  @KnightsIndex smallint
AS

DECLARE @Row tinyint, @Knights smallint, @Fame tinyint, @UserID char(21)
SET @Row = 0 SET @Knights = 0 SET @Fame = 0 SET @UserID = ''



SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @KnightsIndex
IF @Row = 0
  BEGIN
    SET @nRet = 7
    RETURN
  END

BEGIN TRAN

DELETE FROM KNIGHTS WHERE IDNum = @KnightsIndex
DELETE FROM KNIGHTS_USER WHERE sIDNum = @KnightsIndex

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 7
    RETURN
  END

COMMIT TRAN
SET @nRet = 0

GO
