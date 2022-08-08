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
	[Attack] [tinyint] NOT NULL,
	[MaxHP] [smallint] NOT NULL,
	[HitRate] [tinyint] NOT NULL,
	[AvoidRate] [smallint] NOT NULL,
	[Str] [tinyint] NOT NULL,
	[Sta] [tinyint] NOT NULL,
	[Dex] [tinyint] NOT NULL,
	[Intel] [tinyint] NOT NULL,
	[Cha] [tinyint] NOT NULL,
	[FireR] [tinyint] NOT NULL,
	[ColdR] [tinyint] NOT NULL,
	[LightningR] [tinyint] NOT NULL,
	[MagicR] [tinyint] NOT NULL,
	[DiseaseR] [tinyint] NOT NULL,
	[PoisonR] [tinyint] NOT NULL
) ON [PRIMARY]
GO
