SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.04
-- Description:	������ ���� ���.
-- =============================================
ALTER PROCEDURE [dbo].[13MM_POMake_I]
	@PLANTCODE		   VARCHAR(10) -- ����
  , @ITEMCODE		   VARCHAR(30) -- ���� ǰ��(����)
  , @PODATE			   VARCHAR(10) -- ���� ����
  , @POQTY  		   FLOAT       -- ���� ����
  , @UNITCODE		   VARCHAR(10) -- ����
  , @CUSTCODE		   VARCHAR(10) -- �ŷ�ó(���¾�ü)
  , @MAKER			   VARCHAR(30) -- �����

  , @LANG			   VARCHAR(10) = 'KO'
  , @RS_CODE		   VARCHAR(1) OUTPUT
  , @RS_MSG			   VARCHAR(100) OUTPUT

AS
BEGIN
	-- ���ν������� �������� ����� ����, �Ͻ� ����.
	DECLARE @LD_NOWDATE DATETIME		  -- ���ν��� ���� �Ͻ�
	      , @LS_NOWDATE VARCHAR(10);	  -- ���ν��� ���� ����
		SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);

	DECLARE @LI_SEQ INT
	      , @LS_PONO VARCHAR(30);


	SELECT @LI_SEQ = ISNULL(MAX(POSEQ), 0) +1
	  FROM TB_POMake WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND PODATE    = @PODATE;

	SET @LS_PONO = 'PO' + REPLACE(@PODATE, '-', '') + RIGHT('00000' + CONVERT(VARCHAR, @LI_SEQ), 4);

	--                     ����        ǰ��       ���ֹ�ȣ  ���� ����   ���� ����   ���� ����     ����        ���¾�ü     �����   ��� ����
	INSERT INTO TB_POMake (PLANTCODE,  ITEMCODE,  PONO,     POSEQ,      PODATE,     POQTY,       UNITCODE,    CUSTCODE,    MAKER,   MAKEDATE)
	     VALUES           (@PLANTCODE, @ITEMCODE, @LS_PONO, @LI_SEQ,    @PODATE,    @POQTY,      @UNITCODE,   @CUSTCODE,   @MAKER,  @LD_NOWDATE);

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';

END
GO
