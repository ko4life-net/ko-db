SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BK_TUE_USERDATA](
	[strUserID] [char](21) NOT NULL,
	[Rank] [tinyint] NOT NULL,
	[Title] [tinyint] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Exp] [int] NOT NULL,
	[Loyalty] [int] NOT NULL,
	[Knights] [smallint] NOT NULL,
	[Fame] [tinyint] NOT NULL,
	[Strong] [tinyint] NOT NULL,
	[Sta] [tinyint] NOT NULL,
	[Dex] [tinyint] NOT NULL,
	[Intel] [tinyint] NOT NULL,
	[Cha] [tinyint] NOT NULL,
	[Points] [tinyint] NOT NULL,
	[Gold] [int] NOT NULL,
	[strSkill] [varchar](10) NULL,
	[strItem] [varchar](400) NULL,
 CONSTRAINT [PK_BK_TUE_USERDATA] PRIMARY KEY CLUSTERED 
(
	[strUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
