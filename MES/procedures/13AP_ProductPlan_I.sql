SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.01
-- Description:	���� ��ȹ ���
-- =============================================
ALTER PROCEDURE [dbo].[13AP_ProductPlan_I]
	@PLANTCODE		   VARCHAR(10) -- ����
  , @ITEMCODE		   VARCHAR(30) -- ǰ�� �ڵ�
  , @PLANQTY		   FLOAT       -- ��ȹ ����
  , @UNITCODE		   VARCHAR(10) -- ����
  , @MAKER			   VARCHAR(30) -- ������(��ȹ ����)

  , @LANG			   VARCHAR(10) = 'KO'
  , @RS_CODE		   VARCHAR(1)   OUTPUT 
  , @RS_MSG			   VARCHAR(100) OUTPUT 

AS
BEGIN
	-- ���ν������� �������� ����� ����, �Ͻ� ����.
	DECLARE @LD_NOWDATE DATETIME    -- PROCEDURE ���� �Ͻ�
	      , @LS_NOWDATE VARCHAR(10) -- PROCEDURE ���� ����
	;

		SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);

	-- ���� ��ȹ ��ȣ ä��.
	DECLARE @LI_SEQ			INT				-- ���ں� ��ȹ ����
	      , @LS_PLANNO		VARCHAR(30)		-- ��ȹ ��ȣ�� ��� ����
	;

	-- ���� ��ȹ �� �۾����� ���̺� TB_ProductPlan���� ���� ���ڷ� ������ ���� ��ȹ ���� ã��.
	SELECT @LI_SEQ = ISNULL(MAX(PLANSEQ), 0) + 1
	  FROM TB_ProductPlan
	 WHERE PLANTCODE = @PLANTCODE
	   AND PLANDATE  = @LS_NOWDATE;

	-- ���� ��ȹ ��ȣ ä��
	SET @LS_PLANNO = 'PL' + CONVERT(VARCHAR, @LD_NOWDATE, 112) + RIGHT('0000' + CONVERT(VARCHAR, @LI_SEQ), 4);
	
	-- ���� ��ȹ ���:         ����,       ��ȹ��ȣ,   ǰ��,      ��ȹ����, ����,      ��ȹ����,    ���ں� ��ȹ����
	INSERT INTO TB_ProductPlan(PLANTCODE,  PLANNO,     ITEMCODE,  PLANQTY,  UNITCODE,  PLANDATE,    PLANSEQ, MAKER,  MAKEDATE)
	                    VALUES(@PLANTCODE, @LS_PLANNO, @ITEMCODE, @PLANQTY, @UNITCODE, @LS_NOWDATE, @LI_SEQ, @MAKER, @LD_NOWDATE);

	SET @RS_CODE = 'S'	
END
GO
