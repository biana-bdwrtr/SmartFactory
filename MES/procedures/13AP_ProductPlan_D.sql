SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.04
-- Description:	���� ��ȹ �� ���� ����
-- =============================================
CREATE PROCEDURE [dbo].[13AP_ProductPlan_D]
	@PLANTCODE			VARCHAR(10) -- ���� �ڵ�
  , @PLANNO				VARCHAR(20) -- ��ȹ ��ȣ

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1) OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT

AS
BEGIN
	-- �۾� ���� Ȯ���� �������� ���� Ȯ��.
	

	IF (SELECT ISNULL(ORDERFLAG, 'N')
	      FROM TB_ProductPlan WITH(NOLOCK)
	     WHERE PLANTCODE = @PLANTCODE
	       AND PLANNO	 = @PLANNO) <> 'N'
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾� ���� Ȯ���� ������ �����մϴ�. ���� ��ȹ �� ������ �����Ϸ��� �۾� ���� Ȯ���� ������ ���� ����ϼ���.';
		RETURN;
	END;

	-- ���� ��ȹ �� ���� ����.
	DELETE TB_ProductPlan
	 WHERE PLANTCODE = @PLANTCODE
	   AND PLANNO    = @PLANNO;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
END
GO
