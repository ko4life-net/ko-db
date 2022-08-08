SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BLOCKED_USERDATA](
	[strUserId] [char](21) NOT NULL,
	[Nation] [tinyint] NOT NULL,
	[Race] [tinyint] NOT NULL,
	[Class] [smallint] NOT NULL,
	[HairColor] [tinyint] NOT NULL,
	[Rank] [tinyint] NOT NULL,
	[Title] [tinyint] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Exp] [int] NOT NULL,
	[Loyalty] [int] NOT NULL,
	[Face] [tinyint] NOT NULL,
	[City] [tinyint] NOT NULL,
	[Knights] [smallint] NOT NULL,
	[Fame] [tinyint] NOT NULL,
	[Hp] [smallint] NOT NULL,
	[Mp] [smallint] NOT NULL,
	[Sp] [smallint] NOT NULL,
	[Strong] [tinyint] NOT NULL,
	[Sta] [tinyint] NOT NULL,
	[Dex] [tinyint] NOT NULL,
	[Intel] [tinyint] NOT NULL,
	[Cha] [tinyint] NOT NULL,
	[Authority] [tinyint] NOT NULL,
	[Points] [tinyint] NOT NULL,
	[Gold] [int] NOT NULL,
	[Zone] [tinyint] NOT NULL,
	[Bind] [smallint] NULL,
	[PX] [int] NOT NULL,
	[PZ] [int] NOT NULL,
	[PY] [int] NOT NULL,
	[strSkill] [varchar](10) NULL,
	[strItem] [varchar](400) NULL
) ON [PRIMARY]
GO
