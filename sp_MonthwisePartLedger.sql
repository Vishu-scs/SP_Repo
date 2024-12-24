 Alter proc sp_monthwisepartledger

 @DealerID INT ,
    @LocationID INT ,
    @PartID NVARCHAR(MAX),
    @Datefrom DATETIME ,
    @Dateto DATETIME 
AS
BEGIN
 
 DECLARE 
        @Queryold NVARCHAR(MAX),
        @Queryvor NVARCHAR(MAX),
        @Dealerold NVARCHAR(MAX),
		@Dealervor NVARCHAR(MAX),
		@StockTable Nvarchar(max),
        @d1 VARCHAR(MAX), @d2 VARCHAR(MAX), @d3 VARCHAR(MAX),@d4 VARCHAR(MAX),@d5 VARCHAR(MAX),@d6 VARCHAR(MAX),@d7 VARCHAR(MAX),@d8 VARCHAR(MAX),@d9 VARCHAR(MAX),@d10 VARCHAR(MAX),@d11 VARCHAR(MAX),@d12 VARCHAR(MAX),@d13 VARCHAR(MAX),@d14 VARCHAR(MAX),@d15 VARCHAR(MAX),@d16 VARCHAR(MAX),@d17 VARCHAR(MAX),@d18 VARCHAR(MAX),@d19 VARCHAR(MAX),
        @ls INT,
        @st INT,
        @Columnsold NVARCHAR(MAX),
		@Columnsvor NVARCHAR(MAX),
	    @LocationList NVARCHAR(MAX);     -- Stores all LocationIDs for the given DealerID

-- Get all LocationIDs for the DealerID
SELECT @LocationList = STRING_AGG(CAST(@LocationID AS NVARCHAR(10)), ', ')
FROM [z_scope].dbo.LocationInfo
WHERE DealerID = @DealerID;

    -- Set the dynamic table name
    SET @Dealerold = '[z_scope].dbo.Dealer_Sale_Upload_Old_TD001_' + CAST(@DealerID AS NVARCHAR(10));
	SET @Dealervor = '[z_scope].dbo.Dealer_Sale_Upload_VOR_TD001_' + CAST(@DealerID AS NVARCHAR(10));
	SET @StockTable = '[z_scope].dbo.Stock_Upload_SPM_TD001_' + CAST(@DealerID AS NVARCHAR(10));

    -- Calculate the number of months between @Datefrom and @Dateto
    SET @ls = DATEDIFF(MONTH, @Datefrom, @Dateto);
    SET @st = 0;

    -- Columns for OLD table
    WHILE @st <= @ls
    BEGIN
        -- Generate dynamic column names for CS, P, and WS etcc
        SET @d1 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_CS');
        SET @d2 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_P');
        SET @d3 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_WS');
	    SET @d4 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_SA');
		SET @d5 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_BT');
		SET @d6 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_ID');
		SET @d7 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_OT');

        -- Concatenate the generated columns to @Columnsold variable
		 IF @st = 0
       SET @Columnsold = 
    QUOTENAME(@d1 ) + ', ' +
    QUOTENAME(@d2 ) + ', ' +
    QUOTENAME(@d3 ) + ', ' +
    QUOTENAME(@d4 ) + ', ' +
    QUOTENAME(@d5 ) + ', ' +
    QUOTENAME(@d6 ) + ', ' +
    QUOTENAME(@d7 );

ELSE
    SET @Columnsold = @Columnsold + ', ' +
    QUOTENAME(@d1 ) + ', ' +
    QUOTENAME(@d2 ) + ', ' +
    QUOTENAME(@d3 ) + ', ' +
    QUOTENAME(@d4 ) + ', ' +
    QUOTENAME(@d5 ) + ', ' +
    QUOTENAME(@d6 ) + ', ' +
    QUOTENAME(@d7 );

        -- Increment the month counter
        SET @st = @st + 1;
    END;
	

 -------@Columns For VOR------------
 set @st = 0;
 WHILE @st <= @ls
    BEGIN
  
		SET @d8 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_VOR');
		SET @d9 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_CP');
		SET @d10 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_EP');
		SET @d11 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_GWS');
		SET @d12 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_PS');
		SET @d13 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_WSale');
		SET @d14 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_SAO');
		SET @d15 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_FS');
		SET @d16 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_OEM');
		SET @d17 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_JCR');
		SET @d18 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_ST');
		SET @d19 = CONCAT(LEFT(DATENAME(MONTH, DATEADD(MONTH, @st, @Datefrom)), 3), '_', RIGHT(YEAR(DATEADD(MONTH, @st, @Datefrom)), 2), '_CSR');
        -- Concatenate the generated columns to @Columnsvor variable
        IF @st = 0
    SET @Columnsvor =  
		QUOTENAME(CAST(@d8 AS Varchar(50))) + ', ' +
		QUOTENAME(CAST(@d9 AS Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d10 AS Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d11 AS Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d12 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d13 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d14 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d15 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d16 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d17 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d18 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d19 AS  Varchar(50)));
ELSE
    SET @Columnsvor = @Columnsvor + ', ' +
		QUOTENAME(CAST(@d8 AS Varchar(50))) + ', ' +
		QUOTENAME(CAST(@d9 AS Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d10 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d11 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d12 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d13 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d14 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d15 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d16 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d17 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d18 AS  Varchar(50))) + ', ' +
        QUOTENAME(CAST(@d19 AS  Varchar(50)));


        -- Increment the month counter
        SET @st = @st + 1;
    END;

drop table if exists #TempTable1 
drop table if exists #TempTable2


-- Create temporary tables
CREATE TABLE #TempTable1 (PartID INT, DealerID INT , LocationID INT , Month Date , Datatype Varchar(5) , Quantity decimal(10,2));
CREATE TABLE #TempTable2 (PartID INT, DealerID INT , LocationID INT , Month Date , Datatype Varchar(5) , Quantity decimal(10,2));


SET @Queryold = '
WITH Data AS (
    SELECT 
        d.PartID, 
        l.LocationID, 
        ' + @Columnsold + '
    FROM ' + @Dealerold + ' d
    JOIN [z_scope].dbo.LocationInfo l 
        ON d.LocationID = l.LocationID 
    WHERE 
        d.PartID = ''' + @PartID + ''' 
        AND (l.LocationID = ' + ISNULL(CAST(@LocationID AS NVARCHAR(MAX)), 'NULL') + ' OR ' + ISNULL(CAST(@LocationID AS NVARCHAR(MAX)), 'NULL') + ' IS NULL)
)
INSERT INTO #TempTable1
SELECT 
    PartID,  
    ' + CAST(@DealerID AS NVARCHAR(10)) + ' AS DealerID, 
    LocationID,
    FORMAT(CAST(CONCAT(''01-'', LEFT(DataType, 3), ''-'', SUBSTRING(DataType, 5, 2)) AS DATE), ''MM-dd-yyyy'') AS Month,
    RIGHT(DataType, (LEN(DataType) - 7)) AS DataType,
    Quantity
FROM Data
UNPIVOT (
    Quantity FOR DataType IN (' + @Columnsold + ')
) AS unpvt;';

SET @Queryvor = '
WITH Data AS (
    SELECT 
        d.PartID, 
        l.LocationID, 
        ' + @Columnsvor + '
    FROM ' + @Dealervor + ' d
    JOIN [z_scope].dbo.LocationInfo l 
        ON d.LocationID = l.LocationID 
    WHERE 
        d.PartID = ''' + @PartID + ''' 
        AND (l.LocationID = ' + ISNULL(CAST(@LocationID AS NVARCHAR(MAX)), 'NULL') + ' OR ' + ISNULL(CAST(@LocationID AS NVARCHAR(MAX)), 'NULL') + ' IS NULL)
)
INSERT INTO #TempTable2
SELECT 
    PartID,  
    ' + CAST(@DealerID AS NVARCHAR(10)) + ' AS DealerID, 
    LocationID,
    FORMAT(CAST(CONCAT(''01-'', LEFT(DataType, 3), ''-'', SUBSTRING(DataType, 5, 2)) AS DATE), ''MM-dd-yyyy'') AS Month,
    RIGHT(DataType, (LEN(DataType) - 7)) AS DataType,
    Quantity
FROM Data
UNPIVOT (
    Quantity FOR DataType IN (' + @Columnsvor + ')
) AS unpvt;';

 

Exec(@Queryold)  -- This will fetch the required data from old table and store the result in #TempTable1
Exec(@Queryvor)


--Dt for storing dynamic datatypes 
DECLARE @Dt VARCHAR(MAX);
SET @Dt = (
    SELECT STRING_AGG(
            QUOTENAME(Datatype) + ' AS ' + QUOTENAME(CASE
                WHEN Datatype = 'WS' THEN 'Workshop Sale'
                WHEN Datatype = 'CS' THEN 'Counter'
				WHEN Datatype = 'ST' THEN 'Stock transfer Out'
				WHEN Datatype = 'SAO' THEN 'Adjustment Out'
                WHEN Datatype = 'PS' THEN 'Paid Sale'
				WHEN Datatype = 'WSale' THEN 'Warranty Sale'
				WHEN Datatype = 'FS' THEN 'FOC Sales'
				WHEN Datatype = 'GWS' THEN 'Goodwill Sale'
                WHEN Datatype = 'P' THEN 'Normal Purchase'
				WHEN Datatype = 'BT' THEN 'StockTransfer In'
				WHEN Datatype = 'JCR' THEN 'Jobcard Return Value'
				WHEN Datatype = 'CSR' THEN 'Counter Sale return'
				WHEN Datatype = 'EP' THEN 'Emergency Purchase'
				WHEN Datatype = 'VOR' THEN 'Vehicle On Road'
				WHEN Datatype = 'CP' THEN 'Co-Dealer Purchase'
				WHEN Datatype = 'SA' THEN 'StockAdjustment In'
				WHEN Datatype = 'OEM' THEN 'OEM Purchase'
				WHEN Datatype = 'ID' THEN 'idk'
				WHEN Datatype = 'OT' THEN 'Others'
                ELSE Datatype -- Keep original if no alias is defined
            END), ', ')
        FROM (
            SELECT DISTINCT Datatype
            FROM (
                SELECT Datatype FROM #TempTable1
                UNION
                SELECT Datatype FROM #TempTable2
				  
			) AS CombinedTables
        ) AS DistinctDataTypes
);

-- Declare @PivotColumns for use in the PIVOT clause
DECLARE @PivotColumns NVARCHAR(MAX);
SET @PivotColumns = (
   SELECT STRING_AGG(QUOTENAME(Datatype), ', ')
    FROM (
        SELECT DISTINCT Datatype
        FROM (
            SELECT Datatype FROM #TempTable1
            UNION
            SELECT Datatype FROM #TempTable2
        ) AS CombinedTables
    ) AS DistinctDataTypes
);

--Declaring a Dynamic query for pivot on Datatype. 
--This is for joining locationinfo and partmaster and union of #TempTable1 and #TempTable2
Declare @Qt nvarchar(max);
SET @Qt = 
'SELECT 
    PartID,  
    LocationID,
    CONCAT(LEFT(DATENAME(MONTH, Month), 3), ''-'', RIGHT(DATENAME(YEAR, Month), 2)) AS Months,
	ISNULL(Stocks, 0) AS ClosingStocks,
   -- month,
	WorkshopSale,
    Counter,
    StockTransferOut,
    AdjustmentOut,
    PaidSale,
    WarrantySale,
    FOCSales,
    GoodwillSale,
    NormalPurchase,
    StockTransferIn,
    JobcardReturnValue,
    CounterSaleReturn,
    EmergencyPurchase,
    VORPurchase,
    CoDlrPurchase,
    StockAdjustmentIn,
    OEMPurchase,
    idk,
    Others
    
FROM (
    SELECT  
        PartID,  
        LocationID,
        Month,
        SUM(CASE WHEN Datatype = ''WS'' THEN Quantity ELSE 0 END) AS WorkshopSale,          
        SUM(CASE WHEN Datatype = ''CS'' THEN Quantity ELSE 0 END) AS Counter,          
        SUM(CASE WHEN Datatype = ''ST'' THEN Quantity ELSE 0 END) AS StockTransferOut, 
        SUM(CASE WHEN Datatype = ''SAO'' THEN Quantity ELSE 0 END) AS AdjustmentOut,
        SUM(CASE WHEN Datatype = ''PS'' THEN Quantity ELSE 0 END) AS PaidSale,
        SUM(CASE WHEN Datatype = ''WSale'' THEN Quantity ELSE 0 END) AS WarrantySale,
        SUM(CASE WHEN Datatype = ''FS'' THEN Quantity ELSE 0 END) AS FOCSales,
        SUM(CASE WHEN Datatype = ''GWS'' THEN Quantity ELSE 0 END) AS GoodwillSale,
        SUM(CASE WHEN Datatype = ''P'' THEN Quantity ELSE 0 END) AS NormalPurchase,
        SUM(CASE WHEN Datatype = ''BT'' THEN Quantity ELSE 0 END) AS StockTransferIn,
        SUM(CASE WHEN Datatype = ''JCR'' THEN Quantity ELSE 0 END) AS JobcardReturnValue,
        SUM(CASE WHEN Datatype = ''CSR'' THEN Quantity ELSE 0 END) AS CounterSaleReturn,
        SUM(CASE WHEN Datatype = ''EP'' THEN Quantity ELSE 0 END) AS EmergencyPurchase,
        SUM(CASE WHEN Datatype = ''VOR'' THEN Quantity ELSE 0 END) AS VORPurchase,
        SUM(CASE WHEN Datatype = ''CP'' THEN Quantity ELSE 0 END) AS CoDlrPurchase,
        SUM(CASE WHEN Datatype = ''SA'' THEN Quantity ELSE 0 END) AS StockAdjustmentIn,
        SUM(CASE WHEN Datatype = ''OEM'' THEN Quantity ELSE 0 END) AS OEMPurchase,
        SUM(CASE WHEN Datatype = ''ID'' THEN Quantity ELSE 0 END) AS idk,
        SUM(CASE WHEN Datatype = ''OT'' THEN Quantity ELSE 0 END) AS Others,
        MAX(Stocks) AS Stocks
    FROM (
        SELECT 
            ct.PartID, 
            ct.LocationID, 
            EOMONTH(Month) AS Month, 
            ct.Datatype, 
            ct.Quantity, 
            ss.Stocks
        FROM (
            SELECT 
                t1.PartID, 
                t1.LocationID, 
                EOMONTH(Month) AS Month, 
                Datatype, 
                Quantity
            FROM #TempTable1 t1
            UNION ALL
            SELECT 
                t2.PartID, 
                t2.LocationID, 
                EOMONTH(Month) AS Month, 
                Datatype, 
                Quantity
            FROM #TempTable2 t2
        ) AS ct
        LEFT JOIN (
            SELECT 
                SUM(Qty) AS Stocks, 
                Stockdate, 
                LocationID, 
                PartID
            FROM '+@StockTable+'
            WHERE Stockdate BETWEEN ''' + CONVERT(NVARCHAR(20), @Datefrom, 120) + ''' 
                             AND ''' + CONVERT(NVARCHAR(20), @Dateto, 120) + '''
            GROUP BY Stockdate, PartID, LocationID
        ) AS ss 
        ON ss.PartID = ct.PartID 
           AND ss.LocationID = ct.LocationID 
           AND ct.Month = ss.Stockdate
    ) AS rt
    GROUP BY 
        PartID,
        LocationID,
        Month
) AS a
ORDER BY LocationID, Month';
EXEC  (@Qt);

Declare @Qt2 nvarchar(max);
SET @Qt2 = 
'SELECT 
    PartID,  
    LocationID,
    ''Total'' AS Months,
	SUM(ISNULL(Stocks, 0)) AS ClosingStocks,
    SUM(WorkshopSale) AS WorkshopSale,
    SUM(Counter) AS Counter,
    SUM(StockTransferOut) AS StockTransferOut,
    SUM(AdjustmentOut) AS AdjustmentOut,
    SUM(PaidSale) AS PaidSale,
    SUM(WarrantySale) AS WarrantySale,
    SUM(FOCSales) AS FOCSales,
    SUM(GoodwillSale) AS GoodwillSale,
    SUM(NormalPurchase) AS NormalPurchase,
    SUM(StockTransferIn) AS StockTransferIn,
    SUM(JobcardReturnValue) AS JobcardReturnValue,
    SUM(CounterSaleReturn) AS CounterSaleReturn,
    SUM(EmergencyPurchase) AS EmergencyPurchase,
    SUM(VORPurchase) AS VORPurchase,
    SUM(CoDlrPurchase) AS CoDlrPurchase,
    SUM(StockAdjustmentIn) AS StockAdjustmentIn,
    SUM(OEMPurchase) AS OEMPurchase,
    SUM(idk) AS idk,
    SUM(Others) AS Others
    
FROM (
    SELECT  
        PartID,  
        LocationID,
         Months,
        SUM(CASE WHEN Datatype = ''WS'' THEN Quantity ELSE 0 END) AS WorkshopSale,          
        SUM(CASE WHEN Datatype = ''CS'' THEN Quantity ELSE 0 END) AS Counter,          
        SUM(CASE WHEN Datatype = ''ST'' THEN Quantity ELSE 0 END) AS StockTransferOut, 
        SUM(CASE WHEN Datatype = ''SAO'' THEN Quantity ELSE 0 END) AS AdjustmentOut,
        SUM(CASE WHEN Datatype = ''PS'' THEN Quantity ELSE 0 END) AS PaidSale,
        SUM(CASE WHEN Datatype = ''WSale'' THEN Quantity ELSE 0 END) AS WarrantySale,
        SUM(CASE WHEN Datatype = ''FS'' THEN Quantity ELSE 0 END) AS FOCSales,
        SUM(CASE WHEN Datatype = ''GWS'' THEN Quantity ELSE 0 END) AS GoodwillSale,
        SUM(CASE WHEN Datatype = ''P'' THEN Quantity ELSE 0 END) AS NormalPurchase,
        SUM(CASE WHEN Datatype = ''BT'' THEN Quantity ELSE 0 END) AS StockTransferIn,
        SUM(CASE WHEN Datatype = ''JCR'' THEN Quantity ELSE 0 END) AS JobcardReturnValue,
        SUM(CASE WHEN Datatype = ''CSR'' THEN Quantity ELSE 0 END) AS CounterSaleReturn,
        SUM(CASE WHEN Datatype = ''EP'' THEN Quantity ELSE 0 END) AS EmergencyPurchase,
        SUM(CASE WHEN Datatype = ''VOR'' THEN Quantity ELSE 0 END) AS VORPurchase,
        SUM(CASE WHEN Datatype = ''CP'' THEN Quantity ELSE 0 END) AS CoDlrPurchase,
        SUM(CASE WHEN Datatype = ''SA'' THEN Quantity ELSE 0 END) AS StockAdjustmentIn,
        SUM(CASE WHEN Datatype = ''OEM'' THEN Quantity ELSE 0 END) AS OEMPurchase,
        SUM(CASE WHEN Datatype = ''ID'' THEN Quantity ELSE 0 END) AS idk,
        SUM(CASE WHEN Datatype = ''OT'' THEN Quantity ELSE 0 END) AS Others,
        Stocks
    FROM (
        SELECT 
            ct.PartID, 
            ct.LocationID, 
             Months, 
            ct.Datatype, 
            ct.Quantity, 
            ss.Stocks
        FROM (
            SELECT 
                t1.PartID, 
                t1.LocationID, 
                EOMONTH(Month) AS Months, 
                Datatype, 
                Quantity
            FROM #TempTable1 t1
            UNION ALL
            SELECT 
                t2.PartID, 
                t2.LocationID, 
                EOMONTH(Month) AS Months, 
                Datatype, 
                Quantity
            FROM #TempTable2 t2
        ) AS ct
        LEFT JOIN (
            SELECT 
                SUM(Qty) AS Stocks, 
                Stockdate, 
                LocationID, 
                PartID
            FROM '+@StockTable+'
            WHERE Stockdate BETWEEN ''' + CONVERT(NVARCHAR(20), @Datefrom, 120) + ''' 
                               AND ''' + CONVERT(NVARCHAR(20), @Dateto, 120) + '''
            GROUP BY Stockdate, PartID, LocationID
        ) AS ss 
        ON ss.PartID = ct.PartID 
           AND ss.LocationID = ct.LocationID 
           AND ct.Months = ss.Stockdate
    ) AS rt
    GROUP BY 
        PartID,
        LocationID,
        Months,
        Stocks
) AS a
GROUP BY PartID, LocationID
ORDER BY LocationID,Months';
EXEC(@Qt2);
--select * from #temptable1 
--select * from #TempTable2

END;
-- EXEC SP_MonthwisePartLedger 8 , null , 62913,  '2023-05-30' ,  '2024-11-30'
