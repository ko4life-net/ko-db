SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NEWS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NoticeType] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Content] [nvarchar](512) NOT NULL,
	[StartsAt] [datetime] NOT NULL,
	[ExpiresAt] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[NEWS] ADD  DEFAULT (getdate()) FOR [StartsAt]
GO

ALTER TABLE [dbo].[NEWS] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[NEWS]  WITH CHECK ADD CHECK  (([NoticeType]='ingame' OR [NoticeType]='login'))
GO
