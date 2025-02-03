/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM dbo.[Nash Housing]


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM dbo.[Nash Housing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.[Nash Housing] a
JOIN dbo.[Nash Housing]  b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.[Nash Housing] a
JOIN dbo.[Nash Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM dbo.[Nash Housing]
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS Address

From dbo.[Nash Housing]

ALTER TABLE [Nash Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nash Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nash Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nash Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




SELECT *
FROM [Nash Housing]


--Owner Address


SELECT OwnerAddress
FROM [Nash Housing]
 


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Nash Housing]



ALTER TABLE [Nash Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nash Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



ALTER TABLE [Nash Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nash Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



ALTER TABLE [Nash Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nash Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT *
FROM [Nash Housing]



--------------------------------------------------------------------------------------------------------------------------


-- Change 1 and 0 to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant),  COUNT(SoldAsVacant)
FROM [Nash Housing]
GROUP BY SoldAsVacant
ORDER BY 2

ALTER TABLE [Nash Housing]
ALTER COLUMN SoldAsVacant VARCHAR(255);


SELECT SoldAsVacant
 ,CASE WHEN SoldAsVacant = '1' THEN 'Yes'
       WHEN SoldAsVacant = '0' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [Nash Housing]

UPDATE [Nash Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = '1' THEN 'Yes'
       WHEN SoldAsVacant = '0' THEN 'No'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RownumCTE AS(
SELECT*,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference    
				ORDER BY
				UniqueID
				) rom_num

FROM [Nash Housing]
--ORDER BY ParcelID
)

SELECT*
--DELETE
FROM RownumCTE
WHERE rom_num > 1
--ORDER BY PropertyAddress







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM [Nash Housing]

ALTER TABLE [Nash Housing]
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict























-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO

















