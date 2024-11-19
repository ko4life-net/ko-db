SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVENT](
	[ZoneNum] [tinyint] NOT NULL,
	[EventNum] [smallint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Cond1] [varchar](128) NULL,
	[Cond2] [varchar](128) NULL,
	[Cond3] [varchar](128) NULL,
	[Cond4] [varchar](128) NULL,
	[Cond5] [varchar](128) NULL,
	[Exec1] [varchar](128) NULL,
	[Exec2] [varchar](128) NULL,
	[Exec3] [varchar](128) NULL,
	[Exec4] [varchar](128) NULL,
	[Exec5] [varchar](128) NULL
) ON [PRIMARY]
GO
