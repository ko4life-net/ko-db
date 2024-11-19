-- Migrates legacy text columns to varchar(3000), which should be big enough to store really long NPC paths
-- Also organized K_NPCPOS table

CREATE TABLE [dbo].[K_NPCPOS_TMP] (
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
  [path] [varchar](3000) NULL -- Changed from ntext to varchar(3000)
);

INSERT INTO [dbo].[K_NPCPOS_TMP] (
  [ZoneID], [NpcID], [ActType], [RegenType], [DungeonFamily], [SpecialType], [TrapNumber],
  [LeftX], [TopZ], [RightX], [BottomZ], [LimitMinX], [LimitMinZ], [LimitMaxX], [LimitMaxZ],
  [NumNPC], [RegTime], [DotCnt], [path]
)
SELECT
  [ZoneID],
  [NpcID],
  [ActType],
  [RegenType],
  [DungeonFamily],
  [SpecialType],
  [TrapNumber],
  [LeftX],
  [TopZ],
  [RightX],
  [BottomZ],
  [LimitMinX],
  [LimitMinZ],
  [LimitMaxX],
  [LimitMaxZ],
  [NumNPC],
  [RegTime],
  [DotCnt],
  CAST([path] AS varchar(3000)) -- Convert ntext to varchar
FROM [dbo].[K_NPCPOS];

DROP TABLE [dbo].[K_NPCPOS];
EXEC sp_rename 'dbo.K_NPCPOS_TMP', 'K_NPCPOS';

-- Drop unused text column
ALTER TABLE [dbo].[K_NPC] DROP COLUMN [Obs];
