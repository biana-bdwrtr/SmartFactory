SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.28
-- Description:	�����ڵ� ����
-- =============================================
--CREATE PROCEDURE [dbo].[13SP_STANDARD_I]
ALTER PROCEDURE [dbo].[13SP_STANDARD_I]
	@MAJORCODE		VARCHAR(10), -- ���ڵ�
	@MINORCODE		VARCHAR(20), -- ���ڵ�
	@CODENAME		VARCHAR(20), -- �ڵ��
	@DISPLAYNO		INT          -- ǥ�ü���
AS
BEGIN
	INSERT INTO TB_Standard(MAJORCODE, MINORCODE, CODENAME, DISPLAYNO)
	VALUES(@MAJORCODE, @MINORCODE, @CODENAME, @DISPLAYNO);

END
GO
