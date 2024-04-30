-- Assuming DELETED_USERDATA containing data in this migration script
IF OBJECT_ID('DELETED_USERDATA', 'U') IS NOT NULL
  BEGIN
    SELECT * INTO DELETED_USERDATA_BAK FROM DELETED_USERDATA;
    DROP TABLE DELETED_USERDATA;
  END
GO

-- Adds missing dwTime column from USERDATA
-- Converts strSkill to from varchar to binary and renames it to bySkill
-- Renames strItem to byItem
-- Adds bySerial missing column
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DELETED_USERDATA] (
  [strAccountID] [char](21) NOT NULL,
  [strUserId] [char](21) NOT NULL,
  [Nation] [tinyint] NOT NULL,
  [Race] [tinyint] NOT NULL,
  [Class] [smallint] NOT NULL,
  [HairColor] [tinyint] NOT NULL,
  [Rank] [tinyint] NOT NULL,
  [Title] [tinyint] NOT NULL,
  [Level] [tinyint] NOT NULL,
  [Exp] [int] NOT NULL,
  [Loyalty] [int] NOT NULL,
  [Face] [tinyint] NOT NULL,
  [City] [tinyint] NOT NULL,
  [Knights] [smallint] NOT NULL,
  [Fame] [tinyint] NOT NULL,
  [Hp] [smallint] NOT NULL,
  [Mp] [smallint] NOT NULL,
  [Sp] [smallint] NOT NULL,
  [Strong] [tinyint] NOT NULL,
  [Sta] [tinyint] NOT NULL,
  [Dex] [tinyint] NOT NULL,
  [Intel] [tinyint] NOT NULL,
  [Cha] [tinyint] NOT NULL,
  [Authority] [tinyint] NOT NULL,
  [Points] [tinyint] NOT NULL,
  [Gold] [int] NOT NULL,
  [Zone] [tinyint] NOT NULL,
  [Bind] [smallint] NULL,
  [PX] [int] NOT NULL,
  [PZ] [int] NOT NULL,
  [PY] [int] NOT NULL,
  [dwTime] [int] NOT NULL,
  [bySkill] [binary](10) NULL,
  [byItem] [binary](400) NULL,
  [bySerial] [binary](400) NULL,
  [DeletedTime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD CONSTRAINT [DF_DELETED_USERDATA_PX] DEFAULT ((0)) FOR [PX]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD CONSTRAINT [DF_DELETED_USERDATA_PY] DEFAULT ((0)) FOR [PY]
GO
ALTER TABLE [dbo].[DELETED_USERDATA] ADD CONSTRAINT [DF_DELETED_USERDATA_DeletedTime] DEFAULT (
  GETDATE()
) FOR [DeletedTime]
GO

-- Copy data back into DELETED_USERDATA after modifying schema
IF OBJECT_ID('DELETED_USERDATA_BAK', 'U') IS NOT NULL
  BEGIN
    INSERT INTO DELETED_USERDATA (
      strAccountID, strUserID, Nation, Race, [Class], HairColor, Rank, Title, [Level], [Exp], Loyalty,
      Face, City, Knights, Fame, Hp, Mp, Sp, Strong, Sta, Dex, Intel, Cha, Authority, Points, Gold,
      [Zone], Bind, PX, PZ, PY, dwTime, bySkill, byItem, bySerial,
      DeletedTime
    )
    SELECT
      strAccountID,
      strUserID,
      Nation,
      Race,
      [Class],
      HairColor,
      Rank,
      Title,
      [Level],
      [Exp],
      Loyalty,
      Face,
      City,
      Knights,
      Fame,
      Hp,
      Mp,
      Sp,
      Strong,
      Sta,
      Dex,
      Intel,
      Cha,
      Authority,
      Points,
      Gold,
      [Zone],
      Bind,
      PX,
      PZ,
      PY,
      0,
      CONVERT(binary, strSkill) AS bySkill,
      strItem AS byItem,
      NULL AS bySerial,
      DeletedTime
    FROM DELETED_USERDATA_BAK

    DROP TABLE DELETED_USERDATA_BAK;
  END
GO
