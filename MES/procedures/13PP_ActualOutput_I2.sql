SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �̱��
-- Create date: 2022.07.07
-- Description:	���� ���� ��� - �۾� ���� ���.
-- =============================================
ALTER PROCEDURE [dbo].[13PP_ActualOutput_I2]
	@PLANTCODE			VARCHAR(10) -- ���� �ڵ�
  , @WORKCENTERCODE		VARCHAR(10) -- �۾���
  , @ORDERNO			VARCHAR(30) -- �۾� ���� ��ȣ
  , @WORKERID			VARCHAR(30) -- �۾��� ID

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

	-- 1. ���� LOT�� �����ϴ� �� Ȯ��.
	IF (
		SELECT COUNT(*)
		  FROM TB_StockHALB WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
		) <> 0
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '���Ե� ������ LOT�� �����մϴ�.' + char(13) + char(10) + '����ȸ �� ���� LOT�� ����ϼ���.';
		RETURN;
	END;

	-- 2. �۾��� ���� ���� ���̺��� �۾����� ���� ������ ��������.
	DECLARE @LS_WORKER			  VARCHAR(30) -- ���� ��ϵ� �۾���
	      , @LS_STATUS			  VARCHAR(1)  -- ���� �۾����� ���� ����
		  , @LS_PERORDERNO		  VARCHAR(30) -- ���� �۾��忡 ��ϵ� �۾� ���� ��ȣ
	
	-- �۾��� ���� ���� ���̺��� ������ ��������
	SELECT @LS_WORKER     = WORKER
	     , @LS_STATUS     = STATUS
		 , @LS_PERORDERNO = ORDERNO
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE;

	-- ���� �۾� ���� ��ȣ�� ���� ����� �۾� ���� ��ȣ�� �����Ѱ� Ȯ��
	IF (ISNULL(@LS_PERORDERNO, '') = @ORDERNO)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '������ �۾� ���ø� �����Ͽ����ϴ�.' +CHAR(13) + CHAR(10) +'�۾� ���� ������ �����մϴ�.';
		RETURN;
	END;

	-- �۾��� ��� ���� Ȯ��
	IF (ISNULL(@LS_WORKER, '') = '')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '���� �۾��忡 ���Ե� �۾��ڰ� �����ϴ�.' +CHAR(13) + CHAR(10) +'����ȸ �� �۾��ڸ� ����ϼ���.';
		RETURN;
	END;

	-- �۾��� ���� ���� Ȯ��
	IF (ISNULL(@LS_STATUS, 'S') = 'R')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾����� ���� �� �Դϴ�.' +CHAR(13) + CHAR(10) +'�񰡵� ��� �� �����ϼ���.';
		RETURN;
	END;

	-- 3. ���� �۾��忡 ���ο� �۾� ���� ��ȣ ���.
	DECLARE @LS_ITEMCODE VARCHAR(30)
	      , @LS_UNITCODE VARCHAR(10)
		  ;

	SELECT @LS_ITEMCODE = PP.ITEMCODE
	     , @LS_UNITCODE = PP.UNITCODE
	  FROM TB_ProductPlan PP WITH(NOLOCK)
	 WHERE PP.PLANTCODE = @PLANTCODE
	   AND PP.ORDERNO   = @ORDERNO;

	UPDATE TP_WorkcenterStatus -- �۾��� ���� ���� ���̺�
	   SET ORDERNO = @ORDERNO
	     , ITEMCODE = @LS_ITEMCODE
		 , UNITCODE = @LS_UNITCODE
		 , EDITDATE = @LS_NOWDATE
		 , EDITOR = @WORKERID
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE;

	-- �۾��庰 ����/�񰡵� �̷� ��Ȳ ���.
	DECLARE @LI_RSSEQ INT -- �۾��� �۾����ú� ����/�񰡵� �̷� SEQ
	;

	-- ���� �۾� ������ ���� ���� ���� ��� SEQ ã��
	SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ), 0)
	  FROM TP_WorkcenterStatusRec WITH(NOLOCK) -- �۾��庰 ����/�񰡵� �̷� ���̺�
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO = @ORDERNO
	;

	--���� ���� ���� ������Ʈ
	UPDATE TP_WorkcenterStatusRec
	   SET RSENDDATE = @LD_NOWDATE
	     , EDITDATE = @LD_NOWDATE
		 , EDITOR = @WORKERID
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO = @ORDERNO
	   AND RSSEQ = @LI_RSSEQ
	;

	-- ���� ������ �۾� ������ ���� �̷� SEQ ã��
	DECLARE @LI_ORDERSEQ INT;
	SELECT @LI_ORDERSEQ = ISNULL(MAX(RSSEQ), 0) + 1
	  FROM TP_WorkcenterStatusRec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO = @ORDERNO

	-- ���ο� �۾������� �񰡵� ���� ���
	INSERT INTO TP_WorkcenterStatusRec (PLANTCODE, WORKCENTERCODE, ORDERNO, RSSEQ, WORKER, ITEMCODE, STATUS, REMARK, RSSTARTDATE, MAKEDATE, MAKER)
	VALUES (@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @LI_ORDERSEQ, @WORKERID, @LS_ITEMCODE, 'S', 'A00', @LD_NOWDATE, @LD_NOWDATE, @WORKERID);


	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� ó��';
END
GO