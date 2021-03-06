USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[00WM_ProdInStock_U1]    Script Date: 2022-07-11 오전 11:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : PP_ProdInStock_S1
  PROCEDURE NAME : 제품창고 입고 처리
  ALTER DATE     : 2022.07
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[00WM_ProdInStock_U1]
(
      @PLANTCODE       VARCHAR(10)    -- 공장
	 ,@LOTNO           VARCHAR(30)    -- LOTNO
	 ,@ITEMCODE		   VARCHAR(30)    -- 품목코드
	 ,@INOUTQTY        FLOAT		  -- 입고수량
	 ,@UNITCODE        VARCHAR(1)	  -- 단위
	 ,@MAKER		   VARCHAR(10)    -- 등록자
     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
    BEGIN TRY
		--현재시간 정의
		DECLARE @LD_NOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
		    SET @LD_NOWDATE = GETDATE()
			SET @LS_NOWDATE = SUBSTRING(CONVERT(VARCHAR,GETDATE(),120),1,10)

		
		-- 공정 재고 삭제 이력 생성 
		DECLARE @LI_INOUTSEQ INT
		 SELECT @LI_INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		   FROM TB_StockPPrec WITH(NOLOCK)
		  WHERE PLANTCODE = @PLANTCODE
		    AND RECDATE   = @LS_NOWDATE
		
		INSERT INTO TB_StockPPrec (PLANTCODE , INOUTSEQ,     RECDATE,     LOTNO,  ITEMCODE,  WHCODE,  INOUTFLAG,   INOUTCODE,  INOUTQTY,  UNITCODE,  MAKEDATE,    MAKER)
		                    VALUES(@PLANTCODE, @LI_INOUTSEQ, @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH003', 'O',         '50',       @INOUTQTY, @UNITCODE, @LD_NOWDATE, @MAKER)

		-- 공정 재고 삭제 
		DELETE TB_StockPP WHERE PLANTCODE = @PLANTCODE AND LOTNO = @LOTNO

		-- 제품창고 등록
		INSERT INTO TB_StockWM (PLANTCODE,  LOTNO,   ITEMCODE,   WHCODE,   STOCKQTY,   INDATE,      MAKEDATE,    MAKER)
					    VALUES (@PLANTCODE, @LOTNO,  @ITEMCODE,  'WH008',  @INOUTQTY,  @LS_NOWDATE, @LD_NOWDATE, @MAKER)

		-- 공정 재고 삭제 이력 생성 
		 SELECT @LI_INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		   FROM TB_StockWMrec WITH(NOLOCK)
		  WHERE PLANTCODE    = @PLANTCODE
		    AND RECDATE      = @LS_NOWDATE

		-- 제품창고 등록 이력 생성
		INSERT INTO TB_StockWMrec (PLANTCODE , INOUTSEQ,     RECDATE,     LOTNO,  ITEMCODE,  WHCODE,  INOUTFLAG,   INOUTCODE,  INOUTQTY,  UNITCODE,  MAKEDATE,    MAKER)
		                    VALUES(@PLANTCODE, @LI_INOUTSEQ, @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH008', 'I',        '50',        @INOUTQTY, @UNITCODE, @LD_NOWDATE, @MAKER)

    SELECT @RS_CODE = 'S'

    END TRY

    BEGIN CATCH
        INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
    END CATCH
END






