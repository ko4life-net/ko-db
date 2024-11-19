SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC](
	[MagicNum] [int] NOT NULL,
	[EnName] [varchar](30) NULL,
	[KrName] [varchar](30) NULL,
	[Description] [varchar](100) NULL,
	[BeforeAction] [tinyint] NOT NULL,
	[TargetAction] [tinyint] NOT NULL,
	[SelfEffect] [tinyint] NOT NULL,
	[FlyingEffect] [tinyint] NOT NULL,
	[TargetEffect] [smallint] NOT NULL,
	[Moral] [tinyint] NOT NULL,
	[SkillLevel] [smallint] NOT NULL,
	[Skill] [smallint] NOT NULL,
	[Msp] [smallint] NOT NULL,
	[HP] [smallint] NOT NULL,
	[ItemGroup] [tinyint] NOT NULL,
	[UseItem] [int] NOT NULL,
	[CastTime] [tinyint] NOT NULL,
	[ReCastTime] [tinyint] NOT NULL,
	[SuccessRate] [tinyint] NOT NULL,
	[Type1] [tinyint] NOT NULL,
	[Type2] [tinyint] NOT NULL,
	[Range] [smallint] NOT NULL,
	[Etc] [tinyint] NOT NULL,
 CONSTRAINT [PK_MAGIC] PRIMARY KEY CLUSTERED 
(
	[MagicNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Num]  DEFAULT ((1)) FOR [MagicNum]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Level]  DEFAULT ((0)) FOR [BeforeAction]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Effect]  DEFAULT ((0)) FOR [TargetAction]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Mp]  DEFAULT ((0)) FOR [SelfEffect]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Hp]  DEFAULT ((0)) FOR [FlyingEffect]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_St]  DEFAULT ((0)) FOR [TargetEffect]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_NItem]  DEFAULT ((0)) FOR [Moral]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Contime]  DEFAULT ((0)) FOR [SkillLevel]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Repeat]  DEFAULT ((0)) FOR [Skill]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Expect]  DEFAULT ((1)) FOR [Msp]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Target]  DEFAULT ((0)) FOR [CastTime]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Range]  DEFAULT ((0)) FOR [SuccessRate]
GO
ALTER TABLE [dbo].[MAGIC] ADD  CONSTRAINT [DF_MAGIC_Type]  DEFAULT ((0)) FOR [Type1]
GO
