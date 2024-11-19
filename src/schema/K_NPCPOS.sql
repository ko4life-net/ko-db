SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[K_NPCPOS](
	[ZoneID] [smallint] NOT NULL,
	[NpcID] [int] NOT NULL,
	[ActType] [tinyint] NOT NULL,
	[RegenType] [tinyint] NULL,
	[DungeonFamily] [tinyint] NULL,
	[SpecialType] [tinyint] NULL,
	[TrapNumber] [tinyint] NULL,
	[LeftX] [int] NOT NULL,
	[TopZ] [int] NOT NULL,
	[RightX] [int] NOT NULL,
	[BottomZ] [int] NOT NULL,
	[LimitMinX] [int] NULL,
	[LimitMinZ] [int] NULL,
	[LimitMaxX] [int] NULL,
	[LimitMaxZ] [int] NULL,
	[NumNPC] [tinyint] NOT NULL,
	[RegTime] [smallint] NOT NULL,
	[DotCnt] [tinyint] NOT NULL,
	[path] [varchar](3000) NULL
) ON [PRIMARY]
GO
