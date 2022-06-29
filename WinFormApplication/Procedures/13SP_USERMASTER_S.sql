SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.27
-- Description:	����� ���� ��ȸ
-- =============================================
--CREATE PROCEDURE [DBO].[13SP_USERMASTER_S]
ALTER PROCEDURE [DBO].[13SP_USERMASTER_S]
 -- Parameter ���� �κ�
 @USERID		VARCHAR(20), -- ����� ID
 @USERNAME		VARCHAR(30), -- ����� ��
 @DEPTCODE		VARCHAR(10)  -- �μ� �ڵ�
AS
BEGIN
	SELECT USERID   AS USERID   -- ����� id
	     , USERNAME AS USERNAME -- ����� ��
		 , PW       AS PW       -- ��й�ȣ
		 , DEPTCODE AS DEPTCODE -- �μ�
		 , MAKEDATE AS MAKEDATE -- �����Ͻ�
		 , MAKER    AS MAKER    -- ������
		 , EDITDATE AS EDITDATE -- �����Ͻ�
		 , EDITOR   AS EDITOR   -- ������
	  FROM TB_USER WITH(NOLOCK) -- Ʈ����� ���� ����.
	 WHERE USERID LIKE '%' + @USERID + '%'
	   AND USERNAME LIKE '%' + @USERNAME + '%'
	   AND ISNULL(DEPTCODE, '') LIKE '%' + @DEPTCODE;

END
GO
