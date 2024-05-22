-- Alter procedures to uppercase all fetch_status usages.
--
-- Altered procedures:
--   - CHECK_KNIGHTS
--   - EDITER_KNIGHTS
--   - EXEC_KNIGHTS_USER
--   - RANK_KNIGHTS

--------------------------------------------------------------------------------------------------
-- CHECK_KNIGHTS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CHECK_KNIGHTS]
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

--------------------------------------------------------------------------------------------------
-- EDITER_KNIGHTS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Create sungyong

ALTER PROCEDURE [dbo].[EDITER_KNIGHTS]
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
    DECLARE @LEVEL int
    DECLARE @ROW int
    SET @LEVEL = 0

    SELECT @ROW = COUNT([strUserId]) FROM [USERDATA] WHERE Knights = @KnightsIndex
    IF @ROW != 0
      BEGIN
        UPDATE KNIGHTS SET [Members] = @ROW WHERE IDNum = @KnightsIndex
      END
    ELSE
      BEGIN
        DELETE FROM KNIGHTS WHERE IDNum = @KnightsIndex
      END

    FETCH NEXT FROM job1
    INTO @KnightsIndex
  END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF

GO

--------------------------------------------------------------------------------------------------
-- EXEC_KNIGHTS_USER
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- create by sungyong 2002.09.16

ALTER PROCEDURE [dbo].[EXEC_KNIGHTS_USER]
AS

SET NOCOUNT ON
DECLARE @strUserId char(21)
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

--------------------------------------------------------------------------------------------------
-- RANK_KNIGHTS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[RANK_KNIGHTS]
AS

UPDATE KNIGHTS SET Points = 0

SET NOCOUNT ON
DECLARE @KnightsIndex smallint
DECLARE @SumLoyalty int
DECLARE job1 CURSOR FOR

SELECT IDNum FROM KNIGHTS

OPEN job1
FETCH NEXT FROM job1
INTO @KnightsIndex
WHILE @@FETCH_STATUS = 0
  BEGIN

    SET @SumLoyalty = 0
    SELECT @SumLoyalty = SUM(Loyalty) FROM USERDATA WHERE Knights = @KnightsIndex
    IF @SumLoyalty != 0
      UPDATE KNIGHTS SET Points = @SumLoyalty WHERE IDNum = @KnightsIndex

    FETCH NEXT FROM job1
    INTO @KnightsIndex
  END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF

EXEC KNIGHTS_RATING_UPDATE

DECLARE @Knights_1 smallint
DECLARE @Knights_2 smallint
DECLARE @Knights_3 smallint
DECLARE @Knights_4 smallint
DECLARE @Knights_5 smallint

SELECT @Knights_1 = shIndex FROM KNIGHTS_RATING WHERE nRank = 1
SELECT @Knights_2 = shIndex FROM KNIGHTS_RATING WHERE nRank = 2
SELECT @Knights_3 = shIndex FROM KNIGHTS_RATING WHERE nRank = 3
SELECT @Knights_4 = shIndex FROM KNIGHTS_RATING WHERE nRank = 4
SELECT @Knights_5 = shIndex FROM KNIGHTS_RATING WHERE nRank = 5

UPDATE KNIGHTS SET Ranking = 1 WHERE IDNum = @Knights_1
UPDATE KNIGHTS SET Ranking = 2 WHERE IDNum = @Knights_2
UPDATE KNIGHTS SET Ranking = 3 WHERE IDNum = @Knights_3
UPDATE KNIGHTS SET Ranking = 4 WHERE IDNum = @Knights_4
UPDATE KNIGHTS SET Ranking = 5 WHERE IDNum = @Knights_5

GO
