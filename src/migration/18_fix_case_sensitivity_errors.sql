-- Fixes an issue with some dbs that their default installation collation is case-sensitive (_CS).
-- Also note that we found out about this issue because of some user using Turkish_CI_AS collation and after changing
-- the all @KnightsIndex instances to use the same case-sensitivity, the problem was fixed. However twostars figured out
-- that the actual cause of this issue is when using `i` in a db that has Turkish collation, because in Turkish `i` is not
-- `I`, hence it didn't see them as the same variables (declaration and usages), even when the user collation was case-insensitive (_CI).
-- twostars actually tested this on a VM with the same setup to verify, since this was indeed an odd issue.
--
-- Altered procedures:
--   - CHECK_KNIGHTS
--   - DELETE_CHAR
--   - EDITER_KNIGHTS
--   - EXEC_KNIGHTS_USER
--   - LOAD_CHAR_INFO
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
WHILE @@fetch_status = 0
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
-- DELETE_CHAR
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[DELETE_CHAR]
  @AccountID char(21),
  @index tinyint,
  @CharID char(21),
  @SocNo char(15),
  @nRet smallint OUTPUT
AS

DECLARE
  @bCharNum tinyint,
  @charid1 char(21),
  @charid2 char(21),
  @charid3 char(21),
  @charid4 char(21),
  @charid5 char(21),
  @strSocNo char(15)
DECLARE @knightsindex smallint
SET @bCharNum = 0
SET @knightsindex = 0

SELECT @strSocNo = strSocNo FROM [dbo].[TB_USER] WHERE strAccountID = @AccountID
IF @SocNo != @strSocNo
  BEGIN
    SET @nRet = 0
    RETURN
  END

DECLARE
  @Nation tinyint,
  @Race tinyint,
  @Class smallint,
  @HairColor tinyint,
  @Rank tinyint,
  @Title tinyint,
  @Level tinyint,
  @Exp int,
  @Loyalty int
DECLARE
  @Face tinyint,
  @City tinyint,
  @Knights smallint,
  @Fame tinyint,
  @Hp smallint,
  @Mp smallint,
  @Sp smallint,
  @Strong tinyint,
  @Sta tinyint,
  @Dex tinyint
DECLARE
  @Intel tinyint,
  @Cha tinyint,
  @Authority tinyint,
  @Points tinyint,
  @Gold int,
  @Zone tinyint,
  @Bind smallint,
  @PX int,
  @PZ int,
  @PY int,
  @dwTime int
DECLARE @bySkill binary(10), @byItem binary(400), @bySerial binary(400), @Members smallint

BEGIN TRAN

IF @index = 0
  UPDATE ACCOUNT_CHAR SET strCharID1 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 1
  UPDATE ACCOUNT_CHAR SET strCharID2 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 2
  UPDATE ACCOUNT_CHAR SET strCharID3 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 3
  UPDATE ACCOUNT_CHAR SET strCharID4 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 4
  UPDATE ACCOUNT_CHAR SET strCharID5 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 0
    RETURN
  END

SELECT
  @charid1 = strCharID1,
  @charid2 = strCharID2,
  @charid3 = strCharID3,
  @charid4 = strCharID4,
  @charid5 = strCharID5
FROM ACCOUNT_CHAR
WHERE strAccountID = @AccountID
-- 캐릭터가 하나도 없으면 해당 레코드를 지운다.. -> 국가선택 다시 할수 있다
IF @charid1 IS NULL AND @charid2 IS NULL AND @charid3 IS NULL AND @charid4 IS NULL AND @charid5 IS NULL
  BEGIN
    DELETE FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
    IF @@ERROR != 0
      BEGIN
        ROLLBACK TRAN
        SET @nRet = 0
        RETURN
      END
  END

SELECT
  @Nation = Nation,
  @Race = Race,
  @Class = [Class],
  @HairColor = HairColor,
  @Rank = Rank,
  @Title = Title,
  @Level = [Level],
  @Exp = [Exp],
  @Loyalty = Loyalty,
  @Face = Face,
  @City = City,
  @Knights = Knights,
  @Fame = Fame,
  @Hp = Hp,
  @Mp = Mp,
  @Sp = Sp,
  @Strong = Strong,
  @Sta = Sta,
  @Dex = Dex,
  @Intel = Intel,
  @Cha = Cha,
  @Authority = Authority,
  @Points = Points,
  @Gold = Gold,
  @Zone = [Zone],
  @Bind = Bind,
  @PX = PX,
  @PZ = PZ,
  @PY = PY,
  @dwTime = dwTime,
  @bySkill = bySkill,
  @byItem = byItem,
  @bySerial = bySerial
FROM USERDATA WHERE strUserId = @CharID

INSERT INTO DELETED_USERDATA (
  strAccountID,
  strUserId,
  Nation,
  Race,
  [Class],
  HairColor,
  Rank,
  Title,
  [Level],
  [Exp],
  Loyalty,
  Face,
  City,
  Knights,
  Fame,
  Hp,
  Mp,
  Sp,
  Strong,
  Sta,
  Dex,
  Intel,
  Cha,
  Authority,
  Points,
  Gold,
  [Zone],
  Bind,
  PX,
  PZ,
  PY,
  dwTime,
  bySkill,
  byItem,
  bySerial
)
VALUES (
  @AccountID,
  @CharID,
  @Nation,
  @Race,
  @Class,
  @HairColor,
  @Rank,
  @Title,
  @Level,
  @Exp,
  @Loyalty,
  @Face,
  @City,
  @Knights,
  @Fame,
  @Hp,
  @Mp,
  @Sp,
  @Strong,
  @Sta,
  @Dex,
  @Intel,
  @Cha,
  @Authority,
  @Points,
  @Gold,
  @Zone,
  @Bind,
  @PX,
  @PZ,
  @PY,
  @dwTime,
  @bySkill,
  @byItem,
  @bySerial
)

DELETE FROM USERDATA WHERE strUserId = @CharID
IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 0
    RETURN
  END

DELETE FROM KNIGHTS_USER WHERE strUserID = @CharID
SELECT @Members = Members FROM KNIGHTS WHERE IDNum = @Knights
IF @Members <= 1
  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @Knights
ELSE
  UPDATE KNIGHTS SET Members = Members - 1 WHERE IDNum = @Knights

COMMIT TRAN
SET @nRet = 1

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
WHILE @@fetch_status = 0
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
WHILE @@fetch_status = 0
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
-- LOAD_CHAR_INFO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- Scripted by Samma
-- 2002.01.18

ALTER PROCEDURE [dbo].[LOAD_CHAR_INFO]
  @CharId char(21),
  @nRet smallint OUTPUT
AS

SELECT @nRet = COUNT(strUserId) FROM USERDATA WHERE strUserId = @CharId
IF @nRet = 0
  RETURN

  SELECT
    Race,
    [Class],
    HairColor,
    [Level],
    Face,
    Zone,
    byItem
  FROM USERDATA WHERE strUserId = @CharId

SET @nRet = 1
RETURN

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
WHILE @@fetch_status = 0
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
