USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_ROHIQIREC_I]    Script Date: 2022-07-14 오후 6:29:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      이기수
-- Create date: 2022.07.13
-- Description:	수입검사 항목별 이력 저장
-- =============================================
ALTER PROCEDURE [dbo].[55MM_ROHIQIREC_I]
    @PLANTCODE 		  VARCHAR(10)  -- 공장 코드
  , @LOTNO     		  VARCHAR(30)  -- LOT NO
  , @INSPSEQ   		  VARCHAR(20)  -- 검사 시퀀스
  , @INSPCODE         VARCHAR(10)  -- 검사 코드
  , @INSPNAME  		  VARCHAR(30)  -- 검사 명칭
  , @IQITYPE   		  VARCHAR(10)  -- 검사 유형
  , @INSPECTOR        VARCHAR(20)  -- 검사원
  , @POSPEC    		  VARCHAR(50)  -- 관련 규정
  , @LSL       		  VARCHAR(10)  -- 관리 상한선
  , @INPUTVALUE		  VARCHAR(50)  -- 검사 값
  , @USL       		  VARCHAR(10)  -- 관리 하한선
  , @REMARK    		  VARCHAR(200) -- 비고

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

	-- 검사가 완료된 LOT인지 재확인
	DECLARE @LI_LAST_INSPSEQ INT;
	SELECT @LI_LAST_INSPSEQ = ISNULL(MAX(INSPSEQ), 0) -- 없으면 0, 있으면 최신 시퀀스를 가져온다.
	  FROM TB_ROHIQI
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO = @LOTNO
	;

	-- 처리 중 수입검사 요청 내역이 삭제된 경우
	IF (@LI_LAST_INSPSEQ) <> @INSPSEQ
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG = '수입검사 내역에 변경이 있습니다. 수입검사 요청 내역을 다시 조회하고 진행하세요.';
		RETURN;
	END;

	-- 요청 건에 있는 INSPQTY, REQUESTER, ITEMCODE, REQDATE 값을 가져온다.
	DECLARE @LI_QTY FLOAT
	      , @LS_REQUSTER VARCHAR(20)
		  , @LS_ITEMCODE VARCHAR(20)
		  , @LD_REQDATE DATETIME
		  , @INSPRESULT VARCHAR(10);
	SELECT @LI_QTY = INSPQTY
	     , @LS_REQUSTER = REQUESTER
		 , @LS_ITEMCODE = ITEMCODE
		 , @LD_REQDATE = REQDATE
	  FROM TB_ROHIQI
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO = @LOTNO
	   AND INSPSEQ = @INSPSEQ;
	
	-- 관리 상한선, 하한선 불러오기
	DECLARE @LF_LSL FLOAT
	      , @LF_USL FLOAT;
	SELECT @LF_LSL = IQI.LSL
	     , @LF_USL = IQI.USL
	  FROM TB_IQIMASTER IQI
	 WHERE IQI.PLANTCODE = @PLANTCODE
	   AND IQI.INSPCODE = @INSPCODE;

	IF (@IQITYPE = 'D')
	BEGIN
		IF (@LF_LSL <= CONVERT(FLOAT, @INPUTVALUE) AND @LF_USL >= CONVERT(FLOAT, @INPUTVALUE))
		BEGIN
			SET @INSPRESULT = 'G'; -- Good
		END
		ELSE
		BEGIN
			SET @INSPRESULT = 'R'; -- Reject
		END;
	END
	ELSE IF (@IQITYPE = 'V')
	BEGIN
		IF (@INPUTVALUE IN ('적합','적격','1', 'Y', 'G'))
		BEGIN
			SET @INSPRESULT = 'G'; -- Good
		END
		ELSE
		BEGIN
			SET @INSPRESULT = 'R'; -- Reject
		END;
	END;

	-- 수입검사 항목별 이력 저장
	INSERT INTO TB_ROHIQIREC ( PLANTCODE,  LOTNO, INSPSEQ,   INSPCODE,  IQITYPE,  REQDATE,     REQUESTER,    ITEMCODE,     INSPQTY, 
	                          INSPECTOR, INSPDATETIME, INSPRESULT,   POSpec,  LSL,  INSPVALUE,   USL,  REMARK,  MAKEDATE,    MAKER)
					  VALUES (@PLANTCODE, @LOTNO, @INSPSEQ, @INSPCODE, @IQITYPE,  @LD_REQDATE, @LS_REQUSTER, @LS_ITEMCODE, @LI_QTY,
					          @INSPECTOR, @LD_NOWDATE, @INSPRESULT, @POSPEC, @LSL, @INPUTVALUE, @USL, @REMARK, @LD_NOWDATE, @INSPECTOR);



	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 처리';
END
