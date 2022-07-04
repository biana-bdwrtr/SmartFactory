SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.04
-- Description:	�������� ���� ���� �԰� ���.
-- =============================================
ALTER PROCEDURE [dbo].[13MM_POMake_U]
  -- PK
	@PLANTCODE 			   VARCHAR(10) -- ���� �ڵ�
  , @PONO				   VARCHAR(20) -- ���� ��ȣ
  , @PODATE 			   VARCHAR(10) -- ���� ����
  , @POSEQ  			   VARCHAR(10) -- ���� ������

  -- �԰� ����
  , @ITEMCODE              VARCHAR(10)  -- ǰ�� �ڵ�
--  , @INFLAG				   VARCHAR(10)  -- �԰� ����
  , @INQTY  			   VARCHAR(10)  -- �԰� ����
--  , @LOTNO  			   VARCHAR(10)  -- LOT NO
--  , @INDATE 			   VARCHAR(10)  -- �԰� ����
--  , @INWORKER			   VARCHAR(10)  -- �԰���
  , @EDITOR   			   VARCHAR(10)  -- �԰� �����

  , @LANG				   VARCHAR(10) = 'KO'
  , @RS_CODE			   VARCHAR(1) OUTPUT
  , @RS_MSG				   VARCHAR(100) OUTPUT

AS
BEGIN
	-- ���ν������� �������� ����� ����, �Ͻ� ����.
	DECLARE @LD_NOWDATE DATETIME	-- PROCEDURE ���� �Ͻ�
	      , @LS_NOWDATE VARCHAR(10) -- PROCEDURE ���� ����
		  ;
		SET @LS_NOWDATE = GETDATE();
		SET @LD_NOWDATE = CONVERT(VARCHAR, @LS_NOWDATE, 23);

	/***********************************
	 * ������ �԰�
	 * LOT NO ä��
	 * 1. ���� ������ �԰� ���� ���.
	 * 2. ���� ��� ����.
	 * 3. ���� ��/��� �̷� ���.
	 ***********************************/

	-- LOT NO ä��
	DECLARE @LS_LOTNO		VARCHAR(30)
	-- '-', ':', ' ', '.' ����
	SET @LS_LOTNO = 'LT_R' + REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),121),'-',''),':',''),' ',''),'.','')

	-- 1. ���� ������ �԰� ���� ���.
	UPDATE TB_POMake
	   SET INFLAG   = 'Y'
	     , LOTNO    = @LS_LOTNO
		 , INQTY    = @INQTY
		 , INDATE   = @LS_NOWDATE
		 , INWORKER = @EDITOR
		 , EDITDATE = @LD_NOWDATE
		 , EDITOR   = @EDITOR
	 WHERE PLANTCODE = @PLANTCODE
	   AND PONO      = @PONO
	   AND POSEQ     = @POSEQ
	   AND PODATE    = @PODATE;

	-- CUSTCODE, UNITCODE ��������.
	DECLARE @LS_UNITCODE VARCHAR(10)
	      , @LS_CUSTCODE VARCHAR(10);

	SELECT @LS_UNITCODE = UNITCODE
	     , @LS_CUSTCODE = CUSTCODE
	  FROM TB_POMake WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND PONO      = @PONO
	   AND POSEQ     = @POSEQ
	   AND PODATE    = @PODATE;


	-- 2. ���� ��� ����.
	INSERT INTO TB_StockMM (PLANTCODE,  ITEMCODE,  MATLOTNO,  WHCODE,  STOCKQTY,  UNITCODE,  INDATE,      CUSTCODE,  MAKEDATE,    MAKER)
	                VALUES (@PLANTCODE, @ITEMCODE, @LS_LOTNO, 'WH001', @INQTY,    '',        @LS_NOWDATE, '',        @LD_NOWDATE, @EDITOR)

	-- 3. ���� ��/��� �̷� ���.
	DECLARE @LI_INOUTSEQ INT;
	SELECT @LI_INOUTSEQ =  ISNULL(MAX(INOUTSEQ), 0) + 1
	  FROM TB_StockMMrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND INOUTDATE = @LS_NOWDATE;

	INSERT INTO TB_StockMMrec(PLANTCODE,  MATLOTNO,  ITEMCODE,  INOUTDATE,  INOUTQTY,  INOUTCODE,  INOUTWORKER,
	                          PONO,       INOUTSEQ,  WHCODE,    INOUTFLAG,  MAKER,     MAKEDATE)
					   VALUES(@PLANTCODE, @LS_LOTNO, @ITEMCODE, @LS_NOWDATE, @INQTY,   '10',       @EDITOR,
					          @PONO,      @LI_INOUTSEQ, 'WH001', 'IN',       @EDITOR,  @LS_NOWDATE);

	SET @RS_CODE = 'S';
	SET @RS_MSG = '���� �۵�';

END
GO
