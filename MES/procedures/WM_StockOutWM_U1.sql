USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[WM_StockOutWM_U1]    Script Date: 2022-07-11 오후 12:12:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2022-07-11
-- Description:	상차 내역 출고 등록
-- =============================================
ALTER PROCEDURE [dbo].[WM_StockOutWM_U1]
	@PLANTCODE VARCHAR(10)
   ,@SHIPNO    VARCHAR(30)
   ,@TRADINGNO VARCHAR(30)
   ,@MAKER	   VARCHAR(20)
   

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN

	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
	
	-- 이미 출고 된 내역인지 확인.
	DECLARE @LS_TRADINGNO  VARCHAR(30)
	
	SELECT @LS_TRADINGNO = TRADINGNO 
	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO    = @SHIPNO

	IF ISNULL(@LS_TRADINGNO,'') <> ''
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 출고 처리 된 상차 번호 입니다. : '  + @SHIPNO
		RETURN;
	END

	IF (SELECT COUNT(*)
	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO    = @SHIPNO) = 0
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '취소 된 상차 번호 입니다. : '  + @SHIPNO
		RETURN;
	END

	DECLARE @LS_CARNO    VARCHAR(20)  -- 상차 차량 번호
		   ,@LS_CUSTCODE VARCHAR(20)  -- 거래처 코드 

	SELECT @LS_CARNO    = CARNO 
	      ,@LS_CUSTCODE = CUSTCODE
	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO    = @SHIPNO

	---- 가장 첫 행일 경우 채번 및 헤더 바디 등록
	IF ISNULL(@TRADINGNO,'') = ''
	BEGIN
		-- 거래 명세서 번호 채번 
		SET @LS_TRADINGNO = 'INVO' 
			               + REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),121),'-',''),':',''),' ',''),'.','')
		
		-- 거래 명세 헤더 등록
		INSERT INTO TB_TradingWM(PLANTCODE,   TRADINGNO,         TRADINGDATE,   CARNO,      MAKEDATE,    MAKER)
						 VALUES (@PLANTCODE,  @LS_TRADINGNO,     @LS_NOWDATE,   @LS_CARNO,  @LD_NOWDATE, @MAKER)
	END 

	DECLARE @LI_TRADINGSEQ   INT		  -- 거래명세 순번
	       ,@LS_LOTNO        VARCHAR(30)  -- 제품 LOT
		   ,@LS_ITEMCODE     VARCHAR(30)  -- 제품 품목코드
		   ,@LF_SHIPQTY      FLOAT        -- 출고수량
		   ,@LI_INOUTSEQ     INT	      -- 제품창고 출고 순번
		   ,@LS_UNITCODE     VARCHAR(10)  -- 단위
		   ,@LS_FINTRADINGNO VARCHAR(30)  -- 신규/기존 거래명세 번호
		   ,@LI_SHIPSEQ      INT          -- 상차 순번

	SET @LS_FINTRADINGNO = ISNULL(@LS_TRADINGNO,@TRADINGNO) -- 신규/기존 거래명세 번호

	SELECT @LI_TRADINGSEQ = ISNULL(MAX(TRADINGSEQ),0) + 1
	  FROM TB_TRADINGWM_B WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND TRADINGNO = @TRADINGNO

	-- 커서 선언
	DECLARE CUR CURSOR FOR
	SELECT A.LOTNO,			-- LOTNO
		   A.ITEMCODE,		-- 품목코드
		   A.SHIPQTY,		-- 출고 수량
		   B.BASEUNIT,		-- 단위
		   A.SHIPSEQ        -- 상차 순번
	  FROM TB_ShipWM_B A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
										   ON A.PLANTCODE = B.PLANTCODE
										  AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.SHIPNO    = @SHIPNO
	OPEN CUR	-- 커서 시작
	FETCH NEXT FROM CUR INTO @LS_LOTNO, @LS_ITEMCODE, @LF_SHIPQTY, @LS_UNITCODE,@LI_SHIPSEQ  -- 첫 행 데이터 입력
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		INSERT INTO TB_TRADINGWM_B (PLANTCODE,     TRADINGNO,          TRADINGSEQ,         LOTNO,       ITEMCODE,       TRADINGQTY,    SHIPNO, SHIPSEQ,      MAKEDATE,     MAKER)
	                        VALUES (@PLANTCODE,    @LS_FINTRADINGNO,   @LI_TRADINGSEQ,     @LS_LOTNO,   @LS_ITEMCODE,   @LF_SHIPQTY,   @SHIPNO,@LI_SHIPSEQ,  @LD_NOWDATE,  @MAKER)
		
		SET @LI_TRADINGSEQ = @LI_TRADINGSEQ + 1

		-- 제품 재고 삭제 
	    DELETE TB_StockWM
		 WHERE PLANTCODE = @PLANTCODE
		   AND LOTNO     = @LS_LOTNO

		-- 제품 재고 출고 이력 등록
		SELECT @LI_INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		  FROM TB_StockWMrec WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND RECDATE   = @LS_NOWDATE

		INSERT INTO TB_StockWMrec (PLANTCODE,    INOUTSEQ,     RECDATE,     LOTNO,      ITEMCODE,     WHCODE,     INOUTFLAG,     INOUTCODE,   INOUTQTY,     UNITCODE,      MAKEDATE,     MAKER	)
						    VALUES(@PLANTCODE,   @LI_INOUTSEQ, @LS_NOWDATE, @LS_LOTNO,  @LS_ITEMCODE, 'WH008',    'O',           '60',        @LF_SHIPQTY,  @LS_UNITCODE,  @LD_NOWDATE,  @MAKER)

		FETCH NEXT FROM CUR INTO @LS_LOTNO, @LS_ITEMCODE, @LF_SHIPQTY, @LS_UNITCODE,@LI_SHIPSEQ -- 다음 행 데이터 입력
	END
	CLOSE CUR		
	DEALLOCATE CUR  -- 커서 종료


	-- 상차 정보 헤더에 에 거래 명세서 내역 등록
	UPDATE TB_ShipWM 
	   SET TRADINGNO   = @LS_FINTRADINGNO
	      ,TRADINGDATE = @LS_NOWDATE
		  ,EDITDATE	   = @LD_NOWDATE
		  ,EDITOR      = @MAKER
	 WHERE PLANTCODE   = @PLANTCODE
	   AND SHIPNO      = @SHIPNO

	
	SET @RS_MSG  = @LS_FINTRADINGNO
	SET @RS_CODE = 'S'
	
END


