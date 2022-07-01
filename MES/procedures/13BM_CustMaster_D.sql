SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.01
-- Description:	�ŷ�ó ����
-- =============================================
CREATE PROCEDURE [dbo].[13BM_CustMaster_D]
	@PLANTCODE		VARCHAR(10)  -- ����
  , @CUSTCODE 		VARCHAR(10)  -- �ŷ�ó �ڵ�

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	DELETE TB_CustMaster
	 WHERE PLANTCODE = @PLANTCODE  -- ����
	   AND CUSTCODE  = @CUSTCODE  -- �ŷ�ó �ڵ�
	   ;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
END
GO
