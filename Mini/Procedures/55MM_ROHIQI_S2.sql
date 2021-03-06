USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_ROHIQI_S2]    Script Date: 2022-07-14 오후 6:28:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      이기수
-- Create date: 2022.07.12
-- Description:	원자재 수입검사 요청 내역 조회
-- =============================================
ALTER PROCEDURE [dbo].[55MM_ROHIQI_S2]
    @PLANTCODE			VARCHAR(10) -- 공장 코드
  , @LOTNO    			VARCHAR(30) -- LOT NO
  , @ITEMCODE			VARCHAR(30) -- 품번
  , @INSPSEQ			VARCHAR(10) -- 검사 시퀀스

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1) OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT


AS
BEGIN

	SELECT RI.PLANTCODE 					  AS PLANTCODE
	     , RI.LOTNO     					  AS LOTNO
	     , RI.INSPSEQ   					  AS INSPSEQ
	     , ILR.INSPCODE  					  AS INSPCODE
	     , IQI.INSPNAME  					  AS INSPNAME
	     , ISNULL(RIR.IQITYPE, IQI.IQITYPE)	  AS IQITYPE
	     , ISNULL(RIR.POSPEC, IQI.POSpec)     AS POSPEC
	     , ISNULL(RIR.LSL, IQI.LSL)       	  AS LSL
	     , ISNULL(RIR.INSPVALUE, '')          AS INPUTVALUE
	     , ISNULL(RIR.USL, IQI.USL)       	  AS USL
		 , ISNULL(RIR.INSPRESULT, '')         AS INSPRESULT
	     , ISNULL(RIR.REMARK, '')             AS REMARK
	     , DBO.FN_WORKERNAME(RI.MAKER)        AS MAKER
	     , CONVERT(VARCHAR, RI.MAKEDATE, 120) AS MAKEDATE
	     , DBO.FN_WORKERNAME(RI.EDITOR)       AS EDITOR
	     , CONVERT(VARCHAR, RI.EDITDATE, 120) AS EDITDATE
	  FROM TB_ROHIQI RI LEFT JOIN TB_INSPLISTBYROH ILR
						       ON RI.PLANTCODE = ILR.PLANTCODE
							  AND RI.ITEMCODE = ILR.ITEMCODE
						LEFT JOIN TB_IQIMASTER IQI
						       ON ILR.PLANTCODE = IQI.PLANTCODE
							  AND ILR.INSPCODE = IQI.INSPCODE
						LEFT JOIN TB_ROHIQIREC RIR
						       ON RI.PLANTCODE = RIR.PLANTCODE
							  AND RI.LOTNO = RIR.LOTNO
							  AND RI.INSPSEQ = RIR.INSPSEQ
							  AND ILR.INSPCODE = RIR.INSPCODE
	 WHERE RI.PLANTCODE LIKE '%' + ISNULL(@PLANTCODE, '')
	   AND RI.LOTNO     LIKE '%' + ISNULL(@LOTNO	, '')
	   AND RI.ITEMCODE  LIKE '%' + ISNULL(@ITEMCODE	, '')
	   AND RI.INSPSEQ   LIKE '%' + ISNULL(@INSPSEQ , '')
	;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 처리';
END
