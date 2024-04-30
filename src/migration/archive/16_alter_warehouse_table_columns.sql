ALTER TABLE WAREHOUSE ADD
byItem binary(1600) NULL,
bySerial binary(1600) NULL;
GO

UPDATE WAREHOUSE SET
  byItem = CONVERT(binary, WarehouseData),
  bySerial = CONVERT(binary, strSerial);
GO

ALTER TABLE WAREHOUSE DROP COLUMN WarehouseData;
ALTER TABLE WAREHOUSE DROP COLUMN strSerial;
GO
