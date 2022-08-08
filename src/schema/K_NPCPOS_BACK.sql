SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[K_NPCPOS_BACK](
	[ZoneID] [smallint] NOT NULL,
	[NpcID] [int] NOT NULL,
	[ActType] [tinyint] NOT NULL,
	[LeftX] [int] NOT NULL,
	[TopZ] [int] NOT NULL,
	[RightX] [int] NOT NULL,
	[BottomZ] [int] NOT NULL,
	[NumNPC] [tinyint] NOT NULL,
	[RegTime] [smallint] NOT NULL,
	[DotCnt] [tinyint] NOT NULL,
	[path] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
