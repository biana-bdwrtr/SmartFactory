USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[WM_StockOutWM_S1]    Script Date: 2022-07-11 오후 12:12:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2022-07-11
-- Description:	제품 출고 처리
-- =============================================
ALTER PROCEDURE [dbo].[WM_StockOutWM_S1]
	@PLANTCODE VARCHAR(10) -- 공장
   ,@CUSTCODE  VARCHAR(10) -- 거래처
   ,@STARTDATE VARCHAR(10) -- 상차 일자 (시작)
   ,@ENDDATE   VARCHAR(10) -- 상차 일자 (종료)
   ,@CARNO	   VARCHAR(20) -- 차량번호
   ,@SHIPNO    VARCHAR(30) -- 상차 번호

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
		
AS
BEGIN
	SELECT 0							   AS CHK
	      ,A.PLANTCODE					   AS PLANTCODE
	      ,A.SHIPNO						   AS SHIPNO
		  ,A.SHIPDATE					   AS SHIPDATE
		  ,A.CARNO						   AS CARNO
		  ,A.CUSTCODE					   AS CUSTCODE
		  ,B.CUSTNAME					   AS CUSTNAME	
		  ,DBO.FN_WORKERNAME(A.WORKER)     AS WORKER
		  ,A.MAKEDATE					   AS MAKEDATE
		  ,DBO.FN_WORKERNAME(A.MAKER)	   AS MAKER
		  ,A.EDITDATE					   AS EDITDATE
		  ,DBO.FN_WORKERNAME(A.EDITOR)     AS EDITOR
	  FROM TB_ShipWM A WITH(NOLOCK) LEFT JOIN TB_CustMaster B WITH(NOLOCK)
										   ON A.PLANTCODE = B.PLANTCODE
										  AND A.CUSTCODE  = B.CUSTCODE
									
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.CUSTCODE  LIKE '%' + @CUSTCODE  + '%'
	   AND A.CARNO     LIKE '%' + @CARNO     + '%'
	   AND A.SHIPNO    LIKE '%' + @SHIPNO    + '%'
	   AND A.SHIPDATE  BETWEEN @STARTDATE AND @ENDDATE
	   AND A.TRADINGNO IS NULL
	
END

