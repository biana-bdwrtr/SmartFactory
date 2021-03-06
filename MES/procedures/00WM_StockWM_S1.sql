USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[00WM_StockWM_S1]    Script Date: 2022-07-11 오전 11:45:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : 00WM_StockWM_S1
  PROCEDURE NAME : 제품 창고 내역 조회
  ALTER DATE     : 2022.07
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[00WM_StockWM_S1]
(
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@LOTNO           VARCHAR(30)    -- LOTNO
	 ,@ITEMCODE        VARCHAR(30)    -- 품목 코드

     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN 
    BEGIN TRY

      BEGIN
        SELECT A.PLANTCODE             AS PLANTCODE
		      ,A.ITEMCODE              AS ITEMCODE
			  ,B.ITEMNAME              AS ITEMNAME
			  ,B.ITEMTYPE              AS ITEMTYPE
			  ,A.LOTNO                 AS LOTNO
			  ,A.WHCODE                AS WHCODE
			  ,A.STOCKQTY              AS STOCKQTY
			  ,B.BASEUNIT              AS UNITCODE
			  ,ISNULL(A.SHIPFLAG,'N')  AS SHIPFLAG
		  FROM TB_StockWM A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH (NOLOCK) 
												 ON A.PLANTCODE = B.PLANTCODE
												AND A.ITEMCODE  = B.ITEMCODE
		 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
		   AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
		   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'


     END
           
      
    SELECT @RS_CODE = 'S'

    END TRY

    BEGIN CATCH
        INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
    END CATCH
END






