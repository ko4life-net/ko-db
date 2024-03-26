SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LOAD_CHAR_INFO]
@CharId	char(21),
@nRet	smallint OUTPUT
AS

SELECT @nRet = COUNT(strUserId) FROM USERDATA WHERE strUserId = @CharId
IF @nRet = 0
	RETURN

SELECT Race, Class, HairColor, [Level], Face, Zone, bItem FROM USERDATA WHERE strUserID = @CharId

SET @nRet = 1
RETURN
