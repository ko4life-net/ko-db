SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE1](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NULL,
	[Description] [char](100) NULL,
	[Type] [tinyint] NOT NULL,
	[HitRate] [smallint] NOT NULL,
	[Hit] [smallint] NOT NULL,
	[Delay] [tinyint] NOT NULL,
	[ComboType] [tinyint] NOT NULL,
	[ComboCount] [tinyint] NOT NULL,
	[ComboDamage] [smallint] NOT NULL,
	[Range] [smallint] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE1] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
