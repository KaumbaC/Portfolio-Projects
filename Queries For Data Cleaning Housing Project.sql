/*

 CLeaning Dating using SQL

*/

SELECT *
FROM "public"."Housing"

-- Populate Property Address Data 

SELECT A."ParcelID", A."PropertyAddress", B."ParcelID", B."PropertyAddress", COALESCE(A."PropertyAddress",B."PropertyAddress")
FROM "public"."Housing" AS A JOIN "public"."Housing" AS B
    ON A."ParcelID" = B."ParcelID"
    AND A."UniqueID" <> B."UniqueID"
WHERE A."PropertyAddress" IS NULL

UPDATE A
SET "PropertyAddress" = COALESCE(A."PropertyAddress",B."PropertyAddress")
FROM "public"."Housing" AS A JOIN "public"."Housing" AS B
    ON A."ParcelID" = B."ParcelID"
    AND A."UniqueID" <> B."UniqueID" 
WHERE A."PropertyAddress" IS NULL


----------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING("PropertyAddress", 1, strpos("PropertyAddress", ',') -1) 
, SUBSTRING("PropertyAddress", strpos("PropertyAddress", ',') +1) 
FROM "public"."Housing"

ALTER TABLE "Housing"
ADD COLUMN PropertyStreetAddress VARCHAR(255)

UPDATE "Housing"
SET PropertyStreetAddress = SUBSTRING("PropertyAddress", 1, strpos("PropertyAddress", ',') -1)

ALTER TABLE "Housing" 
ADD PropertyCityAddress VARCHAR(255)

UPDATE "Housing"
SET PropertyCityAddress = SUBSTRING("PropertyAddress", strpos("PropertyAddress", ',') +1) 

SELECT
split_part("OwnerAddress", ',', 3)
FROM "public"."Housing"

ALTER TABLE "Housing" 
ADD PropertyStateAddress VARCHAR(255)

UPDATE "Housing"
SET PropertyStateAddress = split_part("OwnerAddress", ',', 3) 


----------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in 'Sold as Vacant' Field

SELECT DISTINCT("SoldAsVacant"), Count("SoldAsVacant")
FROM "public"."Housing"
GROUP BY "SoldAsVacant"
ORDER BY 2

SELECT "SoldAsVacant"
, CASE WHEN "SoldAsVacant" = 'Y' THEN 'Yes'
       WHEN "SoldAsVacant" = 'N' THEN 'No'
       ELSE "SoldAsVacant"
END
FROM "public"."Housing"

UPDATE "Housing"
SET "SoldAsVacant" = CASE WHEN "SoldAsVacant" = 'Y' THEN 'Yes'
       WHEN "SoldAsVacant" = 'N' THEN 'No'
       ELSE "SoldAsVacant"
END

----------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH CTE_1 AS(
SELECT*,
    row_number() OVER (
    PARTITION BY "ParcelID",
                 "PropertyAddress",
                 "SalePrice",
                 "SaleDate",
                 "LegalReference"
                 ORDER BY "UniqueID"
                 ) row_num
FROM "Housing"
)
DELETE
FROM CTE_1 
WHERE row_num > 1

----------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns


ALTER TABLE "Housing"
DROP COLUMN "OwnerAddress", "TaxDistrict", "PropertyAddress", "SaleDate"
