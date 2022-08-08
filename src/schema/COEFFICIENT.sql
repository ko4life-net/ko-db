SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COEFFICIENT](
	[sClass] [smallint] NOT NULL,
	[ShortSword] [float] NOT NULL,
	[Sword] [float] NOT NULL,
	[Axe] [float] NOT NULL,
	[Club] [float] NOT NULL,
	[Spear] [float] NOT NULL,
	[Pole] [float] NOT NULL,
	[Staff] [float] NOT NULL,
	[Bow] [float] NULL,
	[Hp] [float] NOT NULL,
	[Mp] [float] NOT NULL,
	[Sp] [float] NOT NULL,
	[Ac] [float] NOT NULL,
	[Hitrate] [float] NOT NULL,
	[Evasionrate] [float] NOT NULL
) ON [PRIMARY]
GO
