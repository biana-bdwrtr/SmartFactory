SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �̱��
-- Create date: 2022.07.08
-- Description:	���� ���� ��� - 7. ���� ���� ���.
-- =============================================
CREATE PROCEDURE [dbo].[13PP_ActualOutput_I5]
	@PLANTCODE     		VARCHAR(10) -- ���� �ڵ�
  , @WORKCENTERCODE		VARCHAR(10) -- �۾���
  , @ITEMCODE      		VARCHAR(30) -- �۾��� ID
  , @ORDERNO       		VARCHAR(30) -- ���� ǰ��
  , @UNITCODE      		VARCHAR(10) -- ���� ����
  , @PRODQTY       		FLOAT       -- �Է� ��ǰ ����
  , @BADQTY        		FLOAT       -- �Է� �ҷ� ����
  , @MATLOTNO      		VARCHAR(30) -- ������ LOT NO

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

	DECLARE @LS_WORKERID VARCHAR(30) -- �۾��� ID
	      , @LS_ORDERNO   VARCHAR(30) -- ��ϵ� �۾� ���� ��ȣ
		  ;

	SELECT @LS_WORKERID = WORKER
	     , @LS_ORDERNO   = ORDERNO
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	;

	-- 1. �۾��忡 �۾��� ��� ���� Ȯ��
	IF (ISNULL(@LS_WORKERID, '') = '')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾��忡 ��ϵ� �۾��ڰ� �����ϴ�.';
		RETURN;
	END;

	-- 2. �۾��忡 �۾� ���� ��ȣ ��� ���� Ȯ��
	IF (ISNULL(@LS_ORDERNO, '') = '')
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾��忡 ��ϵ� �۾����ð� �����ϴ�.';
		RETURN;
	END;

	-- 3. �۾��忡 ��ϵ� �۾� ���� ��ȣ�� ������ �۾� ���� ��ȣ�� �´� �� Ȯ��
	IF (@LS_ORDERNO <> @ORDERNO)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�۾� ���� ������ ����Ǿ����ϴ�. ����ȸ �� �����ϼ���.';
		RETURN;
	END;

	-- BOM���� ������ ������ŭ ������ ��� �����ִ��� Ȯ��.
	DECLARE @LF_TOTALQTY FLOAT; -- = ��ǰ ���� + �ҷ� ����
	SET @LF_TOTALQTY = @PRODQTY + @BADQTY;

	-- ���Ե� ������ LOT�� ���� �޾ƿ���
	DECLARE @LS_CITEMCODE VARCHAR(30) -- ������ ǰ�� �ڵ�
	      , @LF_STOCKQTY  FLOAT       -- ������ ��� ����
		  , @LS_CUNITCODE VARCHAR(10) -- ������ ǰ�� ���� �ڵ�
	;

	SELECT @LS_CITEMCODE = ITEMCODE
	     , @LF_STOCKQTY  = STOCKQTY
		 , @LS_CUNITCODE = UNITCODE
	  FROM TB_StockHALB WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO = @MATLOTNO
	   AND WORKCENTERCODE = @WORKCENTERCODE
	;

	-- BOM �����Ϳ��� ���� ���� ����ϱ� �� BOM ���� ǰ�� ���� Ȯ��.
	DECLARE @LF_FINALQTY FLOAT -- �� �����Ǿ�� �� ������ ����
	      , @LF_PRODQTY  FLOAT; -- ��ǰ ������ ���ؼ��� ������ ������ ����

	SELECT @LF_FINALQTY = ISNULL(COMPONENTQTY, 1) * @LF_TOTALQTY  -- ��ǰ + �ҷ� ������ ���� �� ������ ������ ����
	     , @LF_PRODQTY  = ISNULL(COMPONENTQTY, 1) * @PRODQTY      -- ��ǰ ������ ���� ������ ������ ����
	  FROM TB_BomMaster WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND COMPONENT = @LS_CITEMCODE
	   AND ITEMCODE  = @ITEMCODE
	;

	IF (ISNULL(@LF_FINALQTY, 0) = 0)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = 'BOM ������ ����Ǿ��ų�, ���� �����Ͱ� ����Ǿ����ϴ�. ����ȸ �� �����ϼ���. �����ڿ��� �����ϼ���.';
		RETURN;
	END;

	-- ������ LOT�� ���� 
	IF (@LF_STOCKQTY < @LF_FINALQTY)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '���Ե� ������ LOT�� �ܷ��� �����մϴ�.';
		RETURN;
	END;


	-- ���� ���� ��� ���� --
	-- 1. �۾� ���� ������ ���� ���� ���
	UPDATE TB_ProductPlan
	   SET PRODQTY = ISNULL(@PRODQTY, 0) + @PRODQTY
	     , BADQTY  = ISNULL(@BADQTY, 0) + @BADQTY
		 , EDITOR  = @LS_WORKERID
		 , EDITDATE = @LD_NOWDATE
	 WHERE PLANTCODE = @PLANTCODE
	   AND ORDERNO = @ORDERNO
   ;

   -- 2. ���� �񰡵� �̷¿� ���� ���� ���
   UPDATE TP_WorkcenterStatusRec
      SET PRODQTY        = ISNULL(PRODQTY, 0) + @PRODQTY
	    , BADQTY         = ISNULL(BADQTY, 0) + @BADQTY
		, EDITOR         = @LS_WORKERID
		, EDITDATE       = @LD_NOWDATE
	WHERE PLANTCODE      = @PLANTCODE
	  AND WORKCENTERCODE = @WORKCENTERCODE
	  AND ORDERNO = @ORDERNO
	  AND RSENDDATE IS NULL
	;


	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� ó��';
END
GO