USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_StockMM_S]    Script Date: 2022-07-14 오후 6:29:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		5조
-- Create date: 2022-07-12
-- Description:	자재 현황 조회
-- =============================================
ALTER PROCEDURE [dbo].[55MM_StockMM_S]
	@PLANTCODE VARCHAR(10), -- 공장
	@ITEMCODE  VARCHAR(30), -- 품목코드
	@LOTNO	   VARCHAR(30), -- LOT NO

		
	@LANG		  VARCHAR(10)  = 'KO',
	@RS_CODE	  VARCHAR(1)   OUTPUT,
	@RS_MSG		  VARCHAR(100) OUTPUT 
AS
BEGIN
	
	-- 자재 재고 현황 조회 
	SELECT A.PLANTCODE				  AS PLANTCODE,   -- 공장
		   A.ITEMCODE				  AS ITEMCODE,    -- 품목코드
		   B.ITEMNAME				  AS ITEMNAME,    -- 품목명
		   B.INSPFLAG				  AS INSPTYPE,	  -- 검사유형(무검사/검사)
		   A.MATLOTNO				  AS MATLOTNO,    -- LOTNO
		   A.WHCODE					  AS WHCODE,      -- 창고
		   A.STOCKQTY				  AS STOCKQTY,    -- 재고수량
		   A.UNITCODE				  AS UNITCODE,    -- 단위
		   A.CUSTCODE				  AS CUSTCODE,    -- 거래처코드
		   C.CUSTNAME				  AS CUSTNAME,    -- 거래처 명
		   A.INDATE					  AS INDATE,      -- 입고일자
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER,       -- 입고자
		   A.MAKEDATE				  AS MAKEDATE,    -- 입고일시
		   CASE WHEN (SELECT COUNT(*)
						FROM TB_ROHIQI RI
					   WHERE RI.PLANTCODE = A.PLANTCODE
					     AND RI.LOTNO =  A.MATLOTNO
						 AND RI.INSPRESULT IS NULL) > 0 THEN 'Y'
				ELSE 'N' END          AS INSPSTATE
	  FROM TB_StockMM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
									 LEFT JOIN TB_CustMaster C WITH(NOLOCK)
									        ON A.PLANTCODE = C.PLANTCODE
										   AND A.CUSTCODE  = C.CUSTCODE
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
												) D -- 최신 수입검사 내역에 대해서만 조회한다.
									        ON A.PLANTCODE = C.PLANTCODE
										   AND A.MATLOTNO = D.LOTNO
									
									


	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE
	   AND A.MATLOTNO  LIKE '%' + @LOTNO + '%'






END