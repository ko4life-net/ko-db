SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- create by sungyong 2002.09.16

CREATE PROCEDURE [dbo].[EXEC_KNIGHTS_USER]
AS

SET NOCOUNT ON
DECLARE @strUserId varchar(21)
DECLARE @KnightsIndex smallint
DECLARE job1 CURSOR FOR

SELECT
  strUserId,
  Knights
FROM USERDATA

OPEN job1
FETCH NEXT FROM job1
INTO @strUserId, @KnightsIndex
WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @KnightsIndex != 0
      BEGIN
        INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@KnightsIndex, @strUserId)
      END

    FETCH NEXT FROM job1
    INTO @strUserId, @KnightsIndex
  END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF

GO
