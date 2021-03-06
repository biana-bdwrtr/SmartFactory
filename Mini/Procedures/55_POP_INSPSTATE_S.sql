USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55_POP_INSPSTATE_S]    Script Date: 2022-07-14 오후 6:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최종현
-- Create date: 2021-07-13
-- Description:	수입검사 신청 성공 여부 조회
-- =============================================
ALTER PROCEDURE [dbo].[55_POP_INSPSTATE_S]
	@PLANTCODE VARCHAR(10), -- 공장
	@LOTNO	   VARCHAR(30), -- LOT NO

		
	@LANG		  VARCHAR(10)  = 'KO',
	@RS_CODE	  VARCHAR(1)   OUTPUT,
	@RS_MSG		  VARCHAR(100) OUTPUT 
AS
BEGIN
	
	-- 원자재 수입검사 요청 성공 여부 조회
	SELECT	A.PLANTCODE					      AS PLANTCODE,		-- 공장코드
			A.ITEMCODE					      AS ITEMCODE, 		-- 품번
			A.MATLOTNO					      AS LOTNO,			-- LOTNO	
			B.INSPSEQ					      AS INSPSEQ,		-- 검사 시퀀스	
			CONVERT(VARCHAR, B.REQDATE, 120)  AS REQDATE,		-- 요청 일시	
			DBO.FN_WORKERNAME(B.REQUESTER)	  AS REQUESTER,		-- 요청자 ID	
			A.STOCKQTY                        AS INSPQTY        -- 검사요청 수량
	  FROM TB_StockMM A WITH(NOLOCK) LEFT JOIN TB_ROHIQI B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.MATLOTNO = B.LOTNO
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE
	   AND A.MATLOTNO  LIKE '%' + @LOTNO + '%'






END

