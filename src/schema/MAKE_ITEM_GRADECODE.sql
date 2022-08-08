SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAKE_ITEM_GRADECODE](
	[byItemIndex] [tinyint] NOT NULL,
	[byGrade_1] [tinyint] NOT NULL,
	[byGrade_2] [tinyint] NULL,
	[byGrade_3] [tinyint] NULL,
	[byGrade_4] [tinyint] NULL,
	[byGrade_5] [tinyint] NULL,
	[byGrade_6] [tinyint] NULL,
	[byGrade_7] [tinyint] NULL,
	[byGrade_8] [tinyint] NULL,
	[byGrade_9] [tinyint] NULL
) ON [PRIMARY]
GO
