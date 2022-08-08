SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE3](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NULL,
	[Description] [char](100) NULL,
	[Radius] [tinyint] NOT NULL,
	[Angle] [smallint] NOT NULL,
	[DirectType] [tinyint] NOT NULL,
	[FirstDamage] [smallint] NOT NULL,
	[EndDamage] [smallint] NOT NULL,
	[TimeDamage] [smallint] NOT NULL,
	[Duration] [tinyint] NOT NULL,
	[Attribute] [tinyint] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE3] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
