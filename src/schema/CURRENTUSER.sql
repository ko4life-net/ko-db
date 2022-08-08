SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CURRENTUSER](
	[strAccountID] [char](15) NULL,
	[strCharID] [char](21) NULL,
	[nServerNo] [int] NULL,
	[strServerIP] [char](25) NULL,
	[strClientIP] [char](25) NULL
) ON [PRIMARY]
GO
