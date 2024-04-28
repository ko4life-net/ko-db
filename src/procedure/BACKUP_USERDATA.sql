SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[BACKUP_USERDATA] AS

DECLARE	@Rank tinyint, @Title tinyint, @Level tinyint
DECLARE	@Exp int, @Loyalty int
DECLARE	@Knights smallint, @Fame tinyint, @Strong tinyint, @Sta tinyint, @Dex tinyint
DECLARE	@Intel tinyint, @Cha tinyint, @Points tinyint, @Gold int, @Zone tinyint
DECLARE	@strSkill varchar(20), @strItem varchar(400)

BEGIN TRAN	

	SELECT @Rank = Rank, @Title = Title, @Level = [Level], @Exp = [Exp], @Loyalty = Loyalty, @Knights = Knights, @Fame = Fame, 
		 @Strong = Strong, @Sta = Sta, @Dex = Dex, @Intel = Intel, @Cha = Cha, 
		 @Points = Points, @Gold = Gold,@strSkill = strSkill, @strItem = strItem
	FROM BK_TUE_USERDATA /*날짜 확인*/ WHERE strUserId = '나여요'     -- 이 부분은 이름만 수정하면 되요 ^^;

	INSERT INTO USERDATA (strUserID, Nation, Race, Class, HairColor, Rank, Title, [Level], [Exp], Loyalty, Face, City,
				      Knights, Fame, Hp, Mp, Sp, Strong, Sta, Dex, Intel, Cha, Authority, Points, Gold, [Zone], Bind, PX, PZ, PY, strSkill, strItem )

	VALUES (/*@Char*/'나여요' , /*@Nation*/ 2, /*@Race*/ 1, /*@Class*/ 201, /*@HairColor*/ 0, @Rank, @Title, @Level, @Exp,
 		   @Loyalty, /* @Face*/0, /*@City*/0, @Knights, @Fame, /*@Hp*/100, /*@Mp*/100, /*@Sp*/100, @Strong, @Sta, @Dex, @Intel, @Cha,
 		  /*@Authority*/1, @Points, @Gold, /*@Zone*/2, /*@Bind*/ -1, /*@PX*/50000, /*@PZ*/50000, /*@PY*/0, @strSkill, CAST(@strItem as binary(400)) ) 
		
	
COMMIT TRAN



GO
