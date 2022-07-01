SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.01
-- Description:	���� ��ȹ�� �۾� ���� Ȯ�� �� ���.
-- =============================================
ALTER PROCEDURE [dbo].[13AP_ProductPlan_U]
	@PLANTCODE   			VARCHAR(10)  -- ����
  , @PLANNO   				VARCHAR(30)  -- �۾� ���ø� Ȯ�� �� ����� ���� ��ȹ ��ȣ
  , @ORDERFLAG  			VARCHAR(1)   -- �۾� ���� Ȯ��/��� ����
  , @WORKCENTERCODE			VARCHAR(100) -- �۾���
  , @EDITOR   				VARCHAR(30)  -- �۾� ���� Ȯ�� �� �����

  , @LANG					 VARCHAR(10) = 'KO'
  , @RS_CODE				 VARCHAR(1)   OUTPUT
  , @RS_MSG					 VARCHAR(100) OUTPUT

AS
BEGIN
	-- ���ν������� �������� ����� ����, �Ͻ� ����.
	DECLARE @LD_NOWDATE DATETIME    -- PROCEDURE ���� �Ͻ�
	      , @LS_NOWDATE VARCHAR(10) -- PROCEDURE ���� ����
	;

		SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);
	
	IF (@ORDERFLAG = 'Y') -- �۾� ���� Ȯ��
	BEGIN
		-- �۾����� Ȯ�� ���� Ȯ��
		DECLARE @LS_ORDERFLAG VARCHAR(1);
		SELECT @LS_ORDERFLAG = ORDERFLAG
		  FROM TB_ProductPlan WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND PLANNO    = @PLANNO

		IF (@LS_ORDERFLAG = 'Y')
		BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '�̹� Ȯ���� �۾� �����Դϴ�.';
			RETURN;
		END;

		-- �۾� ���� ��ȣ ä��.
		DECLARE @LI_SEQ INT;
		SELECT @LI_SEQ = ISNULL(MAX(ORDERSEQ), 0) + 1
		  FROM TB_ProductPlan WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND ORDERDATE = @LS_NOWDATE;
		

		DECLARE @LS_ORDERNO VARCHAR(30);
		SET @LS_ORDERNO = 'ORD' + CONVERT(VARCHAR, @LD_NOWDATE, 112) + RIGHT('0000' + CONVERT(VARCHAR, @LI_SEQ), 4);

		UPDATE TB_ProductPlan
		   SET ORDERFLAG      = 'Y'		         -- �۾� ���� Ȯ�� ����
		     , ORDERNO        = @LS_ORDERNO      -- �۾� ���� ��ȣ
			 , ORDERSEQ       = @LI_SEQ	         -- ���ں� �۾� ���� ����
			 , ORDERDATE      = @LS_NOWDATE      -- �۾� ���� ����
			 , ORDERTEMP      = @LD_NOWDATE      -- �۾� ���� �Ͻ�
			 , ORDERWORKER    = @EDITOR          -- �۾� ���� Ȯ����
			 , WORKCENTERCODE = @WORKCENTERCODE  -- �۾���
			 , EDITDATE       = @LD_NOWDATE      -- �����Ͻ�
			 , EDITOR         = @EDITOR          -- ������
		 WHERE PLANTCODE      = @PLANTCODE
		   AND PLANNO         = @PLANNO          -- ���� ��ȹ ��ȣ�� �۾����� ���
		   ;

	END;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';

END
GO
