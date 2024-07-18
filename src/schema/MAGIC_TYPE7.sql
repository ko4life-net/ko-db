SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE7](
	[nIndex] [int] NOT NULL,
	[strName] [char](30) NULL,
	[strNote] [char](100) NULL,
	[byValidGroup] [tinyint] NOT NULL,
	[byNatoinChange] [tinyint] NOT NULL,
	[shMonsterNum] [smallint] NOT NULL,
	[byTargetChange] [tinyint] NOT NULL,
	[byStateChange] [tinyint] NOT NULL,
	[byRadius] [tinyint] NOT NULL,
	[shHitrate] [smallint] NOT NULL,
	[shDuration] [smallint] NOT NULL,
	[shDamage] [smallint] NOT NULL,
	[byVisoin] [tinyint] NOT NULL,
	[nNeedItem] [int] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE7] PRIMARY KEY CLUSTERED 
(
	[nIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
