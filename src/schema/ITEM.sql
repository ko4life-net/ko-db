SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ITEM](
	[Num] [int] NOT NULL,
	[strName] [char](50) NOT NULL,
	[Kind] [tinyint] NOT NULL,
	[Slot] [tinyint] NOT NULL,
	[Race] [tinyint] NOT NULL,
	[Class] [tinyint] NOT NULL,
	[Damage] [smallint] NOT NULL,
	[Delay] [smallint] NOT NULL,
	[Range] [smallint] NOT NULL,
	[Weight] [smallint] NOT NULL,
	[Duration] [smallint] NOT NULL,
	[BuyPrice] [int] NOT NULL,
	[SellPrice] [int] NOT NULL,
	[Ac] [smallint] NOT NULL,
	[Countable] [tinyint] NOT NULL,
	[Effect1] [int] NOT NULL,
	[Effect2] [int] NOT NULL,
	[ReqLevel] [tinyint] NOT NULL,
	[ReqRank] [tinyint] NOT NULL,
	[ReqTitle] [tinyint] NOT NULL,
	[ReqStr] [tinyint] NOT NULL,
	[ReqSta] [tinyint] NOT NULL,
	[ReqDex] [tinyint] NOT NULL,
	[ReqIntel] [tinyint] NOT NULL,
	[ReqCha] [tinyint] NOT NULL,
	[SellingGroup] [tinyint] NOT NULL,
	[ItemType] [tinyint] NOT NULL,
	[Hitrate] [smallint] NOT NULL,
	[Evasionrate] [smallint] NOT NULL,
	[DaggerAc] [smallint] NOT NULL,
	[SwordAc] [smallint] NOT NULL,
	[MaceAc] [smallint] NOT NULL,
	[AxeAc] [smallint] NOT NULL,
	[SpearAc] [smallint] NOT NULL,
	[BowAc] [smallint] NOT NULL,
	[FireDamage] [tinyint] NOT NULL,
	[IceDamage] [tinyint] NOT NULL,
	[LightningDamage] [tinyint] NOT NULL,
	[PoisonDamage] [tinyint] NOT NULL,
	[HPDrain] [tinyint] NOT NULL,
	[MPDamage] [tinyint] NOT NULL,
	[MPDrain] [tinyint] NOT NULL,
	[MirrorDamage] [tinyint] NOT NULL,
	[Droprate] [tinyint] NOT NULL,
	[StrB] [smallint] NOT NULL,
	[StaB] [smallint] NOT NULL,
	[DexB] [smallint] NOT NULL,
	[IntelB] [smallint] NOT NULL,
	[ChaB] [smallint] NOT NULL,
	[MaxHpB] [smallint] NOT NULL,
	[MaxMpB] [smallint] NOT NULL,
	[FireR] [smallint] NOT NULL,
	[ColdR] [smallint] NOT NULL,
	[LightningR] [smallint] NOT NULL,
	[MagicR] [smallint] NOT NULL,
	[PoisonR] [smallint] NOT NULL,
	[CurseR] [smallint] NOT NULL,
 CONSTRAINT [PK_ITEM] PRIMARY KEY CLUSTERED 
(
	[Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_아이템테이블$_ㅇ]  DEFAULT (0) FOR [Kind]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_아이템테이블$_d]  DEFAULT (0) FOR [Slot]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_아이템테이블$_종족]  DEFAULT (0) FOR [Race]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Class_1]  DEFAULT (1) FOR [Class]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Damage_1]  DEFAULT (0) FOR [Damage]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Delay_1]  DEFAULT (0) FOR [Delay]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Range_1]  DEFAULT (0) FOR [Range]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Weight_1]  DEFAULT (0) FOR [Weight]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Price_1]  DEFAULT (0) FOR [BuyPrice]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac_1]  DEFAULT (0) FOR [Ac]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac1]  DEFAULT (0) FOR [DaggerAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac2]  DEFAULT (0) FOR [SwordAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac3]  DEFAULT (0) FOR [MaceAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac4]  DEFAULT (0) FOR [AxeAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac5]  DEFAULT (0) FOR [SpearAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Ac6]  DEFAULT (0) FOR [BowAc]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Magic_1]  DEFAULT (0) FOR [MirrorDamage]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Soul_1]  DEFAULT (0) FOR [Droprate]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Str_1]  DEFAULT (0) FOR [StrB]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Sta_1]  DEFAULT (0) FOR [StaB]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Dex_1]  DEFAULT (0) FOR [DexB]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Intel_1]  DEFAULT (0) FOR [IntelB]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_Charm_1]  DEFAULT (0) FOR [ChaB]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_FireR_1]  DEFAULT (0) FOR [FireR]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_ColdR_1]  DEFAULT (0) FOR [ColdR]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_LightR_1]  DEFAULT (0) FOR [LightningR]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_MagicR_1]  DEFAULT (0) FOR [MagicR]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_PoisonR_1]  DEFAULT (0) FOR [PoisonR]
GO
ALTER TABLE [dbo].[ITEM] ADD  CONSTRAINT [DF_ITEM_DeseaseR]  DEFAULT (0) FOR [CurseR]
GO
