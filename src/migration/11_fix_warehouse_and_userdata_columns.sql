-- Fix bad columns in `USERDATA` table.
ALTER TABLE [dbo].[USERDATA] ALTER COLUMN strSkill binary(600);
ALTER TABLE [dbo].[USERDATA] ALTER COLUMN strItem binary(600);
ALTER TABLE [dbo].[USERDATA] ALTER COLUMN strSerial binary(600);

-- Fix bad columns in `WAREHOUSE` table.
ALTER TABLE [dbo].[WAREHOUSE] ALTER COLUMN WarehouseData binary(1600);
ALTER TABLE [dbo].[WAREHOUSE] ALTER COLUMN strSerial binary(1600);
