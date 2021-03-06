USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_ROHIQIREC_S]    Script Date: 2022-07-14 오후 9:27:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      문한석
-- Create date: 2022.07.12
-- Description:	원자재 수입검사 요청 내역 조회
-- =============================================

ALTER PROCEDURE [dbo].[55MM_ROHIQIREC_S]
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

	SELECT RI.PLANTCODE                       AS PLANTCODE,     -- 공장
	       RI.LOTNO                           AS LOTNO,		    -- LOTNO
	       RI.INSPSEQ                         AS INSPSEQ,		-- 검사 시퀀스
	       RI.REQDATE                         AS REQDATE,		-- 요청 일시
	       DBO.FN_WORKERNAME(RI.REQUESTER)    AS REQUESTER,	    -- 요청자ID
	       RI.ITEMCODE                        AS ITEMCODE,		-- 품번
	       ITM.ITEMNAME                       AS ITEMNAME,      -- 품명
	       RI.INSPQTY                         AS INSPQTY,		-- 검사 수량
	       DBO.FN_WORKERNAME(RI.INSPECTOR)    AS INSPECTOR,	    -- 검사원ID
	       RI.INSPDATETIME                    AS INSPDATETIME,	-- 검사 일시
	       RI.INSPRESULT                      AS INSPRESULT,	-- 최종 검사 결과
	       RIR.INSPCODE                       AS INSPCODE,		-- 검사 코드
	       IQI.INSPNAME                       AS INSPNAME,      -- 검사 명칭
		   RIR.POSpec						  AS POSpec,		-- 관련 규정
		   RIR.LSL							  AS LSL,			-- 관리 하한선
		   RIR.INSPVALUE					  AS INSPVALUE,		-- 검사 값
		   RIR.USL							  AS USL,			-- 관리 상한선
		   RIR.INSPRESULT                     AS INSPRESULTREC,	-- 항목 검사 결과
		   RIR.REMARK						  AS REMARK,		-- 비고
	       RI.MAKEDATE                        AS MAKEDATE,		-- 등록일시
	       DBO.FN_WORKERNAME(RI.MAKER)        AS MAKER			-- 생성자
	FROM TB_ROHIQI  RI WITH(NOLOCK) LEFT JOIN TB_ROHIQIREC RIR
								           ON RI.PLANTCODE = RIR.PLANTCODE
										  AND RI.LOTNO     = RIR.LOTNO
										  AND RI.INSPSEQ   = RIR.INSPSEQ
								    LEFT JOIN TB_IQIMASTER IQI 
									       ON RIR.PLANTCODE = IQI.PLANTCODE
										  AND RIR.INSPCODE  = IQI.INSPCODE
								   LEFT JOIN TB_ItemMaster ITM
								          ON RI.PLANTCODE = ITM.PLANTCODE
										 AND RI.ITEMCODE  = ITM.ITEMCODE
     WHERE RI.PLANTCODE LIKE '%' + @PLANTCODE
	   AND RI.ITEMCODE  LIKE '%' + @ITEMCODE
	   AND RI.LOTNO     LIKE '%' + @LOTNO + '%'
	   AND RI.REQDATE   BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

  ORDER BY RI.PLANTCODE, RI.LOTNO, RI.INSPSEQ, RI.REQDATE, RIR.INSPCODE
										

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 처리';









	
END
