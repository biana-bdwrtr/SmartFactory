USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_Stockout_I]    Script Date: 2022-07-14 오후 6:29:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		문한석
-- Create date: 2022-07-12
-- Description:	자재 생산 출고 등록.
-- =============================================
ALTER PROCEDURE [dbo].[55MM_Stockout_I]
	@PLANTCODE   VARCHAR(10), -- 공장
	@LOTNO	     VARCHAR(30), -- LOTNO
	@ITEMCODE    VARCHAR(30), -- 품목코드
	@QTY         FLOAT,       -- 재고수량
	@UNITCODE    VARCHAR(10), -- 단위
	@WORKERID    VARCHAR(30), -- 생산 출고 등록자.
	
	@LANG		  VARCHAR(10)  = 'KO',
	@RS_CODE	  VARCHAR(1)   OUTPUT,
	@RS_MSG		  VARCHAR(100) OUTPUT  
AS
BEGIN
		-- 자재 생산 출고 DB 처리 로직 시작.
		
		-- 프로시져에서 공통으로 사용할 일자,일시 변수.
	DECLARE @LD_NOWDATE DATETIME     -- 프로시져 실행 일시
	       ,@LS_NOWDATE VARCHAR(10)  -- 프로시져 실핼 일자.
	    SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23);


		-- 1. 현재 자재 재고로 등록되어 있는 재고 가 맞는지 확인.
		DECLARE @LOT_CNT INT;

		-- 자재 재고 테이블에 현재 선택한 LOT 의 재고 데이터 유무 확인.
		SELECT @LOT_CNT = COUNT(*) 
		  FROM TB_StockMM WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND MATLOTNO  = @LOTNO

		IF (ISNULL(@LOT_CNT,0) = 0)
		BEGIN 
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '자재 재고가 존재하지 않습니다.'
			RETURN;
		END;

	  -- 2. 자재 출고 이력 등록.
	  -- 2-1 자재 출고 이력 순번 조회
	  DECLARE @LI_SEQ INT;

	  SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ),0) + 1 
	    FROM TB_StockMMrec WITH(NOLOCK)
	   WHERE PLANTCODE = @PLANTCODE
	     AND INOUTDATE = @LS_NOWDATE;

		

	  INSERT INTO TB_StockMMrec (PLANTCODE,    MATLOTNO,     INOUTCODE,      INOUTQTY,      INOUTDATE,      INOUTWORKER, ITEMCODE,
								 INOUTSEQ,     WHCODE,       INOUTFLAG,      MAKER,         MAKEDATE)
						  VALUES(@PLANTCODE,   @LOTNO,       '20',           @QTY,          @LS_NOWDATE,    @WORKERID,   @ITEMCODE,
						         @LI_SEQ,      'WH001',      'OUT',          @WORKERID,     @LD_NOWDATE)

	 -- 3. 자재 재고 삭제.
	 DELETE TB_StockMM
	  WHERE PLANTCODE = @PLANTCODE
	    AND MATLOTNO  = @LOTNO;



    -- 4. 공정 재고 등록. 
	INSERT INTO TB_StockPP (PLANTCODE,  LOTNO,    ITEMCODE,    WHCODE,   STOCKQTY,     UNITCODE,    INDATE,        MAKEDATE,     MAKER)
	                 VALUES(@PLANTCODE, @LOTNO,   @ITEMCODE,   'WH003',  @QTY,         @UNITCODE,   @LS_NOWDATE,   @LD_NOWDATE,  @WORKERID);


		   

	-- 5. 공정재고 입출 이력 등록.
	DECLARE @LI_PPSEQ INT;
	SELECT @LI_PPSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE   = @LS_NOWDATE;

	INSERT INTO TB_StockPPrec(PLANTCODE,    RECDATE,     INOUTSEQ,    LOTNO,   ITEMCODE,   WHCODE,   INOUTFLAG,    INOUTCODE,    UNITCODE,    INOUTQTY,
						      MAKER,        MAKEDATE)
					   VALUES (@PLANTCODE, 	@LS_NOWDATE, @LI_PPSEQ,   @LOTNO,  @ITEMCODE,  'WH003',  'IN',         '20',         @UNITCODE,   @QTY,
					          @WORKERID,    @LD_NOWDATE)
			
	SET @RS_CODE = 'S';
END
