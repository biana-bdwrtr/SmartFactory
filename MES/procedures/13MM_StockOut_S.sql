USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13MM_StockMM_S]    Script Date: 2022-07-05 오후 3:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.07.05
-- Description:	자재 출고 등록 조회.
-- =============================================
CREATE PROCEDURE [dbo].[13MM_StockOut_S]
    @PLANTCODE		VARCHAR(10) -- 공장 코드
  , @ITEMCODE		VARCHAR(20) -- 품목 코드
  , @MATLOTNO		VARCHAR(30) -- LOT NO
  , @STARTDATE		VARCHAR(10) -- 입/출고 시작 일자
  ,	@ENDDATE		VARCHAR(10) -- 입/출고 종료 일자

  , @LANG			VARCHAR(10) = 'KO' 
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN

	SELECT 0                                   AS CHK       -- 출고할 대상(자재)를 선택할 수 있게 만들기 위해 0
	     , STK.PLANTCODE                       AS PLANTCODE -- 사업장
		 , STK.ITEMCODE                        AS ITEMCODE  -- 품목
		 , ITM.ITEMNAME                        AS ITEMNAME  -- 품목명
		 , STK.MATLOTNO                        AS MATLOTNO  -- LOTNO
		 , STK.WHCODE                          AS WHCODE    -- 창고
		 , STK.STOCKQTY                        AS STOCKQTY  -- 재고수량
		 , STK.UNITCODE                        AS UNITCODE  -- 단위
		 , STK.INDATE                          AS INDATE    -- 입고일자
		 , DBO.FN_WORKERNAME(STK.MAKER)        AS MAKER     -- 생성자
		 , CONVERT(VARCHAR, STK.MAKEDATE, 120) AS MAKEDATE  -- 생성일시
	  FROM TB_StockMM STK LEFT JOIN TB_ItemMaster ITM
								 ON STK.PLANTCODE = ITM.PLANTCODE
								AND STK.ITEMCODE  = ITM.ITEMCODE
	 WHERE STK.PLANTCODE			 LIKE '%' + @PLANTCODE + '%'
	   AND STK.MATLOTNO				 LIKE '%' + @MATLOTNO  + '%'
	   AND ISNULL(STK.ITEMCODE, '')  LIKE '%' + @ITEMCODE  + '%'
	   AND ISNULL(STK.INDATE, '')    BETWEEN @STARTDATE AND @ENDDATE
	;
END
