SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.05
-- Description:	���� ���� ��� ���.
-- =============================================
ALTER PROCEDURE [dbo].[13MM_StockOut_I]
  @PLANTCODE	VARCHAR(10) -- ����
, @LOTNO		VARCHAR(30) -- LOT NO
, @ITEMCODE		VARCHAR(30) -- ǰ��
, @QTY			VARCHAR(10) -- ��� ����
, @UNITCODE		VARCHAR(10) -- ����
, @WORKERID		VARCHAR(30) -- ���� ��� �����.

, @LANG			VARCHAR(10) = 'KO'
, @RS_CODE		VARCHAR(1) OUTPUT	  -- ���ν��� ���� �Ͻ�
, @RS_MSG		VARCHAR(100) OUTPUT	  -- ���ν��� ���� ����

AS
BEGIN
	-- ���� ���� ��� DB ó�� ���� ����.
	DECLARE @LD_NOWDATE DATETIME
	      , @LS_NOWDATE VARCHAR(10);
	
	SET @LD_NOWDATE = GETDATE();
	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);

	-- 1. ���� ���� ���� ��ϵǾ� �ִ� ��� �´� �� Ȯ��.
	DECLARE @LOT_CNT INT;

	-- ���� ��� ���̺� ���� ������ LOT�� ��� ������ ���� Ȯ��.
	SELECT @LOT_CNT = COUNT(*)
	  FROM TB_StockMM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND MATLOTNO  = @LOTNO;

	IF (ISNULL(@LOT_CNT, 0) = 0)
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '���� ��� �������� �ʽ��ϴ�.';
		RETURN;
	END;

	-- 2. ���� ��� �̷� ���.
	-- 2-1 ���� ��� �̷� ���� ��ȸ
	DECLARE @LI_SEQ INT;

	SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ), 0) + 1
		FROM TB_StockMMrec WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		AND INOUTDATE = @LS_NOWDATE;

	INSERT INTO TB_StockMMrec (PLANTCODE,   MATLOTNO,   INOUTCODE,   INOUTQTY,   INOUTDATE,   INOUTWORKER,    ITEMCODE,
		                        INOUTSEQ,    WHCODE,     INOUTFLAG,   MAKER,      MAKEDATE)
						VALUES (@PLANTCODE,  @LOTNO,     '20',        @QTY,       @LS_NOWDATE,    @WORKERID,  @ITEMCODE,
						        @LI_SEQ,     'WH001',    'OUT',       @WORKERID,  @LD_NOWDATE);
	
	-- 3. ���� ��� ����.
	DELETE TB_StockMM
	 WHERE PLANTCODE = @PLANTCODE
	   AND MATLOTNO  = @LOTNO;

	-- 4. ���� ��� ���.
	INSERT INTO TB_StockPP (PLANTCODE,   LOTNO,  ITEMCODE,  WHCODE, STOCKQTY, UNITCODE,  INDATE,      MAKEDATE,    MAKER)
	                VALUES (@PLANTCODE, @LOTNO, @ITEMCODE, 'WH003', @QTY,    @UNITCODE, @LS_NOWDATE, @LD_NOWDATE, @WORKERID);
	
	-- 5. ���� ��� ���� �̷� ���.
	DECLARE @LI_PPSEQ INT;

	SELECT @LI_PPSEQ = ISNULL(MAX(INOUTSEQ), 0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE   = @LS_NOWDATE;

	INSERT INTO TB_StockPPrec ( PLANTCODE,  RECDATE,     INOUTSEQ,  LOTNO,  ITEMCODE,  WHCODE, INOUTFLAG, INOUTCODE, UNITCODE, INOUTQTY,  MAKER,     MAKEDATE)
	                   VALUES (@PLANTCODE, @LS_NOWDATE, @LI_PPSEQ, @LOTNO, @ITEMCODE, 'WH003', 'IN',      '20',     @UNITCODE, @QTY,     @WORKERID, @LD_NOWDATE)

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';

END
GO
