SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVENT](
	[ZoneNum] [tinyint] NOT NULL,
	[EventNum] [smallint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Cond1] [char](128) NULL,
	[Cond2] [char](128) NULL,
	[Cond3] [char](128) NULL,
	[Cond4] [char](128) NULL,
	[Cond5] [char](128) NULL,
	[Exec1] [char](128) NULL,
	[Exec2] [char](128) NULL,
	[Exec3] [char](128) NULL,
	[Exec4] [char](128) NULL,
	[Exec5] [char](128) NULL
) ON [PRIMARY]
GO
