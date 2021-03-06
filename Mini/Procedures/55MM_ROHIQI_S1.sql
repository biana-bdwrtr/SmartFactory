USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_ROHIQI_S1]    Script Date: 2022-07-14 오후 6:28:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      이기수
-- Create date: 2022.07.12
-- Description:	원자재 수입검사 요청 내역 조회
-- =============================================
ALTER PROCEDURE [dbo].[55MM_ROHIQI_S1]
    @PLANTCODE			VARCHAR(10) -- 공장 코드
  , @REQUESTER			VARCHAR(10) -- 요청자
  , @STARTDATE			VARCHAR(10) -- 요청 시작 일자
  , @ENDDATE			VARCHAR(10) -- 요청 종료 일자
  , @ITEMCODE			VARCHAR(30) -- 품번
  , @LOTNO    			VARCHAR(30) -- LOT NO

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1) OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT


AS
BEGIN
	SELECT RI.PLANTCODE				         AS PLANTCODE
         , RI.INSPSEQ  				         AS INSPSEQ  
         , RI.LOTNO    				         AS LOTNO   
		 , RI.INSPRESULT                     AS INSPRESULT
         , CONVERT(VARCHAR, RI.REQDATE, 120) AS REQDATE  
         , DBO.FN_WORKERNAME(RI.REQUESTER)   AS REQUESTER
         , RI.ITEMCODE                       AS ITEMCODE 
         , RI.INSPQTY  				         AS INSPQTY  
	  FROM TB_ROHIQI RI
	 WHERE RI.PLANTCODE LIKE '%' + ISNULL(@PLANTCODE, '')
	   AND RI.REQUESTER LIKE '%' + ISNULL(@REQUESTER, '') + '%'
	   AND RI.LOTNO     LIKE '%' + ISNULL(@LOTNO	, '') + '%'
	   AND RI.ITEMCODE  LIKE '%' + ISNULL(@ITEMCODE	, '')
	   AND RI.REQDATE BETWEEN @STARTDATE + ' 00:00:00.000' AND @ENDDATE + ' 23:59:59.999'
	;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 처리';
END
