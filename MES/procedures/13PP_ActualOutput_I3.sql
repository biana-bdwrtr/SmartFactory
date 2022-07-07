SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �̱��
-- Create date: 2022.07.
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[13PP_ActualOutput_I3]
	@PLANTCODE			VARCHAR(10) -- ���� �ڵ�
  , @WORKCENTERCODE		VARCHAR(10) -- �۾���
  , @ITEMCODE      		VARCHAR(30) -- ���� ǰ��
  , @ORDERNO       		VARCHAR(30) -- �۾� ���� ��ȣ
  , @LOTNO         		VARCHAR(30) -- ���� ������ LOT NO
  , @WORKERID			VARCHAR(30) -- �۾��� ID(�����ϴ� ���)
  , @UNITCODE      		VARCHAR(10) -- ���� ǰ�� ����
  , @INFLAG        		VARCHAR(30) -- ���� /��� ���� (IN : ���� ó��, OUT: ��� ó��)

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1) OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT


AS
BEGIN
	-- ���ν������� �������� ����� ����, �Ͻ� ����.
	DECLARE @LD_NOWDATE DATETIME    -- PROCEDURE ���� �Ͻ�
	      , @LS_NOWDATE VARCHAR(10) -- PROCEDURE ���� ����
	;

	SET @LD_NOWDATE = GETDATE();
	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23);

	-- �۾� ���� ���� ���� Ȯ��
	IF (
		SELECT ISNULL(ORDERNO, '')
		  FROM TP_WorkcenterStatus WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
	) = ''
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾� ���ø� �������� �ʾҽ��ϴ�.';
		RETURN;
	END;

	-- ������ LOT ��� ��� ����.
	DECLARE @LS_CITEMCODE VARCHAR(30) -- ������ LOT ǰ��
	      , @LF_STOCKQTY FLOAT        -- ������ LOT ������
	;

	IF (@INFLAG = 'IN')
	BEGIN
		-- ���� â�� ��ϵ� LOT�� �����Ϸ��� �ϴ� �� üũ.
		SELECT @LS_CITEMCODE = ITEMCODE
		     , @LF_STOCKQTY  = STOCKQTY
		  FROM TB_StockPP WITH(NOLOCK) -- ���� â�� ���
		 WHERE PLANTCODE = @PLANTCODE
		   AND LOTNO     = @LOTNO
		;

		IF (ISNULL(@LS_CITEMCODE, '') = '')
		BEGIN
			SET @RS_CODE = 'E';
			SET @RS_MSG  = '���� â�� ��ϵ��� ���� �������Դϴ�.';
			RETURN;
		END;

		-- BOM �� ����� ���� ǰ��(������)���� Ȯ��.
		IF (
			SELECT COUNT(*)
			  FROM TB_BomMaster WITH(NOLOCK)
			 WHERE ITEMCODE = @ITEMCODE
			   AND COMPONENT = @LS_CITEMCODE
			) = 0
		BEGIN
			SET @RS_CODE = 'E';
			SET @RS_MSG  = '�۾� ���� ǰ���� ������ �� ���� ������ LOT �Դϴ�.';
			RETURN;
		END;

		-- ��� ��� ���ԵǾ� �ִ� LOT�� �ִ� �� Ȯ��.
		IF (
			SELECT COUNT(*)
			  FROM TB_StockHALB WITH(NOLOCK) -- ��� ��� ���̺�
			 WHERE PLANTCODE = @PLANTCODE
			   AND WORKCENTERCODE = @WORKCENTERCODE
			) <> 0
		BEGIN
			SET @RS_CODE = 'E';
			SET @RS_MSG  = '���� �۾��忡 ���ԵǾ� �ִ� LOT�� �����մϴ�. ��� �� �����ϼ���.';
			RETURN;
		END;
	END;




	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� ó��';
END
GO