--Cleaning data in sql

select * from
dbo.NashvilleHousing

--standardize date format
select  SaleDate, CONVERT(Date,SaleDate)
from
dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select  SaleDateConverted, CONVERT(Date,SaleDate)
from
dbo.NashvilleHousing

--populate property adress

select PropertyAddress 
FROM NashvilleHousing
where PropertyAddress is null

select * 
FROM NashvilleHousing
where PropertyAddress is null

select * 
FROM NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null
 
 UPDATE a
 SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 --Breaking address to indiviual columns(Address,City,State)

 SELECT
SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress)) as Address
FROM NashvilleHousing


SELECT
SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress)) as Address,
  CHARINDEX (',' ,PropertyAddress)
FROM NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address,
  CHARINDEX (',' ,PropertyAddress)
FROM NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress)) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
 FROM NashvilleHousing

 ALTER TABLE NashvilleHousing
ADD PropertysplitAddress VARCHAR(255)

ALTER TABLE NashvilleHousing
ADD PropertysplitCity VARCHAR(255)

update NashvilleHousing
SET PropertysplitAddress = SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

update NashvilleHousing
SET PropertysplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select *
from NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnersplitAddress VARCHAR(255)

update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
ADD OwnersplitCity VARCHAR(255)

update NashvilleHousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
ADD OwnersplitState VARCHAR(255)

update NashvilleHousing
SET OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from NashvilleHousing

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
 CASE when SoldAsVacant = 'Y' THEN 'YES'
     when SoldAsVacant = 'N'THEN 'NO'
	 ELSE SoldAsVacant
	 END
from NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE when SoldAsVacant = 'Y' THEN 'YES'
     when SoldAsVacant = 'N'THEN 'NO'
	 ELSE SoldAsVacant
	 END
	 
--Remove Duplicates

select *,
ROW_Number() OVER(
      PARTITION BY
          ParcelID, 
		            PropertyAddress,
		            SalePrice,
		            SaleDate,
		            LegalReference
					ORDER BY 
					UniqueID)Row_num

from NashvilleHousing
ORDER BY ParcelID


With Row_numCTE as (
select *,
ROW_Number() OVER(
      PARTITION BY
          ParcelID, 
		            PropertyAddress,
		            SalePrice,
		            SaleDate,
		            LegalReference
					ORDER BY 
					UniqueID)Row_num

from NashvilleHousing)
--ORDER BY ParcelID)

select *
FROM Row_numCTE
WHERE Row_num>1
ORDER BY PropertyAddress




With Row_numCTE as (
select *,
ROW_Number() OVER(
      PARTITION BY
          ParcelID, 
		            PropertyAddress,
		            SalePrice,
		            SaleDate,
		            LegalReference
					ORDER BY 
					UniqueID)Row_num

from NashvilleHousing)
--ORDER BY ParcelID)

DELETE 
FROM Row_numCTE
WHERE Row_num>1
--ORDER BY PropertyAddress

--Deleting unused columns

select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress,TaxDistrict

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate


