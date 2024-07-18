SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC](
	[MagicNum] [int] NOT NULL,
	[EnName] [char](30) NULL,
	[KrName] [char](30) NULL,
	[Description] [char](100) NULL,
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
	[Event] [int] NULL,
 CONSTRAINT [PK_MAGIC] PRIMARY KEY CLUSTERED 
(
	[MagicNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
