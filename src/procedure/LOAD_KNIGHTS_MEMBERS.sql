﻿SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Scripted by Sungyong
-- 2002.09.26

CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_MEMBERS]
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
