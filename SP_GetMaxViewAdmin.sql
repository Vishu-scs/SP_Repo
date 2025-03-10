Alter PROCEDURE GetMAXDataAdmin
    @brandid int ,
	@DealerID INT ,					  -- Required: DealerID for dynamic table name
    @r1 DECIMAL(10,2) = NULL,         -- Optional: Minimum Avg3MSale
    @r2 DECIMAL(10,2) = NULL,         -- Optional: Maximum Avg3MSale
	@l1 DECIMAL(10,2) = NULL,         -- Optional: Minimum Landedcost
    @l2 DECIMAL(10,2) = NULL,         -- Optional: Maximum Landedcost
    @PartNumber VARCHAR(50) = NULL,   -- Optional: Part number filter
    @LocationID INT = NULL,           -- Optional: Location filter                  
    @MaxValueFlag INT = NULL,         -- Optional: NULL -> No filter, 0 -> Maxvalue = 0, 1 -> Maxvalue > 0
    @seasonalid INT = NULL,           -- Optional: Seasonal ID filter
    @natureid INT = NULL,             -- Optional: Nature ID filter
    @modelid INT = NULL,              -- Optional: Model ID filter
	@Status BIT = NULL,				 --Optional (0->no feedback , 1-> feedback)
	@parttype INT = NULL				--Optional : Parttype / category filter
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
		@SPMFeedback NVARCHAR(128),
		@AdminFeedback NVARCHAR(128),
        @sql NVARCHAR(MAX);                   -- Dynamic SQL statement

    -----------------------------------------------------
    -- Build the Dynamic Dealer Sale Table Name
    -----------------------------------------------------
    SET @Dealer = '[z_scope].dbo.Dealer_Sale_Upload_Old_TD001_' + CAST(@DealerID AS NVARCHAR(10))+ '(nolock)';
	SET @StockTable = '[z_scope].dbo.stockable_nonstockable_td001_' + CAST(@DealerID AS NVARCHAR(10))+'(nolock)';
	SET @SPMFeedback = '[UAD_VON]..UAD_VON_SPMFeedback_'+CAST(@Brandid as NVARCHAR(10));
	SET @AdminFeedback = '[UAD_VON]..UAD_VON_AdminFeedback_'+CAST(@Brandid as NVARCHAR(10));

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
    li.Brand, 
    li.Dealer, 
    li.location, 
    sn.partnumber,
	pm.Partid,
	 --(CASE WHEN li.BrandID = sm.BrandID AND pm.PartNumber = sm.PartNumber THEN sm.SubPartNumber ELSE pm.PartNumber END) AS LatestPartNumber,
	 pm.orderpartnumber,
    pm.partdesc, 
	pn.Description as PartNature,
    pm.category, 
    pm.landedcost, 
    pm.moq, 
	sn.N1 , sn.N2 , sn.N3,
    sn.Maxvalue, 
    sn.Avg3MSale,
	CASE WHEN rm.Remark = ''Custom'' THEN fb.Customrem ELSE rm.Remark END AS SPMRemark, fb.ProposedQty, 
	CASE WHEN rm2.Remark = ''Custom'' THEN afb.Customrem ELSE rm2.Remark END AS AdminRemark, afb.ApprovedQty,
    ' + @Columnsold + ',
	fb.feedbackid
FROM ' + @Dealer + ' ds
JOIN ' + @StockTable +' sn 
    ON ds.locationid = sn.locationid AND sn.partnumber = ds.Partnumber
JOIN z_scope..Part_Master pm 
    ON sn.brandid = pm.brandid AND pm.partnumber = sn.Partnumber 
JOIN z_scope..locationinfo li on li.locationid = sn.Locationid
LEFT JOIN PartMgmt_PartNatureMapping pnm
    ON ds.PartID = pnm.PartID
LEFT JOIN partsmodelmapping psm
    ON ds.PartID = psm.PartID
LEFT JOIN partmgmt_seasonalmapping psam
    ON ds.PartID = psam.PartID
OUTER APPLY (
    SELECT TOP 1 * 
    FROM '+ @SPMFeedback +' Fb 
    WHERE fb.dealerid = li.DealerID 
      AND fb.locationid = ds.locationid 
      AND fb.PartID = ds.PartID
    ORDER BY fb.feedbackid DESC
) fb
LEFT JOIN UAD_VON..UAD_VON_RemarksMaster rm on rm.remarkid = fb.UserFBRemarkID
OUTER APPLY (
    SELECT TOP 1 * 
    FROM '+ @AdminFeedback +' aFb 
    WHERE fb.dealerid = li.DealerID 
      AND fb.locationid = ds.locationid 
      AND fb.PartID = ds.PartID
    ORDER BY afb.AdminFBid DESC
) afb
LEFT JOIN UAD_VON..UAD_VON_RemarksMaster rm2 on rm2.remarkid = afb.AdminRemark
LEFT JOIN substitution_master sm ON sm.BrandID = li.BrandID AND pm.PartNumber = sm.PartNumber
left join z_scope..PartNatureMaster pn on pn.tcode = pnm.partnatureid
WHERE sn.stockdate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
   AND(
		 @Status IS NULL  
        OR (@Status = 0 AND (fb.Status = ''Pending'' OR fb.Status IS NULL)) 
         OR (@Status = 1 AND fb.Status = ''Approved'')
   )
    AND (
         @MaxValueFlag IS NULL  
         OR (@MaxValueFlag = 0 AND sn.Maxvalue = 0)
         OR (@MaxValueFlag = 1 AND sn.Maxvalue > 0)
    )
	AND (@l1 IS NULL OR pm.landedcost > @l1)
    AND (@l2 IS NULL OR pm.landedcost < @l2)
    AND (@r1 IS NULL OR sn.Avg3MSale > @r1)
    AND (@r2 IS NULL OR sn.Avg3MSale < @r2)
    AND (@PartNumber IS NULL OR sn.partnumber = @PartNumber)
    AND (@LocationID IS NULL OR sn.locationid = @LocationID)
    AND (@natureid IS NULL OR pnm.PartNatureID = @natureid)
    AND (@modelid IS NULL OR psm.ModelID = @modelid)
    AND (@seasonalid IS NULL OR psam.SeasonalID = @seasonalid)
	AND (@parttype IS NULL OR pm.parttypeid = @parttype)
	order by sn.Avg3MSale desc;;
';

    -- Optional: Print the full dynamic SQL statement for debugging.
    PRINT @sql;

    ------------------------------------------
    -- Execute the Dynamic SQL Statement
    ------------------------------------------
    EXEC sp_executesql 
         @sql, 
         N'@r1 DECIMAL(10,2), @r2 DECIMAL(10,2),@l1 Decimal(10,2),@l2 decimal(10,2), @PartNumber VARCHAR(50), @LocationID INT, @MaxValueFlag INT,
           @seasonalid INT, @natureid INT, @modelid INT , @Status bit , @parttype int',
         @r1 = @r1, 
         @r2 = @r2, 
		 @l1 = @l1,
		 @l2 = @l2,
         @PartNumber = @PartNumber, 
         @LocationID = @LocationID, 
         @MaxValueFlag = @MaxValueFlag,
         @seasonalid = @seasonalid,
         @natureid = @natureid,
         @modelid = @modelid,
		 @Status = @Status,
		 @parttype = @parttype;
END;
GO
--EXEC GetMAXDataAdmin @brandid = 9,@DealerID = 8 , @r1 = null ,@r2 = null,@l1 = null ,@l2 = null,@PartNumber = null,@LocationID = 14,@MaxValueFlag = null,@seasonalid = null,@natureid = null,@modelid = null,@Status = null,@parttype = null;
--use [z_scope] EXEC GetMAXDataAdmin 9,8,null,null,null,null,null,14,null,null,null,null,null,1;
