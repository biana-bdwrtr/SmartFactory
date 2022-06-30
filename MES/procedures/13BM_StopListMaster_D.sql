SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.30
-- Description:	�񰡵� �׸� ����
-- =============================================
--ALTER PROCEDURE [dbo].[13BM_StopListMaster_D]
CREATE PROCEDURE [dbo].[13BM_StopListMaster_D]
	@PLANTCODE		VARCHAR(10)		-- ����
  , @STOPCODE		VARCHAR(10)		-- �񰡵� �ڵ�

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	DELETE TB_StopListMaster
	 WHERE PLANTCODE = @PLANTCODE
	   AND STOPCODE  = @STOPCODE;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
	
END
GO
