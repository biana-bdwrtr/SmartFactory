USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_ROHIQI_U]    Script Date: 2022-07-14 오후 6:29:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      이기수
-- Create date: 2022.07.13
-- Description:	수입검사 요청사항이 기재된 행에 최종 결과를 업데이트한다.
-- =============================================
ALTER PROCEDURE [dbo].[55MM_ROHIQI_U]
	@PLANTCODE			VARCHAR(10) -- 공장 코드
  , @INSPSEQ  			VARCHAR(20) -- 수입검사 횟수
  , @LOTNO    			VARCHAR(30) -- LOT NO
  , @INSPECTOR			VARCHAR(10) -- 검사원

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1) OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT


AS
BEGIN
	-- 프로시져에서 공통으로 사용할 일자, 일시 변수.
	DECLARE @LD_NOWDATE DATETIME    -- PROCEDURE 실행 일시
	      , @LS_NOWDATE VARCHAR(10) -- PROCEDURE 실행 일자
	;

	SET @LD_NOWDATE = GETDATE();
	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);

	-- CHECK VALIDATION
	-- 1. 이미 최종 결과값이 들어가있는 지 확인
	DECLARE @LS_V_INSPECTOR VARCHAR(20)
	      , @LD_V_INSPDATETIME DATETIME
		  , @LS_V_INSPRESULT VARCHAR(1)
		  , @LS_V_INSPVALUE VARCHAR(50)
		  , @LS_V_VALIDATION_MSG VARCHAR(20);

	SELECT @LS_V_INSPECTOR = INSPECTOR
	     , @LD_V_INSPDATETIME = INSPDATETIME
		 , @LS_V_INSPRESULT = INSPRESULT
		 , @LS_V_INSPVALUE = INSPVALUE
	  FROM TB_ROHIQI
	 WHERE PLANTCODE = @PLANTCODE
	   AND INSPSEQ   = @INSPSEQ
	   AND LOTNO     = @LOTNO
	;

	-- 1. 수입검사 요청한 행에 검사원(INSPECTOR)의 값이 있다면
	IF (@LS_V_INSPECTOR IS NOT NULL)
	BEGIN
		SET @LS_V_VALIDATION_MSG += ' 검사원';
	END;

	-- 2. 수입검사 요청한 행에 검사 일시(INSPDATETIME)의 값이 있다면
	IF (@LD_V_INSPDATETIME IS NOT NULL)
	BEGIN
		SET @LS_V_VALIDATION_MSG += ' 검사 일시';
	END;

	-- 3. 수입검사 요청한 행에 검사 결과(INSPRESULT)의 값이 있다면
	IF (@LS_V_INSPRESULT IS NOT NULL)
	BEGIN
		SET @LS_V_VALIDATION_MSG += ' 검사 결과';
	END;

	-- 4. 수입검사 요청한 행에 검사 값(INSPVALUE)의 값이 있다면
	IF (@LS_V_INSPVALUE IS NOT NULL)
	BEGIN
		SET @LS_V_VALIDATION_MSG += ' 검사 값';
	END;


	-- 위 네가지 정보 중 하나라도 값이 입력돼있다면 에러메시지를 띄우고 RETURN
	IF (@LS_V_VALIDATION_MSG IS NOT NULL)
	BEGIN		
		SET @RS_CODE = 'E';
		SET @RS_MSG = '해당 수입검사 건에' + @LS_V_VALIDATION_MSG + '의 정보가 이미 입력돼있습니다.';
		RETURN;
	END;

	


	-- 해당 수입검사의 최종 결과 도출
	-- 최종 결과를 담을 변수
	DECLARE @LS_INSPRESULT VARCHAR(1)
	      , @LS_INSPVALUE VARCHAR(50);

	-- 해당 수입검사의 개별 항목 중 적합이 아닌 것이 1개라도 있으면 최종 부적합으로 처리
	IF (
		SELECT COUNT(*)
		  FROM TB_ROHIQIREC
		 WHERE PLANTCODE = @PLANTCODE
		   AND LOTNO = @LOTNO
		   AND INSPSEQ = @INSPSEQ
		   AND INSPRESULT <> 'G' -- 적합
		) > 0
	BEGIN
	/*
	SELECT INSPVALUE
      FROM (SELECT IQI.INSPNAME + ' ' + RIR.INSPVALUE + '입니다. ' AS INSPVALUE
			  FROM TB_ROHIQIREC RIR LEFT JOIN TB_IQIMASTER IQI
										   ON RIR.PLANTCODE = IQI.PLANTCODE
										  AND RIR.INSPCODE = IQI.INSPCODE
			 WHERE RIR.PLANTCODE = '1000'
			   AND RIR.LOTNO = 'LT_R20220706150144790'
			   AND RIR.INSPSEQ = '1'
			   AND RIR.INSPRESULT <> 'G'
			   AND RIR.IQITYPE = 'V'
			UNION ALL
			SELECT IQI.INSPNAME + ' ' + RIR.INSPVALUE + '입니다.' + '(적합 범위: ' + CONVERT(VARCHAR, RIR.LSL) + '~' + CONVERT(VARCHAR, RIR.USL) + ') ' AS INSPVALUE
			  FROM TB_ROHIQIREC RIR LEFT JOIN TB_IQIMASTER IQI
										   ON RIR.PLANTCODE = IQI.PLANTCODE
										  AND RIR.INSPCODE = IQI.INSPCODE
			 WHERE RIR.PLANTCODE = '1000'
			   AND RIR.LOTNO = 'LT_R20220706150144790'
			   AND RIR.INSPSEQ = '1'
			   AND RIR.INSPRESULT <> 'G'
			   AND RIR.IQITYPE <> 'V' ) A
       FOR XML PATH('')
	;
	*/
	SELECT @LS_INSPVALUE = 
			STUFF((
				  SELECT ',' + IQI.INSPNAME
					FROM TB_ROHIQIREC RIR LEFT JOIN TB_IQIMASTER IQI
	    										 ON RIR.PLANTCODE = IQI.PLANTCODE
	    										AND RIR.INSPCODE = IQI.INSPCODE
					WHERE RIR.PLANTCODE = @PLANTCODE
					  AND RIR.LOTNO = @LOTNO
					  AND RIR.INSPSEQ = @INSPSEQ
					  AND RIR.INSPRESULT <> 'G' -- 적합 아닌 것
					  FOR XML PATH('')), 1, 1, '' -- STUFF -> 첫번째 ',' 제거
				);
		SET @LS_INSPRESULT = 'R' -- 부적합
	END
	-- 해당 수입검사의 개별 항목이 모두 적합일 때 최종 합격품으로 처리
	ELSE
	BEGIN
		SET @LS_INSPRESULT = 'G';
		SET @LS_INSPVALUE  = '합격품';
	END;
	
	UPDATE TB_ROHIQI
	   SET INSPECTOR = @INSPECTOR
	     , INSPDATETIME = @LD_NOWDATE
		 , INSPVALUE = @LS_INSPVALUE
		 , INSPRESULT = @LS_INSPRESULT
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO
	   AND INSPSEQ   = @INSPSEQ

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 처리';
END
