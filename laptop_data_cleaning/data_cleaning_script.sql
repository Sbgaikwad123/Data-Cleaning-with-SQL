-- Create a backup table similar to 'laptopdata'
CREATE TABLE laptops_backup LIKE laptopdata;

-- Insert data from 'laptopdata' into 'laptops_backup'
INSERT INTO laptops_backup
SELECT * FROM laptopdata;

-- Check the data length of 'laptopdata' table in kilobytes
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'myproject'
AND TABLE_NAME = 'laptopdata';

-- Remove the 'Unnamed: 0' column from 'laptopdata'
ALTER TABLE laptopdata DROP COLUMN `Unnamed: 0`;

-- Modify the 'Inches' column to decimal with one decimal place
ALTER TABLE laptopdata MODIFY COLUMN Inches DECIMAL(10,1);

-- Remove 'GB' from the 'Ram' column and convert it to integer
UPDATE laptopdata
SET Ram = REPLACE(Ram,'GB','');

ALTER TABLE laptopdata MODIFY COLUMN Ram INTEGER;

-- Remove 'kg' from the 'Weight' column
UPDATE laptopdata
SET Weight = REPLACE(Weight,'kg','');

-- Round the 'Price' column and convert it to integer
UPDATE laptopdata
SET Price = ROUND(Price);

ALTER TABLE laptopdata MODIFY COLUMN Price INTEGER;

-- Check distinct operating systems in 'OpSys' column
SELECT DISTINCT OpSys FROM laptopdata;

-- Normalize operating system names in 'OpSys' column
UPDATE laptopdata
SET OpSys =
CASE
    WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;

-- Add 'gpu_brand' and 'gpu_name' columns
ALTER TABLE laptopdata
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

-- Extract GPU brand and name from 'Gpu' column
UPDATE laptopdata
SET gpu_brand = SUBSTRING_INDEX(Gpu,' ',1);

UPDATE laptopdata
SET gpu_name = REPLACE(Gpu,gpu_brand,'');

-- Drop the 'Gpu' column
ALTER TABLE laptopdata DROP COLUMN Gpu;

-- Add 'cpu_brand', 'cpu_name', and 'cpu_speed' columns
ALTER TABLE laptopdata
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

-- Extract CPU brand, name, and speed from 'Cpu' column
UPDATE laptopdata
SET cpu_brand = SUBSTRING_INDEX(Cpu,' ',1);

UPDATE laptopdata
SET cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(Cpu,' ',-1),'GHz','') AS DECIMAL(10,2));

UPDATE laptopdata
SET cpu_name = REPLACE(REPLACE(Cpu,cpu_brand,''),SUBSTRING_INDEX(REPLACE(Cpu,cpu_brand,''),' ',-1),'');

-- Drop the 'Cpu' column
ALTER TABLE laptopdata DROP COLUMN Cpu;

-- Add 'resolution_width', 'resolution_height', and 'touchscreen' columns
ALTER TABLE laptopdata
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width,
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

-- Extract resolution width, height, and touchscreen info from 'ScreenResolution' column
UPDATE laptopdata
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1);

-- Set 'touchscreen' column based on presence of 'Touch' in 'ScreenResolution'
UPDATE laptopdata
SET touchscreen = (ScreenResolution LIKE '%Touch%');

-- Drop the 'ScreenResolution' column
ALTER TABLE laptopdata DROP COLUMN ScreenResolution;

-- Extract CPU name from 'cpu_name' column
UPDATE laptopdata
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name),' ',2);

-- Normalize 'Memory' column and extract memory type, primary, and secondary storage
UPDATE laptopdata
SET memory_type =
CASE
    WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END,
primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;

-- Convert storage sizes to megabytes if less than or equal to 2, else keep as is
UPDATE laptopdata
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

-- Drop the 'memory' column
ALTER TABLE laptopdata DROP COLUMN memory;

-- Remove 'gpu_name' column
ALTER TABLE laptopdata DROP COLUMN gpu_name;

-- Display the cleaned data
SELECT * FROM laptopdata;
