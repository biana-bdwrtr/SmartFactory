SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.28
-- Description:	����� �Է�
-- =============================================
CREATE PROCEDURE [dbo].[13SP_USERMASTER_I]
	@USERID		VARCHAR(20), -- ����� ID
	@USERNAME	VARCHAR(20), -- ����� ��
	@PW			VARCHAR(20), -- ����� ��й�ȣ
	@DEPTCODE	VARCHAR(20), -- �μ��ڵ�
	@MAKER		VARCHAR(20)  -- ������

AS
BEGIN
	INSERT INTO TB_USER(USERID, USERNAME, PW, DEPTCODE, MAKER, MAKEDATE)
	VALUES (@USERID, @USERNAME, @PW, @DEPTCODE, @MAKER, GETDATE());

END
GO
