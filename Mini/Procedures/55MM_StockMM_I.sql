USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_StockMM_I]    Script Date: 2022-07-14 오후 6:29:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		5조
-- Create date: 2022-07-12
-- Description:	수입검사 요청
-- =============================================
ALTER PROCEDURE [dbo].[55MM_StockMM_I]
	@PLANTCODE  VARCHAR(10), -- 공장
	@LOTNO	    VARCHAR(30), -- LOTNO
	@REQUESTER  VARCHAR(30), -- 수입검사 요청자.
	@ITEMCODE   VARCHAR(20), -- 품번
	@INSPQTY    FLOAT,   -- 검사수량
	

	
	@LANG		VARCHAR(10)  = 'KO',
	@RS_CODE	VARCHAR(1)   OUTPUT,
	@RS_MSG		VARCHAR(100) OUTPUT  
AS
BEGIN

		-- 프로시져에서 공통으로 사용할 일자,일시 변수.
	DECLARE @LD_NOWDATE DATETIME     -- 프로시져 실행 일시
	       ,@LS_NOWDATE VARCHAR(10)  -- 프로시져 실행 일자.
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

	  -- 2. 수입검사 이력 등록
	  DECLARE @LI_INSPSEQ INT;

	  SELECT @LI_INSPSEQ = ISNULL(MAX(INSPSEQ),0) + 1 
	    FROM TB_ROHIQI WITH(NOLOCK)
	   WHERE PLANTCODE  = @PLANTCODE
	     AND LOTNO		= @LOTNO;

		

	  INSERT INTO TB_ROHIQI(PLANTCODE,LOTNO,    INSPSEQ,   REQDATE,  REQUESTER, ITEMCODE, INSPQTY, MAKEDATE, MAKER)
					VALUES(@PLANTCODE, @LOTNO, @LI_INSPSEQ, @LD_NOWDATE ,@REQUESTER ,@ITEMCODE, @INSPQTY ,@LD_NOWDATE ,@REQUESTER)
		

		SET @RS_CODE = 'S';
END

