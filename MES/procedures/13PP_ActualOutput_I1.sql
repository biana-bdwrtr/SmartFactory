SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �̱��
-- Create date: 2022.07.07
-- Description:	���� ���� ��� - �۾��� ���.
-- =============================================
CREATE PROCEDURE [dbo].[13PP_ActualOutput_I1]
	@PLANTCODE			VARCHAR(10) -- ���� �ڵ�
  , @WORKCENTERCODE		VARCHAR(10) -- �۾���
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
	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23); -- yyyy-MM-dd

	-- 1. ��ϵ� �۾������� Ȯ��.
	IF (
		SELECT COUNT(*)
		  FROM TB_WorkerList WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND WORKERID  = @WORKERID
	   ) = 0
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = @WORKERID +'�� ��ϵ��� ���� �۾����Դϴ�.';
		RETURN;
	END;

	-- 2. �۾��� ���� ���̺� ���� ������ �۾��ڸ� ���.
	if (
		SELECT COUNT(*)
		  FROM TP_WorkcenterStatus WITH(NOLOCK)
		 WHERE WORKCENTERCODE = @WORKCENTERCODE
	)<> 0
	BEGIN
		UPDATE TP_WorkcenterStatus
		   SET WORKER   = @WORKERID
		     , EDITDATE = @LD_NOWDATE
			 , EDITOR   = @WORKERID
		 WHERE PLANTCODE      = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
		;
		/*
		-- https://docs.microsoft.com/ko-kr/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-ver16
		-- @@ROWCOUNT : ���� �������� �۾��� ������ ��� ������ ��� �ִ�.
		IF(@@ROWCOUNT = 0)
		BEGIN
			INSERT INTO TP_WorkcenterStatus (PLANTCODE, WORKCENTERCODE, WORKER, STATUS, MAKEDATE, MAKER)
			VALUES (@PLANTCODE, @WORKCENTERCODE, @WORKERID, 'S', @LD_NOWDATE, @WORKERID)
		END;
		*/
	END
	ELSE
	BEGIN
		INSERT INTO TP_WorkcenterStatus (PLANTCODE, WORKCENTERCODE, WORKER, STATUS, MAKEDATE, MAKER)
		VALUES (@PLANTCODE, @WORKCENTERCODE, @WORKERID, 'S', @LD_NOWDATE, @WORKERID)
	END;


	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� ó��';
END
GO
