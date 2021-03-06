USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[00WM_StockWM_S2]    Script Date: 2022-07-11 오전 11:48:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	    동상현
-- Create date: 2022-07-11
-- Description:	제품 재고 입/출고 이력조회
-- =============================================
ALTER PROCEDURE [dbo].[00WM_StockWM_S2]
	@PLANTCODE   VARCHAR(10) -- 공장
   ,@LOTNO		 VARCHAR(30) -- LOTNO

   ,@LANG        VARCHAR(10)  = 'KO'
   ,@RS_CODE     VARCHAR(1)   OUTPUT
   ,@RS_MSG      VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE
	      ,A.RECDATE
		  ,A.ITEMCODE
		  ,B.ITEMNAME
		  ,A.LOTNO
		  ,A.WHCODE
		  ,A.INOUTCODE
		  ,A.INOUTFLAG
		  ,A.INOUTQTY
		  ,B.BASEUNIT
		  ,DBO.FU_WORKERNAME(A.PLANTCODE,A.MAKER)       AS MAKER
		  ,A.MAKEDATE
	  FROM TB_StockWMrec A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											   ON A.PLANTCODE = B.PLANTCODE
											  AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
  ORDER BY A.LOTNO,  A.RECDATE,   A.MAKEDATE

END
