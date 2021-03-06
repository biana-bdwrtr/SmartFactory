USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13AP_ProductPlan_S]    Script Date: 2022-07-08 오후 4:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.07.01
-- Description:	생산 계획 편성 내역 및 작업 시지 확정 내역 조회.
-- =============================================
ALTER PROCEDURE [dbo].[13AP_ProductPlan_S]
	@PLANTCODE   			 VARCHAR(10)  -- 공장
  , @WORKCENTERCODE			 VARCHAR(10)  -- 작업장
  , @ORDERNO     			 VARCHAR(30)  -- 작업 지시 번호
  , @ORDERCLOSEFLAG			 VARCHAR(1)   -- 작업 종료 여부
  , @ITEMCODE    			 VARCHAR(30)  -- 생산 품목

  , @LANG					 VARCHAR(10) = 'KO'
  , @RS_CODE				 VARCHAR(1)   OUTPUT
  , @RS_MSG					 VARCHAR(100) OUTPUT

AS
BEGIN
		   /*** 생산 계획 정보 조회 ***/
	SELECT PP.PLANTCODE							AS PLANTCODE	
         , PP.PLANNO							AS PLANNO	
         , PP.ITEMCODE							AS ITEMCODE	
         , PP.PLANQTY							AS PLANQTY	
         , PP.UNITCODE							AS UNITCODE	

		   /*** 작업 지시 정보 조회 ***/
         , CASE WHEN ISNULL(PP.ORDERFLAG, 'N') = 'Y' THEN 1
		        ELSE 0 END                      AS CHK				-- 확정 여부
         , PP.WORKCENTERCODE					AS WORKCENTERCODE	-- 작업장
         , PP.ORDERNO							AS ORDERNO			-- 작업 지시 번호
		 --, PP.ORDERTEMP                         AS ORDERTEMP		-- 확정일시
         , PP.ORDERDATE						    AS ORDERDATE		-- 확정일자
         , DBO.FN_WORKERNAME(PP.ORDERWORKER)    AS ORDERWORKER		-- 확정자
         , PP.ORDERCLOSEFLAG					AS ORDERCLOSEFLAG	-- 지시 종료 여부
         , PP.FIRSTSTARTDATE					AS FIRSTSTARTDATE	-- 지시 시작 일시
         , PP.ORDERCLOSEDATE					AS ORDERCLOSEDATE	-- 지시 종료 일시
         , DBO.FN_WORKERNAME(PP.MAKER)			AS MAKER			-- 생성자
         , CONVERT(VARCHAR, PP.MAKEDATE, 120)	AS MAKEDATE			-- 생성일자
         , DBO.FN_WORKERNAME(PP.EDITOR)		    AS EDITOR			-- 수정자
         , CONVERT(VARCHAR, PP.EDITDATE, 120)	AS EDITDATE			-- 수정일자
	  FROM TB_ProductPlan PP WITH(NOLOCK)
	 WHERE ISNULL(PP.PLANTCODE   	, '')   LIKE '%' + ISNULL(@PLANTCODE   	 , '') + '%'
	   AND ISNULL(PP.WORKCENTERCODE , '')   LIKE '%' + ISNULL(@WORKCENTERCODE, '') + '%'	
	   AND ISNULL(PP.ORDERNO     	, '')   LIKE '%' + ISNULL(@ORDERNO     	 , '') + '%'
	   AND ISNULL(PP.ORDERCLOSEFLAG , '')   LIKE '%' + ISNULL(@ORDERCLOSEFLAG, '') + '%'	
	   AND ISNULL(PP.ITEMCODE    	, '')   LIKE '%' + ISNULL(@ITEMCODE    	 , '') + '%'
	 ORDER BY PP.PLANTCODE, PP.ORDERNO
	   ;

	SET @RS_CODE = 'S';
	SET @RS_MSG = '정상 작동';
END
