SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VERSION](
	[sVersion] [int] NOT NULL,
	[strFileName] [char](40) NULL,
	[strCompressName] [char](10) NULL,
	[sHistoryVersion] [int] NULL
) ON [PRIMARY]
GO
