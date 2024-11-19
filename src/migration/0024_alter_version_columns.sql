-- Restructure VERSION table to match accomodate changes with the LogicServer's Version Manager.

DROP TABLE [dbo].[VERSION];
GO

CREATE TABLE [dbo].[VERSION](
    [sVersion] [smallint] NOT NULL,
    [strFile] [varchar](500) NULL,
    [strPatchFileName] [varchar](13) NULL,
    [sHistoryVersion] [smallint] NULL
) ON [PRIMARY]
GO

INSERT [dbo].[VERSION] ([sVersion], [strFile], [strPatchFileName], [sHistoryVersion]) VALUES (1264, 'KnightOnLine.exe', 'patch1264.zip', 0)
GO
