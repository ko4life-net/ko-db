SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_KNIGHTS]

  @nRet smallint OUTPUT,
  @Type tinyint,
  @UserId char(21),
  @KnightsIndex smallint,
  @Domanation tinyint

AS

DECLARE @Row tinyint
DECLARE @Members tinyint
DECLARE @KnightsNumber smallint
DECLARE @ViceChief_1 char(21)
DECLARE @ViceChief_2 char(21)
DECLARE @ViceChief_3 char(21)
SET @Row = 0
SET @KnightsNumber = 0

SELECT @Row = COUNT(*) FROM KNIGHTS WHERE IDNum = @KnightsIndex

IF @Row = 0
  BEGIN
    SET @nRet = 7
    RETURN
  END

SELECT
  @Members = Members,
  @ViceChief_1 = ViceChief_1,
  @ViceChief_2 = ViceChief_2,
  @ViceChief_3 = ViceChief_3
FROM KNIGHTS
WHERE IDNum = @KnightsIndex
IF @Members >= 24
  BEGIN
    SET @nRet = 8
    RETURN
  END

SELECT @Row = COUNT(*) FROM USERDATA WHERE strUserId = @UserId
IF @Row = 0
  BEGIN
    SET @nRet = 2
    RETURN
  END

--SELECT @ViceChief_1=ViceChief_1, @ViceChief_2=ViceChief_2, @ViceChief_3=ViceChief_3  FROM KNIGHTS WHERE IDNum = @KnightsIndex	

BEGIN TRAN
IF @Type = 18					-- JOIN
  BEGIN
    UPDATE KNIGHTS SET Members = Members + 1 WHERE IDNum = @KnightsIndex
    INSERT INTO KNIGHTS_USER (sIDNum, strUserID) VALUES (@KnightsIndex, @UserId)
  END
ELSE IF @Type = 19 OR @Type = 20 OR @Type = 23	-- WITHDRAW, REMOVE, REJECT
  BEGIN
    IF @Members <= 1
      UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @KnightsIndex
    ELSE
      UPDATE KNIGHTS SET Members = Members - 1 WHERE IDNum = @KnightsIndex
    DELETE FROM KNIGHTS_USER WHERE strUserID = @UserId
    IF @ViceChief_1 = @UserId
      UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_2 = @UserId
      UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_3 = @UserId
      UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @KnightsIndex
  END
ELSE IF @Type = 25				-- Change Chief, 부단장중에 한명이 단장으로 승격시에는 부단장 데이타변수에서 부단장 이름을 빼준다
  BEGIN
    UPDATE KNIGHTS SET Chief = @UserId WHERE IDNum = @KnightsIndex
    IF @ViceChief_1 = @UserId
      UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_2 = @UserId
      UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @KnightsIndex
    IF @ViceChief_3 = @UserId
      UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @KnightsIndex
  END
ELSE IF @Type = 26				-- Change Vice Chief
  BEGIN
    IF @ViceChief_1 IS NOT NULL AND @ViceChief_2 IS NOT NULL AND @ViceChief_3 IS NOT NULL
      BEGIN
        SET @nRet = 8
        COMMIT TRAN
        RETURN
      END

    IF @ViceChief_1 IS NULL
      UPDATE KNIGHTS SET ViceChief_1 = @UserId WHERE IDNum = @KnightsIndex
    ELSE IF @ViceChief_2 IS NULL
      UPDATE KNIGHTS SET ViceChief_2 = @UserId WHERE IDNum = @KnightsIndex
    ELSE IF @ViceChief_3 IS NULL
      UPDATE KNIGHTS SET ViceChief_3 = @UserId WHERE IDNum = @KnightsIndex
  END
--	ELSE IF @Type = 27				-- Change Officer
--	UPDATE KNIGHTS SET ViceChief_2 = @UserId WHERE IDNum = @KnightsIndex

IF @@ERROR != 0
  BEGIN
    ROLLBACK TRAN
    SET @nRet = 2
    RETURN
  END

IF @Type = 20	-- REMOVE
  UPDATE USERDATA SET Knights = -1, Fame = 0 WHERE strUserId = @UserId
/*
	IF @Type = 18
		BEGIN
			SELECT @KnightsNumber = Knights FROM USERDATA WHERE strUserId = @UserId
			IF @KnightsNumber <> 0
			BEGIN
				ROLLBACK TRAN
				SET @nRet =  5
				RETURN
			END
			UPDATE USERDATA SET Knights = @KnightsIndex, Fame = 5   WHERE strUserId = @UserId	-- TRAINEE
		END
	ELSE IF @Type = 19 or @Type = 20 or @Type = 23	-- WITHDRAW, REMOVE, REJECT
		UPDATE USERDATA SET Knights = 0, Fame = 0  WHERE strUserId = @UserId
	ELSE IF @Type = 22				-- ADMIT
		UPDATE USERDATA SET Fame = 3  WHERE strUserId = @UserId
	ELSE IF @Type = 24				-- Punish
		UPDATE USERDATA SET Fame = 6   WHERE strUserId = @UserId
	ELSE IF @Type = 25				-- Change Chief
		UPDATE USERDATA SET Fame = 1  WHERE strUserId = @UserId
	ELSE IF @Type = 26				-- Change Vice Chief
		UPDATE USERDATA SET Fame = 2  WHERE strUserId = @UserId
	ELSE IF @Type = 27				-- Change Officer
		UPDATE USERDATA SET Fame = 4  WHERE strUserId = @UserId



	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		SET @nRet =  5
		RETURN
	END	*/

COMMIT TRAN
SET @nRet = 0

GO
