SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE6](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NOT NULL,
	[Description] [char](100) NULL,
	[Size] [smallint] NOT NULL,
	[TransformID] [smallint] NOT NULL,
	[Duration] [smallint] NOT NULL,
	[MaxHp] [smallint] NOT NULL,
	[MaxMp] [smallint] NOT NULL,
	[Speed] [tinyint] NOT NULL,
	[AttackSpeed] [smallint] NOT NULL,
	[TotalHit] [smallint] NOT NULL,
	[TotalAc] [smallint] NOT NULL,
	[TotalHitRate] [smallint] NOT NULL,
	[TotalEvasionRate] [smallint] NOT NULL,
	[TotalFireR] [smallint] NOT NULL,
	[TotalColdR] [smallint] NOT NULL,
	[TotalLightningR] [smallint] NOT NULL,
	[TotalMagicR] [smallint] NOT NULL,
	[TotalDiseaseR] [smallint] NOT NULL,
	[TotalPoisonR] [smallint] NOT NULL,
	[Class] [smallint] NOT NULL,
	[UserSkillUse] [tinyint] NOT NULL,
	[NeedItem] [tinyint] NOT NULL,
	[SkillSuccessRate] [tinyint] NOT NULL,
	[MonsterFriendly] [tinyint] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE6] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAGIC_TYPE6] ADD  CONSTRAINT [DF_MAGIC_TYPE6_MonsterFriendly]  DEFAULT ((0)) FOR [MonsterFriendly]
GO
