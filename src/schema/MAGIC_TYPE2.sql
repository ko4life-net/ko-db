﻿SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE2](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NOT NULL,
	[Description] [char](100) NULL,
	[HitType] [tinyint] NOT NULL,
	[HitRate] [smallint] NOT NULL,
	[AddDamage] [smallint] NOT NULL,
	[AddRange] [smallint] NOT NULL,
	[NeedArrow] [tinyint] NOT NULL,
	[AddDamagePlus] [smallint] NULL,
 CONSTRAINT [PK_MAGIC_TYPE2] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
