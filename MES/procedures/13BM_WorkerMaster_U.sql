SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.30
-- Description:	�۾��� ���� ����
-- =============================================
CREATE PROCEDURE [dbo].[13BM_WorkerMaster_U]
--ALTER PROCEDURE [dbo].[13BM_WorkerMaster_U]
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
  , @EDITOR				VARCHAR(20) -- ������

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1)   OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT

AS
BEGIN

	UPDATE TB_WorkerList
	   SET WORKERNAME   = @WORKERNAME	
         , BANCODE  	= @BANCODE  	
         , GRPID     	= @GRPID     	
         , DEPTCODE  	= @DEPTCODE  	
         , PHONENO   	= @PHONENO   	
         , INDATE    	= @INDATE    	
         , OUTDATE   	= @OUTDATE   	
         , USEFLAG   	= @USEFLAG   	
         , EDITOR		= GETDATE()		
	 WHERE PLANTCODE = @PLANTCODE
       AND WORKERID  = @WORKERID;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
END
GO
