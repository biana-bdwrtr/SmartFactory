USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_StockOut_S]    Script Date: 2022-07-14 오후 6:30:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		문한석
-- Create date: 2022-07-12
-- Description:	자재 생산 출고 대상 조회.
-- =============================================
ALTER PROCEDURE [dbo].[55MM_StockOut_S]
	@PLANTCODE VARCHAR(10), -- 공장
	@ITEMCODE  VARCHAR(30), -- 품목코드 
	@LOTNO	   VARCHAR(30), -- LOT NO
	@STARTDATE VARCHAR(10), -- 입고 시작 일자 
	@ENDDATE   VARCHAR(10), -- 입고 종료 일자.
		
	@LANG		  VARCHAR(10)  = 'KO',
	@RS_CODE	  VARCHAR(1)   OUTPUT,
	@RS_MSG		  VARCHAR(100) OUTPUT 
AS
BEGIN

	-- 자재 생산 출고 대상 조회.
	SELECT 0						  AS CHK,         -- 출고할 대상(자재) 를 선택할 수 있게 만들기 위해 0
	       A.PLANTCODE				  AS PLANTCODE,   -- 공장
		   A.ITEMCODE				  AS ITEMCODE,    -- 품목코드
		   B.ITEMNAME				  AS ITEMNAME,    -- 품목명
		   B.INSPFLAG                 AS INSPTYPE,    -- 관리항목구분
		   C.INSPRESULT               AS INSPRESULT,  -- 수입검사결과
		   A.MATLOTNO				  AS MATLOTNO,    -- LOTNO
		   A.WHCODE					  AS WHCODE,      -- 창고
		   A.STOCKQTY				  AS STOCKQTY,    -- 재고수량
		   A.UNITCODE				  AS UNITCODE,    -- 단위
		   A.INDATE					  AS INDATE,      -- 입고일자
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER,       -- 입고자
		   A.MAKEDATE				  AS MAKEDATE     -- 입고일시
	  FROM TB_StockMM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
									 LEFT JOIN (
												SELECT A.PLANTCODE, A.LOTNO, A.INSPRESULT
												  FROM TB_ROHIQI A WITH(NOLOCK)
													 , (SELECT PLANTCODE, LOTNO, MAX(INSPSEQ) INSPSEQ
														  FROM TB_ROHIQI WITH(NOLOCK)
														 GROUP BY PLANTCODE, LOTNO
													   ) B
												 WHERE A.PLANTCODE = B.PLANTCODE
												   AND A.LOTNO = B.LOTNO
												   AND A.INSPSEQ = B.INSPSEQ
												) C -- 최신 수입검사 내역에 대해서만 조회한다.
									        ON A.PLANTCODE = C.PLANTCODE
										   AND A.MATLOTNO = C.LOTNO
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE
	   AND A.MATLOTNO  LIKE '%' + @LOTNO + '%'
	   AND A.INDATE    BETWEEN @STARTDATE + ' 00:00:00.000' AND @ENDDATE + '23:59:59.999';
END
