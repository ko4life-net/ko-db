SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAGIC_TYPE8](
	[iNum] [int] NOT NULL,
	[Name] [char](30) NOT NULL,
	[Description] [char](100) NULL,
	[Target] [tinyint] NOT NULL,
	[Radius] [smallint] NOT NULL,
	[WarpType] [tinyint] NOT NULL,
	[ExpRecover] [smallint] NOT NULL
) ON [PRIMARY]
GO
