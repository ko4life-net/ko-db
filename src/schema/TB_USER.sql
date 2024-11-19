SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_USER](
	[strAccountID] [varchar](21) NOT NULL,
	[strPasswd] [varchar](13) NOT NULL,
	[strSocNo] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
