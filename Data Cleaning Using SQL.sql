-- Cleaning Data Using SQL Queries

SELECT  *	
FROM PortofolioProject..Housing AS h


-------------------------------------------------------------------------
-- change null values with values from the table

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject..Housing AS a
JOIN PortofolioProject..Housing AS b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- checking our code
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortofolioProject..Housing AS a
JOIN PortofolioProject..Housing AS b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- another code check
SELECT *
FROM PortofolioProject..Housing AS a
WHERE PropertyAddress IS NULL


-------------------------------------------------------------------------
-- Breaking Address to (Address , city , state)

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , (LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress))) AS City
FROM PortofolioProject..Housing AS a

ALTER TABLE PortofolioProject..Housing
ADD Address NVarChar(255)

UPDATE PortofolioProject..Housing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortofolioProject..Housing
ADD City NVarChar(255)

UPDATE PortofolioProject..Housing
SET City =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , (LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress))) 


-- Check Our Code
SELECT *
FROM PortofolioProject..Housing  -- It's OK 

-------------------------------------------------------------------------

-- change y and n to yes and no in SoldAsVacant:

SELECT DISTINCT(SoldAsVacant)
FROM PortofolioProject..Housing

SELECT SoldAsVacant , 
CASE WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 ELSE SoldAsVacant
	 END
FROM PortofolioProject..Housing

UPDATE PortofolioProject..Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						ELSE SoldAsVacant
						END

-- check our code:
SELECT DISTINCT(SoldAsVacant)
FROM PortofolioProject..Housing     -- it's OK


-------------------------------------------------------------------------

-- Deleting duplicates
WITH t1 AS(
SELECT * , ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS Row_Num
FROM PortofolioProject..Housing
--ORDER BY ParcelID
)

DELETE
FROM t1
WHERE Row_Num > 1 


-- Check our Code 
SELECT *
FROM t1
WHERE Row_num>1    -- and it's OK

-------------------------------------------------------------------------

-- Delete unused columns:

ALTER TABLE PortofolioProject..Housing
DROP COLUMN PropertyAddress 

-- Check our Code 
SELECT *
FROM PortofolioProject..Housing   -- and it's OK


