USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[00PP_ActureOutput_I6]    Script Date: 2022-07-11 ���� 9:21:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022-07-11
-- Description:	������� ��� - 7. �۾����� ����.
-- =============================================
CREATE PROCEDURE [dbo].[13PP_ActualOutput_I6]
	@PLANTCODE        VARCHAR(10),  -- ����.
	@WORKCENTERCODE   VARCHAR(10),  -- �۾���
	@ORDERNO		  VARCHAR(30),  -- �۾����� ��ȣ.

	@LANG      VARCHAR(10)  = 'KO',
	@RS_CODE   VARCHAR(1)   OUTPUT,
	@RS_MSG	   VARCHAR(100) OUTPUT


AS
BEGIN 
		-- ���� �ð� ���� ���� ����
	DECLARE @LD_NOWDATE  DATETIME,
	        @LS_NOWDATE  VARCHAR(10);
		SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23); -- yyyyy-MM-dd

	-- �۾����� ���� ������ Ȯ��.
	DECLARE @LS_MATLOTNO  VARCHAR(30) -- ������ LOTNO
	       ,@LS_WORKER    VARCHAR(30) -- �۾��� 
		   ,@LS_STATUS    VARCHAR(1)  -- ���� �۾����� ���� (����/�񰡵�)


	SELECT @LS_WORKER     = WORKER
		  ,@LS_STATUS     = STATUS
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE;

	IF (@LS_STATUS = 'R')
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '���� �۾����� ���� ���Դϴ�.';
		RETURN;
	END;


	-- ���� �� ������ LOT �� �ִ��� Ȯ��.
	SELECT @LS_MATLOTNO = LOTNO
	  FROM TB_StockHALB WITH(NOLOCK)
	 WHERE PLANTCODE     = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE;

     IF (ISNULL(@LS_MATLOTNO,'') <> '')
	 BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '���� �� ������ ������ �ֽ��ϴ�.';
		RETURN;
	 END


	 -- �۾����� ���� ���� ���
	 UPDATE TB_ProductPlan
	    SET ORDERCLOSEFLAG = 'Y'
		   ,ORDERCLOSEDATE = @LD_NOWDATE
		   ,EDITDATE       = @LD_NOWDATE
		   ,EDITOR         = @LS_WORKER
	 WHERE PLANTCODE       = @PLANTCODE
	   AND ORDERNO         = @ORDERNO;


	 -- �۾��� ���� ���� ���� ���̺� ���.
	 UPDATE TP_WorkcenterStatus
	    SET ORDERNO       = NULL
		   ,ITEMCODE      = NULL
		   ,UNITCODE      = NULL
		   ,REMARK        = NULL
		   ,EDITDATE      = @LD_NOWDATE
		   ,EDITOR        = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE



    -- �۾��� ���� �̷� ���̺� ���� �ð� ������Ʈ
	UPDATE TP_WorkcenterStatusRec
	   SET RSENDDATE      = @LD_NOWDATE
	      ,EDITDATE       = @LS_NOWDATE
		  ,EDITOR         = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO        = @ORDERNO
	   AND RSENDDATE IS NULL

	SET @RS_CODE = 'S';
END
