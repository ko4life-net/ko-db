SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOME](
	[Nation] [tinyint] NOT NULL,
	[ElmoZoneX] [int] NOT NULL,
	[ElmoZoneZ] [int] NOT NULL,
	[ElmoZoneLX] [tinyint] NOT NULL,
	[ElmoZoneLZ] [tinyint] NOT NULL,
	[KarusZoneX] [int] NOT NULL,
	[KarusZoneZ] [int] NOT NULL,
	[KarusZoneLX] [tinyint] NOT NULL,
	[KarusZoneLZ] [tinyint] NOT NULL,
	[FreeZoneX] [int] NOT NULL,
	[FreeZoneZ] [int] NOT NULL,
	[FreeZoneLX] [tinyint] NOT NULL,
	[FreeZoneLZ] [tinyint] NOT NULL,
	[BattleZoneX] [int] NOT NULL,
	[BattleZoneZ] [int] NOT NULL,
	[BattleZoneLX] [tinyint] NOT NULL,
	[BattleZoneLZ] [tinyint] NOT NULL
) ON [PRIMARY]
GO
