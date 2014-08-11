/****** Object:  UserDefinedFunction [dbo].[TafkeetAr]    Script Date: 11/8/2014 7:42:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/********************************************************/

/*This function will do the taqfeed for arabic numbers*/

/********************************************************/

CREATE FUNCTION [dbo].[TafkeetAr]( @TheNo decimal( 18 , 2 ))
RETURNS nvarchar( 1000 )
AS
BEGIN

    IF @TheNo <= 0
        BEGIN
            RETURN N'';
        END;

    DECLARE @TheNoAfterReplicate nvarchar( 21 );

    SET @TheNoAfterReplicate = RIGHT( REPLICATE( N'0' , 15 ) + CAST( FLOOR( @TheNo )AS nvarchar( 15 )) , 15 );

    DECLARE @ComWithWord nvarchar( 1000 );
    DECLARE @TheNoWithDecimal AS nvarchar( 400 );
    DECLARE @ThreeWords AS int;

    SET @ThreeWords = 0;

    SET @ComWithWord = (+N'#' + N' فقط ');

    DECLARE @Tafket TABLE( num int , 
                           NoName nvarchar( 100 ));

    INSERT INTO @Tafket
    VALUES( 0 , 
            N'' );

    INSERT INTO @Tafket
    VALUES( 1 , 
            N'واحد' );

    INSERT INTO @Tafket
    VALUES( 2 , 
            N'اثنان' );

    INSERT INTO @Tafket
    VALUES( 3 , 
            N'ثلاثة' );

    INSERT INTO @Tafket
    VALUES( 4 , 
            N'اربعة' );

    INSERT INTO @Tafket
    VALUES( 5 , 
            N'خمسة' );

    INSERT INTO @Tafket
    VALUES( 6 , 
            N'ستة' );

    INSERT INTO @Tafket
    VALUES( 7 , 
            N'سبعة' );

    INSERT INTO @Tafket
    VALUES( 8 , 
            N'ثمانية' );

    INSERT INTO @Tafket
    VALUES( 9 , 
            N'تسعة' );

    INSERT INTO @Tafket
    VALUES( 10 , 
            N'عشرة' );

    INSERT INTO @Tafket
    VALUES( 11 , 
            N'احدى عشر' );

    INSERT INTO @Tafket
    VALUES( 12 , 
            N'اثنى عشر' );

    INSERT INTO @Tafket
    VALUES( 13 , 
            N'ثلاثة عشر' );

    INSERT INTO @Tafket
    VALUES( 14 , 
            N'اربعة عشر' );

    INSERT INTO @Tafket
    VALUES( 15 , 
            N'خمسة عشر' );

    INSERT INTO @Tafket
    VALUES( 16 , 
            N'ستة عشر' );

    INSERT INTO @Tafket
    VALUES( 17 , 
            N'سبعة عشر' );

    INSERT INTO @Tafket
    VALUES( 18 , 
            N'ثمانية عشر' );

    INSERT INTO @Tafket
    VALUES( 19 , 
            N'تسعة عشر' );

    INSERT INTO @Tafket
    VALUES( 20 , 
            N'عشرون' );

    INSERT INTO @Tafket
    VALUES( 30 , 
            N'ثلاثون' );

    INSERT INTO @Tafket
    VALUES( 40 , 
            N'اربعون' );

    INSERT INTO @Tafket
    VALUES( 50 , 
            N'خمسون' );

    INSERT INTO @Tafket
    VALUES( 60 , 
            N'ستون' );

    INSERT INTO @Tafket
    VALUES( 70 , 
            N'سبعون' );

    INSERT INTO @Tafket
    VALUES( 80 , 
            N'ثمانون' );

    INSERT INTO @Tafket
    VALUES( 90 , 
            N'تسعون' );

    INSERT INTO @Tafket
    VALUES( 100 , 
            N'مائة' );

    INSERT INTO @Tafket
    VALUES( 200 , 
            N'مائتان' );

    INSERT INTO @Tafket
    VALUES( 300 , 
            N'ثلاثمائة' );

    INSERT INTO @Tafket
    VALUES( 400 , 
            N'أربعمائة' );

    INSERT INTO @Tafket
    VALUES( 500 , 
            N'خمسمائة' );

    INSERT INTO @Tafket
    VALUES( 600 , 
            N'ستمائة' );

    INSERT INTO @Tafket
    VALUES( 700 , 
            N'سبعمائة' );

    INSERT INTO @Tafket
    VALUES( 800 , 
            N'ثمانمائة' );

    INSERT INTO @Tafket
    VALUES( 900 , 
            N'تسعمائة' );

    INSERT INTO @Tafket
    SELECT FirstN.num + LasteN.num , 
           LasteN.NoName + N' و ' + FirstN.NoName
      FROM
           ( 
             SELECT *
               FROM @Tafket
               WHERE num BETWEEN 20 AND 90 )FirstN CROSS JOIN( 
                                                               SELECT *
                                                                 FROM @Tafket
                                                                 WHERE num BETWEEN 1 AND 9 )LasteN;

    INSERT INTO @Tafket
    SELECT FirstN.num + LasteN.num , 
           FirstN.NoName + N' و ' + LasteN.NoName
      FROM
           ( 
             SELECT *
               FROM @Tafket
               WHERE num BETWEEN 100 AND 900 )FirstN CROSS JOIN( 
                                                                 SELECT *
                                                                   FROM @Tafket
                                                                   WHERE num BETWEEN 1 AND 99 )LasteN;

    IF LEFT( @TheNoAfterReplicate , 3 ) > 0
        BEGIN

            SET @ComWithWord = @ComWithWord + ISNULL(( SELECT NoName
                                                         FROM @Tafket
                                                         WHERE num = LEFT( @TheNoAfterReplicate , 3 )) , '' ) + N' ترليون';
        END;

    IF LEFT( RIGHT( @TheNoAfterReplicate , 12 ) , 3 ) > 0
   AND LEFT( @TheNoAfterReplicate , 3 ) > 0
        BEGIN

            SET @ComWithWord = @ComWithWord + N' و ';
        END;

    IF LEFT( RIGHT( @TheNoAfterReplicate , 12 ) , 3 ) > 0
        BEGIN

            SET @ComWithWord = @ComWithWord + ISNULL(( SELECT NoName
                                                         FROM @Tafket
                                                         WHERE num = LEFT( RIGHT( @TheNoAfterReplicate , 12 ) , 3 )) , '' ) + N' بليون';
        END;

    IF LEFT( RIGHT( @TheNoAfterReplicate , 9 ) , 3 ) > 0

        BEGIN

            SET @ComWithWord = @ComWithWord + CASE
                                              WHEN @TheNo > 999000000 THEN N' و'
                                                  ELSE ''
                                              END;

            SET @ThreeWords = LEFT( RIGHT( @TheNoAfterReplicate , 9 ) , 3 );

            SET @ComWithWord = @ComWithWord + ISNULL(( SELECT CASE
                                                              WHEN @ThreeWords > 2 THEN NoName
                                                              END
                                                         FROM @Tafket
                                                         WHERE num = LEFT( RIGHT( @TheNoAfterReplicate , 9 ) , 3 )) , '' ) + CASE
                                                                                                                             WHEN @ThreeWords = 2 THEN N' مليونان'
                                                                                                                             WHEN @ThreeWords BETWEEN 3 AND 10 THEN N' ملايين'
                                                                                                                                 ELSE N' مليون'
                                                                                                                             END;

        END;

    IF LEFT( RIGHT( @TheNoAfterReplicate , 6 ) , 3 ) > 0

        BEGIN

            SET @ComWithWord = @ComWithWord + CASE
                                              WHEN @TheNo > 999000 THEN N' و'
                                                  ELSE ''
                                              END;

            SET @ThreeWords = LEFT( RIGHT( @TheNoAfterReplicate , 6 ) , 3 );

            SET @ComWithWord = @ComWithWord + ISNULL(( SELECT CASE
                                                              WHEN @ThreeWords > 2 THEN NoName
                                                              END
                                                         FROM @Tafket
                                                         WHERE num = LEFT( RIGHT( @TheNoAfterReplicate , 6 ) , 3 )) , '' ) + CASE
                                                                                                                             WHEN @ThreeWords = 2 THEN N' الفان'
                                                                                                                             WHEN @ThreeWords BETWEEN 3 AND 10 THEN N' الاف'
                                                                                                                                 ELSE N' الف'
                                                                                                                             END;

        END;



    IF RIGHT( @TheNoAfterReplicate , 3 ) > 0

        BEGIN

            IF @TheNo > 999

                BEGIN

                    SET @ComWithWord = @ComWithWord + N' و';

                END;



            SET @ThreeWords = RIGHT( @TheNoAfterReplicate , 2 );

            IF @ThreeWords = 0

                BEGIN


                    SET @ComWithWord = @ComWithWord + ISNULL(( SELECT NoName
                                                                 FROM @Tafket
                                                                 WHERE @ThreeWords = 0
                                                                   AND num = RIGHT( @TheNoAfterReplicate , 3 )) , '' );

                END;



        END;



    SET @ThreeWords = RIGHT( @TheNoAfterReplicate , 2 );

    SET @ComWithWord = @ComWithWord + ISNULL(( SELECT NoName
                                                 FROM @Tafket
                                                 WHERE @ThreeWords > 2
                                                   AND num = RIGHT( @TheNoAfterReplicate , 3 )) , '' );

    SET @ComWithWord = @ComWithWord + ' ' + CASE
                                            WHEN @TheNo < 1 THEN ''
                                            WHEN @ThreeWords = 2 THEN N' ريالان'
                                            WHEN @ThreeWords BETWEEN 3 AND 10 THEN N' ريال'
                                                ELSE N' ريال'
                                            END;

    IF RIGHT( RTRIM( @ComWithWord ) , 1 ) = N','
        BEGIN
            SET @ComWithWord = SUBSTRING( @ComWithWord , 1 , LEN( @ComWithWord ) - 1 );
        END;

    IF RIGHT( @TheNo , LEN( @TheNo ) - CHARINDEX( N'.' , @TheNo )) > 0
   AND CHARINDEX( N'.' , @TheNo ) <> 0

        BEGIN

            SET @ThreeWords = LEFT( RIGHT( ROUND( @TheNo , 2 ) , 2 ) , 2 );

            SELECT @TheNoWithDecimal = N' و' + ISNULL(( 
                                                        SELECT NoName
                                                          FROM @Tafket
                                                          WHERE num = LEFT( RIGHT( ROUND( @TheNo , 2 ) , 2 ) , 2 )
                                                            AND @ThreeWords > 2 ) , '' );


            IF @TheNo < 1
                BEGIN
                    SET @TheNoWithDecimal = SUBSTRING( @TheNoWithDecimal , 3 , LEN( @TheNoWithDecimal ))
                END;

            SET @TheNoWithDecimal = @TheNoWithDecimal + CASE
                                                        WHEN @ThreeWords = 1 THEN N'هللة واحدة'
                                                        WHEN @ThreeWords = 2 THEN N' هللتان'
                                                        WHEN @ThreeWords BETWEEN 3 AND 10 THEN N' هللات'
                                                            ELSE N'  هللة'
                                                        END;


            SET @ComWithWord = @ComWithWord + @TheNoWithDecimal;

        END;

    SET @ComWithWord = @ComWithWord + N' لا غير ' + N'#';

    RETURN RTRIM( @ComWithWord );

END;
GO


