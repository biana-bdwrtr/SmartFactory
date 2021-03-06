USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[WM_StockOutWM_S2]    Script Date: 2022-07-11 오후 12:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2022-07-11
-- Description:	제품 출고 처리
-- =============================================
ALTER PROCEDURE [dbo].[WM_StockOutWM_S2]
	@PLANTCODE VARCHAR(10) -- 공장
   ,@SHIPNO    VARCHAR(30) -- 상차 번호

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
		
AS
BEGIN
	SELECT A.PLANTCODE  AS PLANTCODE
	      ,A.SHIPNO		AS SHIPNO
		  ,A.SHIPSEQ	AS SHIPSEQ
		  ,A.LOTNO		AS LOTNO
		  ,A.ITEMCODE	AS ITEMCODE
		  ,B.ITEMNAME	AS ITEMNAME
		  ,A.SHIPQTY	AS SHIPQTY
		  ,B.BASEUNIT   AS UNITCODE
	  FROM TB_ShipWM_B A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											 ON A.PLANTCODE = B.PLANTCODE
											AND A.ITEMCODE  = B.ITEMCODE
     WHERE A.PLANTCODE = @PLANTCODE
	   AND A.SHIPNO    = @SHIPNO
	
END
