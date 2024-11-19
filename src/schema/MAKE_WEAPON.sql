SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAKE_WEAPON](
	[sIndex] [smallint] NOT NULL,
	[strItemInfo] [varchar](20) NULL,
	[iItemCode] [int] NOT NULL,
	[byLevel] [tinyint] NOT NULL,
	[sClass_1] [int] NULL,
	[sClass_2] [int] NULL,
	[sClass_3] [int] NULL,
	[sClass_4] [int] NULL,
	[sClass_5] [int] NULL,
	[sClass_6] [int] NULL,
	[sClass_7] [int] NULL,
	[sClass_8] [int] NULL,
	[sClass_9] [int] NULL,
	[sClass_10] [int] NULL,
	[sClass_11] [int] NULL,
	[sClass_12] [int] NULL
) ON [PRIMARY]
GO
