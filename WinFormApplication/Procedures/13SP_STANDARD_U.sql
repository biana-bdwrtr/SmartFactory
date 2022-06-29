SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.28
-- Description:	�����ڵ� ����
-- =============================================
CREATE PROCEDURE [dbo].[13SP_STANDARD_U]
--ALTER PROCEDURE [dbo].[13SP_STANDARD_U]
	@MAJORCODE		VARCHAR(10), -- ���ڵ�
	@MINORCODE		VARCHAR(20), -- ���ڵ�
	@CODENAME		VARCHAR(20), -- �ڵ��
	@DISPLAYNO		INT          -- ǥ�ü���
AS
BEGIN
	UPDATE TB_Standard
	   SET CODENAME = @CODENAME
	     , DISPLAYNO = @DISPLAYNO
	 WHERE MAJORCODE = @MAJORCODE
	   AND MINORCODE = @MINORCODE;

END
GO
