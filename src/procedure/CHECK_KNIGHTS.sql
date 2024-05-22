﻿SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CHECK_KNIGHTS]
AS

SET NOCOUNT ON
DECLARE @KnightsIndex smallint
DECLARE job1 CURSOR FOR

SELECT IDNum FROM KNIGHTS

OPEN job1
FETCH NEXT FROM job1
INTO @KnightsIndex
WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE @ROW int

    SELECT @ROW = Members FROM [KNIGHTS] WHERE [IDNum] = @KnightsIndex
    IF @ROW = 1
      BEGIN
        BEGIN TRAN
        DELETE FROM KNIGHTS WHERE IDNum = @KnightsIndex

        IF @@ERROR != 0
          BEGIN
            ROLLBACK TRAN
          END
        ELSE
          BEGIN
            UPDATE USERDATA SET Knights = 0, Fame = 0 WHERE Knights = @KnightsIndex
            DELETE FROM KNIGHTS_USER WHERE [sIDNum] = @KnightsIndex
          END
        COMMIT TRAN
      END

    FETCH NEXT FROM job1
    INTO @KnightsIndex
  END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF

GO
