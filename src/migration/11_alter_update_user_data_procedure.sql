SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[UPDATE_USER_DATA]
  @id varchar(21),
  @Nation tinyint,
  @Race tinyint,
  @Class smallint,
  @HairColor tinyint,
  @Rank tinyint,
  @Title tinyint,
  @Level tinyint,
  @Exp int,
  @Loyalty int,
  @Face tinyint,
  @City tinyint,
  @Knights smallint,
  @Fame tinyint,
  @Hp smallint,
  @Mp smallint,
  @Sp smallint,
  @Str tinyint,
  @Sta tinyint,
  @Dex tinyint,
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
  @dwTime int,
  @bySkill binary(10),
  @byItem binary(400),
  @bySerial binary(400)
AS

DECLARE @KnightsIndex smallint

IF @Zone > 2		-- battle zone user
  BEGIN
    SELECT @KnightsIndex = Knights FROM USERDATA WHERE strUserId = @id
    IF @KnightsIndex = -1	-- expel user
      BEGIN
        SET @Knights = 0
        SET @Fame = 0
      END
  END

UPDATE USERDATA
SET
  Nation = @Nation,
  Race = @Race,
  [Class] = @Class,
  HairColor = @HairColor,
  Rank = @Rank,
  Title = @Title,
  [Level] = @Level,
  [Exp] = @Exp,
  Loyalty = @Loyalty,
  Face = @Face,
  City = @City,
  Knights = @Knights,
  Fame = @Fame,
  Hp = @Hp,
  Mp = @Mp,
  Sp = @Sp,
  Strong = @Str,
  Sta = @Sta,
  Dex = @Dex,
  Intel = @Intel,
  Cha = @Cha,
  Authority = @Authority,
  Points = @Points,
  Gold = @Gold,
  [Zone] = @Zone,
  Bind = @Bind,
  PX = @PX,
  PZ = @PZ,
  PY = @PY,
  dwTime = @dwTime,
  bySkill = @bySkill,
  byItem = @byItem,
  bySerial = @bySerial
WHERE strUserId = @id
