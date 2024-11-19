SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAKE_ITEM](
	[sIndex] [smallint] NOT NULL,
	[strItemInfo] [varchar](20) NULL,
	[iItemCode] [int] NOT NULL,
	[byItemLevel] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAKE_ITEM] ADD  CONSTRAINT [DF_MAKE_ITEM_byItemLevel]  DEFAULT ((0)) FOR [byItemLevel]
GO
