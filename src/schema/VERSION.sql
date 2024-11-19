SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VERSION](
	[sVersion] [int] NOT NULL,
	[strFileName] [varchar](40) NULL,
	[strCompressName] [varchar](10) NULL,
	[sHistoryVersion] [int] NULL
) ON [PRIMARY]
GO
