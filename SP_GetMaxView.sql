ALTER PROCEDURE GetMAXData
	@DealerID INT ,					  -- Required: DealerID for dynamic table name
    @r1 DECIMAL(10,2) = NULL,         -- Optional: Minimum Avg3MSale
    @r2 DECIMAL(10,2) = NULL,         -- Optional: Maximum Avg3MSale
    @PartNumber VARCHAR(50) = NULL,   -- Optional: Part number filter
    @LocationID INT = NULL,           -- Optional: Location filter                  
    @MaxValueFlag INT = NULL,         -- Optional: NULL -> No filter, 0 -> Maxvalue = 0, 1 -> Maxvalue > 0
    @seasonalid INT = NULL,           -- Optional: Seasonal ID filter
    @natureid INT = NULL,             -- Optional: Nature ID filter
    @modelid INT = NULL               -- Optional: Model ID filter
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate that at least one of PartNumber or LocationID is provided.
    IF @PartNumber IS NULL AND @LocationID IS NULL
    BEGIN
        PRINT 'Error: Either PartNumber or LocationID must be provided.';
        RETURN;
    END

    ------------------------------
    -- Declare Internal Variables
    ------------------------------
    DECLARE 
        @ls INT = 6,                          -- Number of months to generate
        @st INT = 1,                          -- Loop counter
        @Columnsold NVARCHAR(MAX) = '',       -- Will hold the dynamic column list
        @d1 NVARCHAR(100),                    -- Dynamic column name for _WS column
        @d2 NVARCHAR(100),                    -- Dynamic column name for _CS column
        @Dealer NVARCHAR(128),       -- Dynamic table name variable
		@StockTable NVARCHAR(128),       -- Dynamic table name variable
        @sql NVARCHAR(MAX);                   -- Dynamic SQL statement

    -----------------------------------------------------
    -- Build the Dynamic Dealer Sale Table Name
    -----------------------------------------------------
    SET @Dealer = '[z_scope].dbo.Dealer_Sale_Upload_Old_TD001_' + CAST(@DealerID AS NVARCHAR(10));
	SET @StockTable = '[z_scope].dbo.stockable_nonstockable_td001_' + CAST(@DealerID AS NVARCHAR(10));

    -----------------------------------------------------
    -- Generate Dynamic Column List for the past 6 months
    -----------------------------------------------------
    WHILE @st <= @ls  
    BEGIN  
        SET @d1 = CONCAT(
                    LEFT(DATENAME(MONTH, DATEADD(MONTH, -@st, GETDATE())), 3),
                    '_',
                    RIGHT(CONVERT(VARCHAR(4), YEAR(DATEADD(MONTH, -@st, GETDATE()))), 2),
                    '_WS');  
        SET @d2 = CONCAT(
                    LEFT(DATENAME(MONTH, DATEADD(MONTH, -@st, GETDATE())), 3),
                    '_',
                    RIGHT(CONVERT(VARCHAR(4), YEAR(DATEADD(MONTH, -@st, GETDATE()))), 2),
                    '_CS');  

        SET @Columnsold = @Columnsold + CASE WHEN @Columnsold = '' THEN '' ELSE ', ' END 
                           + QUOTENAME(@d1) + ', ' + QUOTENAME(@d2);  

        SET @st = @st + 1;  
    END;  

    -- Optional: Print the generated column names for debugging.
    PRINT @Columnsold;

    ------------------------------------------
    -- Build the Dynamic SQL Statement
    ------------------------------------------
    SET @sql = N'
SELECT  
    sn.Brandid, 
    sn.Dealerid, 
    sn.locationid, 
    sn.partnumber,
    pm.PartID,
    pm.partdesc,  
    pm.category, 
    pm.mrp, 
    pm.moq, 
    sn.Maxvalue, 
    sn.Avg3MSale,
    ' + @Columnsold + '
FROM ' + @Dealer + ' ds
JOIN ' + @StockTable +' sn 
    ON ds.locationid = sn.locationid AND sn.partnumber = ds.Partnumber
JOIN z_scope..Part_Master pm 
    ON sn.brandid = pm.brandid AND pm.partnumber = sn.Partnumber 
LEFT JOIN PartMgmt_PartNatureMapping pnm
    ON pm.PartID = pnm.PartID
LEFT JOIN partsmodelmapping psm
    ON pm.PartID = psm.PartID
LEFT JOIN partmgmt_seasonalmapping psam
    ON pm.PartID = psam.PartID
WHERE sn.stockdate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
    AND (
         @MaxValueFlag IS NULL  
         OR (@MaxValueFlag = 0 AND sn.Maxvalue = 0)
         OR (@MaxValueFlag = 1 AND sn.Maxvalue > 0)
    )
    AND (@r1 IS NULL OR sn.Avg3MSale > @r1)
    AND (@r2 IS NULL OR sn.Avg3MSale < @r2)
    AND (@PartNumber IS NULL OR sn.partnumber = @PartNumber)
    AND (@LocationID IS NULL OR sn.locationid = @LocationID)
    AND (@natureid IS NULL OR pnm.PartNatureID = @natureid)
    AND (@modelid IS NULL OR psm.ModelID = @modelid)
    AND (@seasonalid IS NULL OR psam.SeasonalID = @seasonalid);
';

    -- Optional: Print the full dynamic SQL statement for debugging.
    PRINT @sql;

    ------------------------------------------
    -- Execute the Dynamic SQL Statement
    ------------------------------------------
    EXEC sp_executesql 
         @sql, 
         N'@r1 DECIMAL(10,2), @r2 DECIMAL(10,2), @PartNumber VARCHAR(50), @LocationID INT, @MaxValueFlag INT,
           @seasonalid INT, @natureid INT, @modelid INT',
         @r1 = @r1, 
         @r2 = @r2, 
         @PartNumber = @PartNumber, 
         @LocationID = @LocationID, 
         @MaxValueFlag = @MaxValueFlag,
         @seasonalid = @seasonalid,
         @natureid = @natureid,
         @modelid = @modelid;
END;
GO
--EXEC GetMAXData @DealerID = 8 , @r1 = null ,@r2 = null,@PartNumber = null,@LocationID = 14,@MaxValueFlag = null,@seasonalid = null,@natureid = null,@modelid = null;
--EXEC GetMAXData  8 ,null,null,null,14,null,null,null,null;