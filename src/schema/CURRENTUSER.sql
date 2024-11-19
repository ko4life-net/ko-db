SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CURRENTUSER](
	[strAccountID] [varchar](15) NULL,
	[strCharID] [varchar](21) NULL,
	[nServerNo] [int] NULL,
	[strServerIP] [varchar](25) NULL,
	[strClientIP] [varchar](25) NULL
) ON [PRIMARY]
GO
