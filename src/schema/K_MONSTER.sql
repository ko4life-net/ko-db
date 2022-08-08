SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[K_MONSTER](
	[sSid] [smallint] NOT NULL,
	[strName] [varchar](30) NULL,
	[sPid] [smallint] NOT NULL,
	[sSize] [smallint] NOT NULL,
	[iWeapon1] [int] NOT NULL,
	[iWeapon2] [int] NOT NULL,
	[byGroup] [tinyint] NOT NULL,
	[byActType] [tinyint] NOT NULL,
	[byType] [tinyint] NOT NULL,
	[byFamily] [tinyint] NOT NULL,
	[byRank] [tinyint] NOT NULL,
	[byTitle] [tinyint] NOT NULL,
	[iSellingGroup] [int] NOT NULL,
	[sLevel] [smallint] NOT NULL,
	[iExp] [int] NOT NULL,
	[iLoyalty] [int] NOT NULL,
	[sHpPoint] [smallint] NOT NULL,
	[sMpPoint] [smallint] NOT NULL,
	[sAtk] [smallint] NOT NULL,
	[sAc] [smallint] NOT NULL,
	[sHitRate] [smallint] NOT NULL,
	[sEvadeRate] [smallint] NOT NULL,
	[sDamage] [smallint] NOT NULL,
	[sAttackDelay] [smallint] NOT NULL,
	[bySpeed1] [tinyint] NOT NULL,
	[bySpeed2] [tinyint] NOT NULL,
	[sStandtime] [smallint] NOT NULL,
	[iMagic1] [int] NOT NULL,
	[iMagic2] [int] NOT NULL,
	[iMagic3] [int] NOT NULL,
	[byFireR] [tinyint] NOT NULL,
	[byColdR] [tinyint] NOT NULL,
	[byLightningR] [tinyint] NOT NULL,
	[byMagicR] [tinyint] NOT NULL,
	[byDiseaseR] [tinyint] NOT NULL,
	[byPoisonR] [tinyint] NOT NULL,
	[byLightR] [tinyint] NOT NULL,
	[sBulk] [smallint] NOT NULL,
	[byAttackRange] [tinyint] NOT NULL,
	[bySearchRange] [tinyint] NOT NULL,
	[byTracingRange] [tinyint] NOT NULL,
	[iMoney] [int] NOT NULL,
	[sItem] [smallint] NOT NULL,
	[byDirectAttack] [tinyint] NOT NULL,
	[byMagicAttack] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iWeapon2]  DEFAULT ((0)) FOR [iWeapon2]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byGroup]  DEFAULT ((0)) FOR [byGroup]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byActType]  DEFAULT ((0)) FOR [byActType]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byType]  DEFAULT ((0)) FOR [byType]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byFamily]  DEFAULT ((0)) FOR [byFamily]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byRank]  DEFAULT ((0)) FOR [byRank]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byTitle]  DEFAULT ((0)) FOR [byTitle]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iSellingGroup]  DEFAULT ((0)) FOR [iSellingGroup]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sLevel]  DEFAULT ((1)) FOR [sLevel]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iExp]  DEFAULT ((0)) FOR [iExp]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sHpPoint]  DEFAULT ((0)) FOR [sHpPoint]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sMpPoint]  DEFAULT ((0)) FOR [sMpPoint]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sAtk]  DEFAULT ((1)) FOR [sAtk]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sAc]  DEFAULT ((1)) FOR [sAc]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sHitRate]  DEFAULT ((1)) FOR [sHitRate]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sEvadeRate]  DEFAULT ((1)) FOR [sEvadeRate]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sDamage]  DEFAULT ((1)) FOR [sDamage]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sAttackDelay]  DEFAULT ((0)) FOR [sAttackDelay]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_bySpeed1]  DEFAULT ((0)) FOR [bySpeed1]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sStandtime]  DEFAULT ((0)) FOR [sStandtime]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iMagic1]  DEFAULT ((0)) FOR [iMagic1]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iMagic2]  DEFAULT ((0)) FOR [iMagic2]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iMagic3]  DEFAULT ((0)) FOR [iMagic3]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byFireR]  DEFAULT ((0)) FOR [byFireR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byColdR]  DEFAULT ((0)) FOR [byColdR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byLightningR]  DEFAULT ((0)) FOR [byLightningR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byMagicR]  DEFAULT ((0)) FOR [byMagicR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byDiseaseR]  DEFAULT ((0)) FOR [byDiseaseR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byPoisonR]  DEFAULT ((0)) FOR [byPoisonR]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sBulk]  DEFAULT ((0)) FOR [sBulk]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byAttackRange]  DEFAULT ((0)) FOR [byAttackRange]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_bySearchRange]  DEFAULT ((0)) FOR [bySearchRange]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byTracingRange]  DEFAULT ((0)) FOR [byTracingRange]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_iMoney]  DEFAULT ((0)) FOR [iMoney]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_sItem]  DEFAULT ((0)) FOR [sItem]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byDirectAttack]  DEFAULT ((0)) FOR [byDirectAttack]
GO
ALTER TABLE [dbo].[K_MONSTER] ADD  CONSTRAINT [DF_K_MONSTER_byMagicAttack]  DEFAULT ((0)) FOR [byMagicAttack]
GO
