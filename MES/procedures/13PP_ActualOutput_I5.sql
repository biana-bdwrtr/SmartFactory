USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13PP_ActualOutput_I5]    Script Date: 2022-07-12 오전 9:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      이기수
-- Create date: 2022.07.08
-- Description:	생산 실적 등록 - 7. 생산 실적 등록.
-- =============================================
ALTER PROCEDURE [dbo].[13PP_ActualOutput_I5]
	@PLANTCODE     		VARCHAR(10) -- 공장 코드
  , @WORKCENTERCODE		VARCHAR(10) -- 작업장
  , @ITEMCODE      		VARCHAR(30) -- 작업자 ID
  , @ORDERNO       		VARCHAR(30) -- 생산 품번
  , @UNITCODE      		VARCHAR(10) -- 생산 단위
  , @PRODQTY       		FLOAT       -- 입력 양품 수량
  , @BADQTY        		FLOAT       -- 입력 불량 수량
  , @MATLOTNO      		VARCHAR(30) -- 원자재 LOT NO

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

	DECLARE @LS_WORKERID VARCHAR(30) -- 작업자 ID
	      , @LS_ORDERNO   VARCHAR(30) -- 등록된 작업 지시 번호
		  ;

	SELECT @LS_WORKERID = WORKER
	     , @LS_ORDERNO   = ORDERNO
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	;

	-- 1. 작업장에 작업자 등록 여부 확인
	IF (ISNULL(@LS_WORKERID, '') = '')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '작업장에 등록된 작업자가 없습니다.';
		RETURN;
	END;

	-- 2. 작업장에 작업 지시 번호 등록 여부 확인
	IF (ISNULL(@LS_ORDERNO, '') = '')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '작업장에 등록된 작업지시가 없습니다.';
		RETURN;
	END;

	-- 3. 작업장에 등록된 작업 지시 번호와 선택한 작업 지시 번호가 맞는 지 확인
	IF (@LS_ORDERNO <> @ORDERNO)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '작업 지시 정보가 변경되었습니다. 재조회 후 진행하세요.';
		RETURN;
	END;

	-- BOM에서 차감될 수량만큼 원자재 재고가 남아있는지 확인.
	DECLARE @LF_TOTALQTY FLOAT; -- = 양품 수량 + 불량 수량
	SET @LF_TOTALQTY = @PRODQTY + @BADQTY;

	-- 투입된 원자재 LOT의 정보 받아오기
	DECLARE @LS_CITEMCODE VARCHAR(30) -- 원자재 품목 코드
	      , @LF_STOCKQTY  FLOAT       -- 원자재 재고 수량
		  , @LS_CUNITCODE VARCHAR(10) -- 원자재 품목 단위 코드
	;

	SELECT @LS_CITEMCODE = ITEMCODE
	     , @LF_STOCKQTY  = STOCKQTY
		 , @LS_CUNITCODE = UNITCODE
	  FROM TB_StockHALB WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO = @MATLOTNO
	   AND WORKCENTERCODE = @WORKCENTERCODE
	;

	-- BOM 마스터에서 차감 수량 계산하기 및 BOM 연결 품목 여부 확인.
	DECLARE @LF_FINALQTY FLOAT -- 총 차감되어야 할 원자재 수량
	      , @LF_PRODQTY  FLOAT; -- 양품 수량에 대해서만 차감될 원자재 수량

	SELECT @LF_FINALQTY = ISNULL(COMPONENTQTY, 1) * @LF_TOTALQTY  -- 양품 + 불량 수량에 대한 총 차감될 원자재 수량
	     , @LF_PRODQTY  = ISNULL(COMPONENTQTY, 1) * @PRODQTY      -- 양품 수량에 대한 차감될 원자재 수량
	  FROM TB_BomMaster WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND COMPONENT = @LS_CITEMCODE
	   AND ITEMCODE  = @ITEMCODE
	;

	IF (ISNULL(@LF_FINALQTY, 0) = 0)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = 'BOM 구성이 변경되었거나, 생산 데이터가 변경되었습니다. 재조회 후 진행하세요. 관리자에게 문의하세요.';
		RETURN;
	END;

	-- 원자재 LOT의 수량 
	IF (@LF_STOCKQTY < @LF_FINALQTY)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '투입된 원자재 LOT의 잔량이 부족합니다. 원자재 LOT 잔량 확인 후 재투입 하여 진행하세요.';
		RETURN;
	END;


	-- 생산 실적 등록 시작 --
	-- 1. 작업 지시 내역에 생산 정보 등록
	UPDATE TB_ProductPlan
	   SET PRODQTY = ISNULL(PRODQTY, 0) + @PRODQTY	 -- 총 양품 수량 누적.
	     , BADQTY  = ISNULL(BADQTY, 0) + @BADQTY	 -- 총 불량 수량 누적.
		 , EDITOR  = @LS_WORKERID
		 , EDITDATE = @LD_NOWDATE
	 WHERE PLANTCODE = @PLANTCODE
	   AND ORDERNO = @ORDERNO
   ;

   -- 2. 가동 비가동 이력에 생산 정보 등록
   UPDATE TP_WorkcenterStatusRec
      SET PRODQTY        = ISNULL(PRODQTY, 0) + @PRODQTY
	    , BADQTY         = ISNULL(BADQTY, 0) + @BADQTY
		, EDITOR         = @LS_WORKERID
		, EDITDATE       = @LD_NOWDATE
	WHERE PLANTCODE      = @PLANTCODE
	  AND WORKCENTERCODE = @WORKCENTERCODE
	  AND ORDERNO = @ORDERNO
	  AND RSENDDATE IS NULL
	;

	-- 3. 완제품 (생산품) LOT 채번. 
	DECLARE @LS_FLOTNO VARCHAR(30) -- 제품 LOT NO 
	IF (ISNULL(@PRODQTY,0) <> 0) 
	BEGIN
		SET @LS_FLOTNO = 'LT_F' + REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,@LD_NOWDATE ,121),'-',''),':',''),' ',''),'.','');

		-- **************************************************************************************************************************
		-- LOT TRACKING 등록 (투입된 LOT 와 생산 된 LOT 를 연결 함으로서 제품 생산에 대한 모든 과정을 추적 할수 있도록 하는 테이블)
		-- **************************************************************************************************************************
		INSERT INTO TP_LotTracking (PLANTCODE,  ORDERNO,    WORKCENTERCODE,   LOTNO,      ITEMCODE,   PRODQTY,    UNITCODE,   CLOTNO,     CITEMCODE,       INQTY,        CUNITCODE,     MAKEDATE,    MAKER)
		                    VALUES (@PLANTCODE, @ORDERNO,   @WORKCENTERCODE,  @LS_FLOTNO, @ITEMCODE,  @PRODQTY,   @UNITCODE,  @MATLOTNO,  @LS_CITEMCODE,   @LF_PRODQTY,  @LS_CUNITCODE, @LD_NOWDATE, @LS_WORKERID);
	END;

	-- 4. 작업장 별 생산 실적 등록 TP_WorkcenterPerProd
	DECLARE @LI_PRODSEQ INT;

	SELECT @LI_PRODSEQ = ISNULL(MAX(PRODSEQ),0) + 1
	  FROM TP_WorkcenterPerProd WITH(NOLOCK)
     WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND PRODDATE       = @LS_NOWDATE

	INSERT INTO TP_WorkcenterPerProd (PLANTCODE,   WORKCENTERCODE,       PRODDATE,      PRODSEQ,       ITEMCODE,   ORDERNO,      PRODQTY,  
									  BADQTY,      TOTALQTY,             UNITCODE,      INLOTNO,       LOTNO,      MAKER,        MAKEDATE)
							  VALUES (@PLANTCODE,  @WORKCENTERCODE,      @LS_NOWDATE,   @LI_PRODSEQ,   @ITEMCODE,  @ORDERNO,     @PRODQTY,
							          @BADQTY,     @PRODQTY + @BADQTY,   @UNITCODE,     @MATLOTNO,     @LS_FLOTNO, @LS_WORKERID, @LD_NOWDATE);

	-- 5. 원자재 수량 재공 재고에서 차감. 
	IF (ISNULL(@LF_STOCKQTY,0) - @LF_FINALQTY) = 0
	BEGIN
		DELETE TB_StockHALB
		 WHERE PLANTCODE      = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
		   AND LOTNO          = @MATLOTNO;
	END
	ELSE -- 재공 재고가 차감될 수량 보다 많은경우. 
	BEGIN
		UPDATE TB_StockHALB
		   SET STOCKQTY = STOCKQTY - @LF_FINALQTY
		 WHERE PLANTCODE      = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
		   AND LOTNO          = @MATLOTNO;
	END

	-- 재공 재고 차감 이력.
	DECLARE @LI_HSEQ INT;

	SELECT @LI_HSEQ =  ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockHALBrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE   = @LS_NOWDATE;
															         -- ***************
	INSERT INTO TB_StockHALBrec (PLANTCODE,  RECDATE,      INOUTSEQ, LOTNO,      ITEMCODE,      WORKCENTERCODE,    INOUTFLAG,    INOUTCODE,    INOUTQTY,     UNITCODE,       MAKEDATE,    MAKER)
						 VALUES (@PLANTCODE, @LS_NOWDATE,  @LI_HSEQ, @MATLOTNO,  @LS_CITEMCODE, @WORKCENTERCODE,   'OUT',        '40',         @LF_FINALQTY, @LS_CUNITCODE,  @LD_NOWDATE, @LS_WORKERID);

    

	-- 6. 완제품 정보 공정 재고 에 등록.
	IF (ISNULL(@PRODQTY,0) <> 0) -- ***************
	BEGIN
			INSERT INTO  TB_StockPP(PLANTCODE,  LOTNO,      ITEMCODE,     WHCODE,     STOCKQTY,     UNITCODE,    INDATE,       MAKEDATE,     MAKER)
							 VALUES(@PLANTCODE, @LS_FLOTNO, @ITEMCODE,    'WH003',    @PRODQTY,     @UNITCODE,	 @LS_NOWDATE,  @LD_NOWDATE,  @LS_WORKERID);


			-- 공정 창고 입고 이력 등록.
			DECLARE @LI_PSEQ INT;
			SELECT @LI_PSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
			  FROM TB_StockPPrec WITH(NOLOCK) 
			 WHERE PLANTCODE = @PLANTCODE
			   AND RECDATE   = @LS_NOWDATE;


			INSERT INTO TB_StockPPrec (PLANTCODE,   RECDATE,     INOUTSEQ,   LOTNO,      ITEMCODE,    WHCODE,    INOUTFLAG,    INOUTCODE,    INOUTQTY,    UNITCODE,    MAKEDATE,    MAKER)
			                    VALUES(@PLANTCODE,  @LS_NOWDATE, @LI_PSEQ,   @LS_FLOTNO, @ITEMCODE,   'WH003',   'IN',         '45',         @PRODQTY,    @UNITCODE,   @LD_NOWDATE, @LS_WORKERID)

	END;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = @LS_FLOTNO;
END
