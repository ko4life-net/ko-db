-- Note that normally we would need to recreate the table if we want to perserve the order of columns,
-- as there is no way of sorting them. Worth noting that the sql engine doesn't care much about the order when
-- explictly querying columns from tables. However since the columns we modify are the last ones, we can
-- take a shortcut by droping and then adding them in the right order.

-- No longer need default value constraints for it, since it is fixed length binary column.
ALTER TABLE USERDATA DROP CONSTRAINT DF_USERDATA_strSkill;
GO

ALTER TABLE USERDATA ADD
bySkill binary(10) NULL,
byItem binary(400) NULL,
bySerial binary(400) NULL;
GO

-- Implicit conversion from data type varchar to binary is not allowed.
UPDATE USERDATA SET bySkill = CONVERT(binary, strSkill);

-- Note that there is no need to convert these two below to binary, since they were already binary
-- and someone forgot or didn't bother to rename them.
UPDATE USERDATA SET byItem = strItem;
UPDATE USERDATA SET bySerial = strSerial;
GO

-- Done reworking these columns? let's get ride of them.
ALTER TABLE USERDATA DROP COLUMN strSkill;
ALTER TABLE USERDATA DROP COLUMN strItem;
ALTER TABLE USERDATA DROP COLUMN strSerial;
GO
