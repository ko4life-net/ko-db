ALTER TABLE [dbo].[USERDATA] DROP CONSTRAINT [DF_USERDATA_strSkill]

-- Implicit conversion from data type varchar to binary is not allowed.
ALTER TABLE [dbo].[USERDATA] ADD [bSkill] binary(10) NULL;
GO
UPDATE [dbo].[USERDATA] SET [bSkill] = CONVERT(binary, [strSkill]);
GO
ALTER TABLE [dbo].[USERDATA] DROP COLUMN [strSkill];
GO
EXEC sp_rename '[dbo].[USERDATA].[strItem]', 'bItem', 'COLUMN';
GO
EXEC sp_rename '[dbo].[USERDATA].[strSerial]', 'bSerial', 'COLUMN';
GO
