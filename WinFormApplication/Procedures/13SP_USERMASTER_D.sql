SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.28
-- Description:	����� ����
-- =============================================
--CREATE PROCEDURE [dbo].[13SP_USERMASTER_D]
ALTER PROCEDURE [dbo].[13SP_USERMASTER_D]
	@USERID		VARCHAR(20)	-- ����� ���̵�

AS
BEGIN
	DELETE TB_USER
	 WHERE USERID = @USERID;

END
GO
