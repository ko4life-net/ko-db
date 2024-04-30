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
  UPDATE ACCOUNT_CHAR SET strCHARID1 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 1
  UPDATE ACCOUNT_CHAR SET strCHARID2 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 2
  UPDATE ACCOUNT_CHAR SET strCHARID3 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 3
  UPDATE ACCOUNT_CHAR SET strCHARID4 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID
IF @index = 4
  UPDATE ACCOUNT_CHAR SET strCHARID5 = NULL, bCharNum = bCharNum - 1 WHERE strAccountID = @AccountID

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 0
    RETURN
  END

SELECT
  @charid1 = strCHARID1,
  @charid2 = strCHARID2,
  @charid3 = strCHARID3,
  @charid4 = strCHARID4,
  @charid5 = strCHARID5
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
  strUserID,
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

DELETE FROM KNIGHTS_USER WHERE strUserId = @CharID
SELECT @Members = Members FROM KNIGHTS WHERE IDNum = @Knights
IF @Members <= 1
  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @Knights
ELSE
  UPDATE KNIGHTS SET Members = Members - 1 WHERE IDNum = @Knights

COMMIT TRAN
SET @nRet = 1

GO
