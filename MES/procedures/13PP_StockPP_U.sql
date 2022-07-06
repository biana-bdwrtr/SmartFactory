USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13PP_StockPP_U]    Script Date: 2022-07-06 오후 3:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.07.06
-- Description: 원자재 출고 취소 / 원자재 재고 환입.
-- =============================================
ALTER PROCEDURE [dbo].[13PP_StockPP_U]
  @PLANTCODE	   VARCHAR(10) -- 공장 코드
, @LOTNO  		   VARCHAR(30) -- LOT NO
, @ITEMCODE		   VARCHAR(30) -- 품목 코드
, @QTY    		   VARCHAR(10) -- 재고 수량
, @UNITCODE		   VARCHAR(10) -- 단위
, @WORKERID		   VARCHAR(30) -- 환입등록자

, @LANG			   VARCHAR(10) = 'KO'
, @RS_CODE		   VARCHAR(1) OUTPUT
, @RS_MSG		   VARCHAR(100) OUTPUT
AS
BEGIN
DECLARE @LD_NOWDATE DATETIME
      , @LS_NOWDATE VARCHAR(10);
	SET @LD_NOWDATE = GETDATE();
	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23); -- yyyy-MM-dd

-- Validation Check
-- 1. 공정 재고에 있는 LOT인지 확인.
IF(SELECT COUNT(*)
     FROM TB_StockPP WITH(NOLOCK)
	WHERE PLANTCODE = @PLANTCODE
	  AND LOTNO     = @LOTNO) = 0
BEGIN
	SET @RS_CODE = 'E';
	SET @RS_MSG  = '공정 재고에 없는 LOTNO 입니다.';
	RETURN;
END;

-- 2. 선택한 LOT가 원자재 LOT인지 확인. (원자재 창고로 환입)
IF (SELECT ITEMTYPE
      FROM TB_ItemMaster WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND ITEMCODE = @ITEMCODE) <> 'ROH' -- 원자재가 아니라면
BEGIN
	SET @RS_CODE = 'E';
	SET @RS_MSG  = '원자재 환입 대상이 아닙니다.';
	RETURN;
END;

-- 3. 원자재 환입 로직.
-- 3.1 공정 재고 삭제.
DELETE TB_StockPP
 WHERE PLANTCODE = @PLANTCODE
   AND LOTNO = @LOTNO;

-- 3.2 공정 재고 출고 이력 등록.
DECLARE @LI_SEQ INT
SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ), 0) +1
  FROM TB_StockPPrec WITH(NOLOCK)
 WHERE PLANTCODE = @PLANTCODE
   AND RECDATE   = @LS_NOWDATE;

INSERT INTO TB_StockPPrec (PLANTCODE,   RECDATE,    INOUTSEQ, LOTNO,  ITEMCODE,  WHCODE, INOUTFLAG, INOUTQTY,  UNITCODE, INOUTCODE, MAKEDATE,    MAKER)
                   VALUES (@PLANTCODE, @LS_NOWDATE, @LI_SEQ, @LOTNO, @ITEMCODE, 'WH003', 'OUT',     @QTY,     @UNITCODE, '25',     @LD_NOWDATE, @WORKERID);


DECLARE @LS_CUSTCODE VARCHAR(10);

SELECT @LS_CUSTCODE = CUSTCODE
  FROM TB_POMake WITH(NOLOCK)
 WHERE PLANTCODE = @PLANTCODE
   AND LOTNO     = @LOTNO;


-- 4. 원자재 재고 등록.
INSERT INTO TB_StocKMM (PLANTCODE,   MATLOTNO, WHCODE,   ITEMCODE,  STOCKQTY, INDATE,      UNITCODE,   CUSTCODE,      MAKER,     MAKEDATE)
                VALUES (@PLANTCODE, @LOTNO,    'WH001', @ITEMCODE, @QTY,      @LS_NOWDATE, @UNITCODE,  @LS_CUSTCODE, @WORKERID, @LD_NOWDATE);

-- 5. 원자재 환입 이력 등록.
DECLARE  @LI_MMERCSEQ INT;

SELECT @LI_MMERCSEQ = ISNULL(MAX(INOUTSEQ), 0) + 1
  FROM TB_StockMMrec WITH(NOLOCK)
 WHERE PLANTCODE = @PLANTCODE
   AND INOUTDATE = @LS_NOWDATE;

INSERT INTO TB_StockMMrec ( PLANTCODE,  INOUTDATE,   INOUTSEQ,     MATLOTNO, ITEMCODE,  INOUTQTY, INOUTWORKER, WHCODE,  INOUTFLAG, INOUTCODE, MAKER,     MAKEDATE)
                   VALUES (@PLANTCODE, @LS_NOWDATE, @LI_MMERCSEQ, @LOTNO,   @ITEMCODE, @QTY,      @WORKERID,   'WH001', 'IN',      '25',      @WORKERID, @LD_NOWDATE)


	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 작동';

END
