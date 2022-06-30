SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.30
-- Description:	�۾��� ���� ����
-- =============================================
--CREATE PROCEDURE [dbo].[13BM_WorkerMaster_I]
ALTER PROCEDURE [dbo].[13BM_WorkerMaster_I]
	@PLANTCODE 			VARCHAR(10) -- ����
  , @WORKERID  			VARCHAR(20) -- �۾��� ID
  , @WORKERNAME			VARCHAR(30) -- �۾��� ��
  , @BANCODE  			VARCHAR(10) -- �۾���
  , @GRPID     			VARCHAR(20) -- �׷�
  , @DEPTCODE  			VARCHAR(10) -- �μ��ڵ�
  , @PHONENO   			VARCHAR(50) -- ����ó
  , @INDATE    			VARCHAR(10) -- �Ի���
  , @OUTDATE   			VARCHAR(10) -- �����
  , @USEFLAG   			VARCHAR(1) -- ��뿩��
  , @MAKER				VARCHAR(20) -- ������

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1)   OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT

AS
BEGIN
	-- PK Validation check
	DECLARE @CNT INT = 0; -- ����� ������ ���� ����

	-- 1. ���� ���� ������ ���ϴ� ����.
	BEGIN -- {
		IF (SELECT COUNT(*)
		      FROM TB_WorkerList
		     WHERE PLANTCODE = @PLANTCODE
		       AND WORKERID  = @WORKERID) > 0
		BEGIN
			SET @RS_CODE = 'E';
			SET @RS_MSG  = '�̹� ��ϵ� ������Դϴ�.';
			RETURN;
		END;
	END; -- }

	-- 2. ������ ���� ������ ���ϴ� ���
	SELECT @CNT = COUNT(*)
	  FROM TB_WorkerList
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKERID;
	
	IF (@CNT > 0)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '�̹� ��ϵ� ������Դϴ�.';
		RETURN;
	END;
	 

	INSERT INTO TB_WorkerList (PLANTCODE, WORKERID, WORKERNAME, BANCODE, GRPID, DEPTCODE, PHONENO, INDATE, OUTDATE, USEFLAG, MAKER, MAKEDATE) 
	VALUES (@PLANTCODE, @WORKERID, @WORKERNAME, @BANCODE, @GRPID, @DEPTCODE, @PHONENO, @INDATE, @OUTDATE, @USEFLAG, @MAKER, GETDATE());

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
END
GO
