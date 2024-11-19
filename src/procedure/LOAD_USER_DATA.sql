﻿SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[LOAD_USER_DATA]
  @id varchar(21),
  @nRet smallint OUTPUT
AS

SET @nRet = 0

SELECT @nRet = COUNT(strUserId) FROM USERDATA WHERE strUserId = @id
IF @nRet = 0
  RETURN

  SELECT
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
  FROM USERDATA WHERE strUserId = @id

SET @nRet = 1
RETURN

GO
