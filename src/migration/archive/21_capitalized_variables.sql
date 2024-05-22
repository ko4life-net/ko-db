-- Capitalizing few more instances of @KnightsIndex and @KnightsName.
--
-- Altered procedures:
--   - CREATE_KNIGHTS
--   - DELETE_CHAR
--   - DELETE_KNIGHTS
--   - LOAD_KNIGHTS_MEMBERS

--------------------------------------------------------------------------------------------------
-- CREATE_KNIGHTS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CREATE_KNIGHTS]
  @nRet smallint OUTPUT,
  @index smallint,
  @nation tinyint,
  @community tinyint,
  @strName char(21),
  @strChief char(21)
AS

DECLARE @Row tinyint, @KnightsIndex smallint, @KnightsName char(21)
SET @Row = 0 SET @KnightsIndex = 0 SET @KnightsName = ''

SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @index OR IDName = @strName

IF @Row > 0 OR @index = 0
  BEGIN
    SET @nRet = 3
    RETURN
  END

--SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDName = @strName

--IF @Row > 0
--	BEGIN
--	SET @nRet =  3
--RETURN
--	END

BEGIN TRAN

INSERT INTO KNIGHTS (IDNum, Nation, Flag, IDName, Chief)
VALUES (@index, @nation, @community, @strName, @strChief)

INSERT INTO KNIGHTS_USER (sIDNum, strUserID)
VALUES (@index, @strChief)

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 6
    RETURN
  END

--	UPDATE USERDATA SET Knights = @index, Fame = 1 WHERE strUserId = @strChief	-- 1 == Chief Authority

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 6
    RETURN
  END

COMMIT TRAN
SET @nRet = 0

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
DECLARE @KnightsIndex smallint
SET @bCharNum = 0
SET @KnightsIndex = 0

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
-- DELETE_KNIGHTS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[DELETE_KNIGHTS]
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

--------------------------------------------------------------------------------------------------
-- LOAD_KNIGHTS_MEMBERS
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Scripted by Sungyong
-- 2002.09.26

ALTER PROCEDURE [dbo].[LOAD_KNIGHTS_MEMBERS]
  @KnightsIndex smallint
AS

SELECT
  strUserId,
  Fame,
  [Level],
  [Class]
FROM USERDATA WHERE Knights = @KnightsIndex

--SET @nRet = 1
--RETURN

GO
