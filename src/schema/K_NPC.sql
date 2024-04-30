SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[K_NPC](
	[sSid] [smallint] NOT NULL,
	[strName] [varchar](30) NULL,
	[sPid] [smallint] NOT NULL,
	[sSize] [smallint] NOT NULL,
	[Obs] [text] NULL,
	[iWeapon1] [int] NOT NULL,
	[iWeapon2] [int] NOT NULL,
	[byGroup] [int] NOT NULL,
	[byActType] [int] NOT NULL,
	[byType] [int] NOT NULL,
	[byFamily] [int] NOT NULL,
	[byRank] [int] NOT NULL,
	[byTitle] [int] NOT NULL,
	[iSellingGroup] [int] NOT NULL,
	[sLevel] [int] NOT NULL,
	[iExp] [int] NOT NULL,
	[iLoyalty] [int] NOT NULL,
	[iHpPoint] [int] NOT NULL,
	[sMpPoint] [smallint] NOT NULL,
	[sAtk] [int] NOT NULL,
	[sAc] [int] NOT NULL,
	[sHitRate] [int] NOT NULL,
	[sEvadeRate] [int] NOT NULL,
	[sDamage] [int] NOT NULL,
	[sAttackDelay] [int] NOT NULL,
	[bySpeed1] [int] NOT NULL,
	[bySpeed2] [int] NOT NULL,
	[sStandtime] [int] NOT NULL,
	[iMagic1] [int] NOT NULL,
	[iMagic2] [int] NOT NULL,
	[iMagic3] [int] NOT NULL,
	[sFireR] [smallint] NOT NULL,
	[sColdR] [smallint] NOT NULL,
	[sLightningR] [smallint] NOT NULL,
	[sMagicR] [smallint] NOT NULL,
	[sDiseaseR] [smallint] NOT NULL,
	[sPoisonR] [smallint] NOT NULL,
	[sLightR] [smallint] NOT NULL,
	[sBulk] [int] NOT NULL,
	[byAttackRange] [int] NOT NULL,
	[bySearchRange] [int] NOT NULL,
	[byTracingRange] [int] NOT NULL,
	[iMoney] [int] NOT NULL,
	[sItem] [int] NOT NULL,
	[byDirectAttack] [int] NOT NULL,
	[byMagicAttack] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byWeapon]  DEFAULT ((0)) FOR [iWeapon2]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byGroup]  DEFAULT ((0)) FOR [byGroup]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byActType]  DEFAULT ((0)) FOR [byActType]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byType]  DEFAULT ((0)) FOR [byType]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byFamily]  DEFAULT ((0)) FOR [byFamily]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byRank]  DEFAULT ((0)) FOR [byRank]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byTitle]  DEFAULT ((0)) FOR [byTitle]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_K_NPC_bySellingGroup]  DEFAULT ((0)) FOR [iSellingGroup]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byLevel]  DEFAULT ((1)) FOR [sLevel]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_iExp]  DEFAULT ((0)) FOR [iExp]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_iLoyalty]  DEFAULT ((0)) FOR [iLoyalty]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_iHpPoint]  DEFAULT ((0)) FOR [iHpPoint]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMpPoint]  DEFAULT ((0)) FOR [sMpPoint]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sAtk]  DEFAULT ((1)) FOR [sAtk]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sAc]  DEFAULT ((1)) FOR [sAc]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sHitRate]  DEFAULT ((1)) FOR [sHitRate]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sEvadeRate]  DEFAULT ((1)) FOR [sEvadeRate]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sDamage]  DEFAULT ((1)) FOR [sDamage]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sAttackDelay]  DEFAULT ((0)) FOR [sAttackDelay]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_bySpeed1]  DEFAULT ((0)) FOR [bySpeed1]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sStandtime]  DEFAULT ((0)) FOR [sStandtime]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMagic1]  DEFAULT ((0)) FOR [iMagic1]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMagic2]  DEFAULT ((0)) FOR [iMagic2]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMagic3]  DEFAULT ((0)) FOR [iMagic3]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sFireR]  DEFAULT ((0)) FOR [sFireR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sColdR]  DEFAULT ((0)) FOR [sColdR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sLightningR]  DEFAULT ((0)) FOR [sLightningR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMagicR]  DEFAULT ((0)) FOR [sMagicR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sDiseaseR]  DEFAULT ((0)) FOR [sDiseaseR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sPoisonR]  DEFAULT ((0)) FOR [sPoisonR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sLightR]  DEFAULT ((0)) FOR [sLightR]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_K_NPC_sBulk]  DEFAULT ((0)) FOR [sBulk]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sAttackRange]  DEFAULT ((0)) FOR [byAttackRange]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sSearchRange]  DEFAULT ((0)) FOR [bySearchRange]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_K_NPC_byTracingRange]  DEFAULT ((0)) FOR [byTracingRange]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sMoney]  DEFAULT ((0)) FOR [iMoney]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_sItem]  DEFAULT ((0)) FOR [sItem]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_KNIGHT_NPC_byMemory]  DEFAULT ((0)) FOR [byDirectAttack]
GO
ALTER TABLE [dbo].[K_NPC] ADD  CONSTRAINT [DF_K_NPC_byMagicAttack]  DEFAULT ((0)) FOR [byMagicAttack]
GO
