SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE9](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NULL,
	[Description] [char](100) NULL,
	[ValidGroup] [tinyint] NOT NULL,
	[NationChange] [tinyint] NOT NULL,
	[MonsterNum] [smallint] NOT NULL,
	[TargetChange] [tinyint] NOT NULL,
	[StateChange] [tinyint] NOT NULL,
	[Radius] [smallint] NOT NULL,
	[Hitrate] [smallint] NOT NULL,
	[Duration] [smallint] NOT NULL,
	[AddDamage] [smallint] NOT NULL,
	[Vision] [smallint] NOT NULL,
	[NeedItem] [int] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE9] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
