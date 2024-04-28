SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[EXEC_SEARCH_USER_ITEM]
AS

SET NOCOUNT ON
DECLARE @strUserID char(21)
DECLARE @strItem binary(400)
DECLARE job1 CURSOR FOR

SELECT strUserID, strItem FROM USERDATA

OPEN job1
FETCH NEXT FROM job1
INTO @strUserID, @strItem
WHILE @@fetch_status = 0 
BEGIN
	DECLARE @strAccountID char(21)
	DECLARE @strWareHouse char(1600)

	SELECT @strAccountID=strAccountID FROM ACCOUNT_CHAR WHERE @struserid=strCharID1 or @struserid=strCharID2 or @struserid=strCharID3
	SELECT @strWareHouse=WarehouseData FROM WAREHOUSE WHERE strAccountID=@strAccountID

	INSERT INTO SEARCH_USERDATA (strUserId, strAccountID, strItem, strWarehouseData ) 
	VALUES	 (@strUserID, @strAccountID, @strItem, @strWareHouse )

	
	FETCH NEXT FROM job1
	INTO @strUserID, @strItem
END
CLOSE job1
DEALLOCATE job1
SET NOCOUNT OFF


GO
