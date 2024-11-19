SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Created By Sungyong 2002. 10. 14

CREATE PROCEDURE [dbo].[KNIGHTS_RATING_UPDATE] AS

IF
  EXISTS (
    SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[rating_temp]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1
  )
  DROP TABLE [dbo].[rating_temp]
CREATE TABLE [dbo].[rating_temp] (
  [nRank] [int] IDENTITY (1, 1) NOT NULL,
  [shIndex] [smallint] NULL,
  [strName] [varchar](21) NULL,
  [nPoints] [int] NULL,
) ON [PRIMARY]


INSERT INTO rating_temp SELECT
  IDNum,
  IDName,
  Points
FROM KNIGHTS ORDER BY Points DESC

CREATE INDEX [IX_rating_rank] ON [dbo].[rating_temp] ([nRank]) ON [PRIMARY]
CREATE INDEX [IX_rating_name] ON [dbo].[rating_temp] ([strName]) ON [PRIMARY]

IF
  EXISTS (
    SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[KNIGHTS_RATING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1
  )
  DROP TABLE [dbo].[KNIGHTS_RATING]
EXEC sp_rename 'rating_temp', 'KNIGHTS_RATING'

GO
