SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE4](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NOT NULL,
	[Description] [char](100) NULL,
	[BuffType] [tinyint] NOT NULL,
	[Radius] [tinyint] NOT NULL,
	[Duration] [smallint] NOT NULL,
	[AttackSpeed] [tinyint] NOT NULL,
	[Speed] [tinyint] NOT NULL,
	[AC] [smallint] NOT NULL,
	[ACPct] [smallint] NOT NULL,
	[Attack] [tinyint] NOT NULL,
	[MagicAttack] [tinyint] NOT NULL,
	[MaxHP] [smallint] NOT NULL,
	[MaxHpPct] [smallint] NOT NULL,
	[MaxMP] [smallint] NOT NULL,
	[MaxMpPct] [smallint] NOT NULL,
	[HitRate] [tinyint] NOT NULL,
	[AvoidRate] [smallint] NOT NULL,
	[Str] [smallint] NOT NULL,
	[Sta] [smallint] NOT NULL,
	[Dex] [smallint] NOT NULL,
	[Intel] [smallint] NOT NULL,
	[Cha] [smallint] NOT NULL,
	[FireR] [tinyint] NOT NULL,
	[ColdR] [tinyint] NOT NULL,
	[LightningR] [tinyint] NOT NULL,
	[MagicR] [tinyint] NOT NULL,
	[DiseaseR] [tinyint] NOT NULL,
	[PoisonR] [tinyint] NOT NULL,
	[ExpPct] [tinyint] NOT NULL,
 CONSTRAINT [PK_MAGIC_TYPE4] PRIMARY KEY CLUSTERED 
(
	[iNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAGIC_TYPE4] ADD  CONSTRAINT [DF_MAGIC_TYPE4_ExpPct]  DEFAULT ((100)) FOR [ExpPct]
GO
