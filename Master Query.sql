--CREATE PROC sp_Sales
--AS
--BEGIN
    DECLARE 
        @DealerID INT = 8,
        @LocationID INT = 14,
        @Partnumber VARCHAR(30) ='0105ZAW00211N',
        @Queryold NVARCHAR(MAX),
        @Queryvor NVARCHAR(MAX),
        @Dealerold NVARCHAR(MAX),
		@Dealervor NVARCHAR(MAX),
		@StockTable Nvarchar(max),
        @Datefrom DATETIME = '2023-05-30',   -- Start date
        @Dateto DATETIME  = '2024-10-30',   -- End date
        @d1 VARCHAR(MAX), @d2 VARCHAR(MAX), @d3 VARCHAR(MAX),@d4 VARCHAR(MAX),@d5 VARCHAR(MAX),@d6 VARCHAR(MAX),@d7 VARCHAR(MAX),@d8 VARCHAR(MAX),@d9 VARCHAR(MAX),@d10 VARCHAR(MAX),@d11 VARCHAR(MAX),@d12 VARCHAR(MAX),@d13 VARCHAR(MAX),@d14 VARCHAR(MAX),@d15 VARCHAR(MAX),@d16 VARCHAR(MAX),@d17 VARCHAR(MAX),@d18 VARCHAR(MAX),@d19 VARCHAR(MAX),
        @ls INT,
        @st INT,
        @Columnsold NVARCHAR(MAX),
		@Columnsvor NVARCHAR(MAX);

    -- Set the dynamic table name
    SET @Dealerold = 'Dealer_Sale_Upload_Old_TD001_' + CAST(@DealerID AS NVARCHAR(10));
	SET @Dealervor = 'Dealer_Sale_Upload_VOR_TD001_' + CAST(@DealerID AS NVARCHAR(10));
	SET @StockTable = 'Stock_Upload_SPM_TD001_' + CAST(@DealerID AS NVARCHAR(10));

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
--print @Columnsold
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
--print @Columnsvor
    END;

drop table if exists #TempTable1 
drop table if exists #TempTable2

-- Create temporary tables
CREATE TABLE #TempTable1 (PartNumber Varchar(30), DealerID INT , LocationID INT , Month Date , Datatype Varchar(5) , Quantity Decimal(10,0));
CREATE TABLE #TempTable2 (PartNumber Varchar(30), DealerID INT , LocationID INT , Month Date , Datatype Varchar(5) , Quantity Decimal(10,0));


SET @Queryold =  'WITH Data AS (
                     SELECT PartNumber, ' + @Columnsold + '
                     FROM ' + @Dealerold + '
                     WHERE LocationId = ' + CAST(@LocationID AS NVARCHAR(10)) + '
                     AND PartNumber = ''' + @Partnumber + '''
                  )
				  insert into #temptable1
                  SELECT 
                      PartNumber,  
					  ' + CAST(@DealerID AS NVARCHAR(10)) + ' AS DealerID, 
					 ' + CAST(@LocationID AS NVARCHAR(10)) + ' AS LocationID,
					  format(cast(concat(''01-'',LEFT(DataType,3),''-'',SUBSTRING(DataType,5,2)) as date),''MM-dd-yyyy'')as Month,
                     Right(DataType,(len(DataType)-7)) AS DataType, -- Extract suffix (P, WS, etc.)
                      Quantity
                  FROM Data
                  UNPIVOT (
                      Quantity FOR DataType IN (' + @Columnsold + ')
                  ) AS unpvt';

 SET @Queryvor = 'WITH Data AS (
                     SELECT PartNumber, ' + @Columnsvor + ' 
                     FROM ' + @Dealervor + '
                     WHERE LocationId = ' + CAST(@LocationID AS NVARCHAR(10)) + '
                     AND PartNumber = ''' + @Partnumber + '''
                  )
                  insert into #TempTable2
				  SELECT 
                      PartNumber,  
						' + CAST(@DealerID AS NVARCHAR(10)) + ' AS DealerID, 
						' + CAST(@LocationID AS NVARCHAR(10)) + ' AS LocationID,
                      format(cast(concat(''01-'',LEFT(DataType,3),''-'',SUBSTRING(DataType,5,2)) as date),''MM-dd-yyyy'')as Month,
                     Right(DataType,(len(DataType)-7)) AS DataType, -- Extract suffix (P, WS, etc.)
                      Quantity
                  FROM Data
                  UNPIVOT (
                      Quantity FOR DataType IN (' + @Columnsvor + ')
                  ) AS unpvt';
Exec(@Queryold)  -- This will fetch the required data from old table and store the result in #TempTable1
EXEC(@Queryvor)  -- This will fetch the required data from vor table and store the result in #TempTable2

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
'SELECT  PartNumber, PartDesc,concat(Left(datename(month, month), 3), ''-'', right(datename(year, month), 2)) AS Month,
 '+@Dt+',
 Stocks
FROM (select ct.*,Stocks  from(
     SELECT l.BrandID,t1.PartNumber,pm.PartDesc, t1.LocationID, EOMONTH(Month) Month, Datatype, Quantity
   -- (CASE WHEN l.BrandID = sm.BrandID AND t1.PartNumber = sm.PartNumber THEN sm.SubPartNumber ELSE t1.PartNumber END) AS AlternatePartNumber
    FROM #TempTable1 t1
    INNER JOIN LocationInfo l ON t1.LocationID = l.LocationID
    INNER JOIN vw_partmaster pm ON l.BrandID = pm.BrandID AND t1.PartNumber = pm.PartNo
    LEFT JOIN substitution_master sm ON sm.BrandID = l.BrandID AND t1.PartNumber = sm.PartNumber
    UNION ALL
    SELECT li.BrandID, t2.PartNumber, pm.PartDesc, t2.LocationID, EOMONTH(Month) Month, Datatype, Quantity
--    (CASE WHEN li.BrandID = sm.BrandID AND t2.PartNumber = sm.PartNumber THEN sm.SubPartNumber ELSE t2.PartNumber END) AS AlternatePartNumber,
   FROM #TempTable2 t2																					
    INNER JOIN LocationInfo li ON t2.LocationID = li.LocationID
    INNER JOIN vw_partmaster pm ON li.BrandID = pm.BrandID AND t2.PartNumber = pm.PartNo
    LEFT JOIN substitution_master sm ON sm.BrandID = li.BrandID AND t2.PartNumber = sm.PartNumber
) AS ct
LEFT JOIN (
   SELECT  SUM(Qty) Stocks,Stockdate,Locationid,Partnumber
    FROM '+@Stocktable+'
     WHERE Stockdate BETWEEN ''' + CONVERT(NVARCHAR(20), @Datefrom, 120) + ''' 
                         AND ''' + CONVERT(NVARCHAR(20), @Dateto, 120) + '''
    GROUP BY Stockdate,partnumber,locationid
) AS ss ON ss.partnumber = ct.partnumber AND ss.locationid = ct.LocationID and ct.Month =ss.stockdate
)rt
PIVOT (
    SUM(Quantity) 
    FOR Datatype IN ('+@PivotColumns+')  
) AS PivotTable';
print @Qt
EXEC  (@Qt);
--END;