SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[BACKUP_WAREHOUSE] AS

DECLARE	@WarehouseData varchar(1600), @strAccountID char(21), @nMoney int

BEGIN TRAN	

	SELECT @WarehouseData = WarehouseData, @nMoney = nMoney
	FROM BK_MON_WAREHOUSE WHERE strAccountID = '97414061'     -- 이 부분은 이름만 수정하면 되요, 날짜두요 ^^;

	INSERT INTO WAREHOUSE (strAccountID, nMoney, WarehouseData )

	VALUES ('97414061', @nMoney, @WarehouseData) 
			
COMMIT TRAN



GO
