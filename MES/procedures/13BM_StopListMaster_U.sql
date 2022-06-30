SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.30
-- Description:	�񰡵� �׸� ����
-- =============================================
ALTER PROCEDURE [dbo].[13BM_StopListMaster_U]
--CREATE PROCEDURE [dbo].[13BM_StopListMaster_U]
	@PLANTCODE		VARCHAR(10)		-- ����
  , @STOPCODE		VARCHAR(10)		-- �񰡵� �ڵ�
  , @STOPNAME		VARCHAR(20)		-- �񰡵� ��
  , @REMARK			VARCHAR(255)    -- ���
  , @USEFLAG		VARCHAR(1)		-- ��뿩��
  , @EDITOR			VARCHAR(20)     -- ������

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	UPDATE TB_StopListMaster
	   SET STOPNAME  = @STOPNAME
		 , REMARK    = @REMARK
		 , USEFLAG   = @USEFLAG
		 , EDITOR    = @EDITOR
		 , EDITDATE  = GETDATE()
	 WHERE PLANTCODE = @PLANTCODE
	   AND STOPCODE  = @STOPCODE;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
	
END
GO
