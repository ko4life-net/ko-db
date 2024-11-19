SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DELETED_USERDATA](
	[strAccountID] [varchar](21) NOT NULL,
	[strUserId] [varchar](21) NOT NULL,
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
	[dwTime] [int] NOT NULL,
	[bySkill] [binary](10) NULL,
	[byItem] [binary](400) NULL,
	[bySerial] [binary](400) NULL,
	[DeletedTime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD  CONSTRAINT [DF_DELETED_USERDATA_PX]  DEFAULT ((0)) FOR [PX]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD  CONSTRAINT [DF_DELETED_USERDATA_PY]  DEFAULT ((0)) FOR [PY]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD  CONSTRAINT [DF_DELETED_USERDATA_DeletedTime]  DEFAULT (getdate()) FOR [DeletedTime]
GO
