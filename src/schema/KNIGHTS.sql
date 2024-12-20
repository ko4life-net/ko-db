﻿SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KNIGHTS](
	[IDNum] [smallint] NOT NULL,
	[Flag] [tinyint] NOT NULL,
	[Nation] [tinyint] NOT NULL,
	[Ranking] [tinyint] NOT NULL,
	[IDName] [varchar](21) NOT NULL,
	[Members] [smallint] NOT NULL,
	[Chief] [varchar](21) NOT NULL,
	[ViceChief_1] [varchar](21) NULL,
	[ViceChief_2] [varchar](21) NULL,
	[ViceChief_3] [varchar](21) NULL,
	[Gold] [bigint] NOT NULL,
	[Domination] [smallint] NOT NULL,
	[Points] [int] NULL,
	[CreateTime] [smalldatetime] NOT NULL,
	[Mark] [image] NULL,
	[Stash] [varchar](1600) NULL,
 CONSTRAINT [PK_KNIGHTS] PRIMARY KEY CLUSTERED 
(
	[IDNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_KNIGHTS] UNIQUE NONCLUSTERED 
(
	[IDName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Flag]  DEFAULT ((1)) FOR [Flag]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Ranking]  DEFAULT ((0)) FOR [Ranking]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Members]  DEFAULT ((1)) FOR [Members]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Gold]  DEFAULT ((0)) FOR [Gold]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Domination]  DEFAULT ((0)) FOR [Domination]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_Points]  DEFAULT ((0)) FOR [Points]
GO
ALTER TABLE [dbo].[KNIGHTS] ADD  CONSTRAINT [DF_KNIGHTS_CreateTime]  DEFAULT (getdate()) FOR [CreateTime]
GO
