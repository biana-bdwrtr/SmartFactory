SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �̱��
-- Create date: 2022.07.08
-- Description:	���� ���� ��� - 5. ����/�񰡵� ���.
-- =============================================
CREATE PROCEDURE [dbo].[13PP_ActualOutput_I4]
	@PLANTCODE     		VARCHAR(10) -- ���� �ڵ�
  , @WORKCENTERCODE		VARCHAR(10) -- �۾���
  , @ITEMCODE      		VARCHAR(30) -- �۾��� ID
  , @ORDERNO       		VARCHAR(30) -- �۾� ���� ��ȣ
  , @STATUS        		VARCHAR(1)  -- ����

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

	-- 1. �۾��� ��ϵ� �۾��� ���� Ȯ���ϱ�
	DECLARE @LS_WORKERID VARCHAR(30);

	SELECT @LS_WORKERID = WORKER
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	;

	IF (@LS_NOWDATE IS NULL)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = @WORKCENTERCODE + '�� ���Ե� �۾��� ������ �����ϴ�.';
		RETURN;
	END;

	-- 2. �۾��� ���� ���� ���̺� (����/�񰡵�) ���
	UPDATE TP_WorkcenterStatus
	   SET STATUS = @STATUS
	     , EDITOR = @LS_WORKERID
		 , EDITDATE = @LD_NOWDATE
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	 ;

	 -- 3. �۾��庰 �۾� ���� �̷� ���̺� ������ ���� ��ȣ�� ���� SEQ ��������.
	 DECLARE @LI_RSSEQ INT;

	 SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ), 0)
	   FROM TP_WorkcenterStatusRec WITH(NOLOCK)
	  WHERE PLANTCODE      = @PLANTCODE
	    AND WORKCENTERCODE = @WORKCENTERCODE
		AND ORDERNO        = @ORDERNO
	;

	UPDATE TP_WorkcenterStatusRec
	   SET RSENDDATE = @LD_NOWDATE
	     , EDITDATE  = @LD_NOWDATE
		 , EDITOR    = @LS_WORKERID
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND RSSEQ = @LI_RSSEQ
	;

	-- ����Ǵ� ����/�񰡵��� ���� ���� �ð� INSERT
	INSERT INTO TP_WorkcenterStatusRec ( PLANTCODE,   WORKCENTERCODE, ORDERNO,  RSSEQ,         WORKER,       ITEMCODE,  STATUS, RSSTARTDATE,   REMARK,   MAKEDATE,     MAKER)
	                            VALUES (@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @LI_RSSEQ + 1, @LS_WORKERID, @ITEMCODE, @STATUS, @LD_NOWDATE,         ,  @LD_NOWDATE, @LS_WORKERID);
	
	-- �۾� ���ð� ���� ������ ��� �۾� ���� Ȯ�� ������ �۾� ������ ���� �Ͻø� UPDATE
	IF (@STATUS = 'R')
	BEGIN
		UPDATE TB_ProductPlan
		   SET FIRSTSTARTDATE = @LD_NOWDATE
		     , EDITDATE       = @LD_NOWDATE
			 , EDITOR         = @LS_WORKERID
		 WHERE PLANTCODE = @PLANTCODE
		   AND ORDERNO   = @ORDERNO
		   AND FIRSTSTARTDATE IS NULL
		;
	END;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� ó��';
END
GO