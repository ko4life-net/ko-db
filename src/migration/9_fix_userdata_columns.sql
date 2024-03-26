ALTER TABLE [dbo].[USERDATA] DROP CONSTRAINT [DF_USERDATA_strSkill]

-- Implicit conversion from data type varchar to binary is not allowed.
ALTER TABLE [dbo].[USERDATA] ADD [strSkillNew] BINARY (10) NULL;
GO
UPDATE [dbo].[USERDATA] SET [strSkillNew] = CONVERT(BINARY, [strSkill]);
GO
ALTER TABLE [dbo].[USERDATA] DROP COLUMN [strSkill];
GO
EXEC sp_rename '[dbo].[USERDATA].[strSkillNew]',  'strSkill', 'COLUMN';
GO
