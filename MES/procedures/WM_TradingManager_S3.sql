USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[WM_TradingManager_S3]    Script Date: 2022-07-11 오후 12:23:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2022-07-11
-- Description:	출하 거래 명세서 출력
-- =============================================
ALTER PROCEDURE [dbo].[WM_TradingManager_S3]
	@PLANTCODE VARCHAR(10)
   ,@TRADINGNO VARCHAR(30)

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY A.MAKEDATE)   AS ROWNO
	      ,A.TRADINGNO								AS TRADINGNO         
		  ,A.LOTNO									AS LOTNO
		  ,A.ITEMCODE								AS ITEMCODE
		  ,B.ITEMNAME  								AS ITEMNAME 
		  ,DBO.FN_CUSTNAME(E.PLANTCODE,E.CUSTCODE)  AS CUSTNAME
		  ,A.TRADINGQTY								AS TRADINGQTY
		  ,DBO.FN_WORKERNAME(A.MAKER)				AS MAKER
		  ,C.CARNO									AS CARNO
		  ,B.BASEUNIT								AS UNITCODE
		  ,CONVERT(VARCHAR,A.MAKEDATE,120) AS  MAKEDATE 
	 FROM TB_TradingWM_B A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											    ON A.PLANTCODE = B.PLANTCODE
											   AND A.ITEMCODE  = B.ITEMCODE
										 LEFT JOIN TB_TradingWM  C WITH(NOLOCK)
										        ON A.PLANTCODE = C.PLANTCODE
											   AND A.TRADINGNO = C.TRADINGNO 
										 LEFT JOIN TB_ShipWM     E WITH(NOLOCK)
										        ON A.PLANTCODE = E.PLANTCODE
											   AND A.SHIPNO    = E.SHIPNO 
							
	WHERE A.PLANTCODE = @PLANTCODE
	  AND A.TRADINGNO = @TRADINGNO
END

