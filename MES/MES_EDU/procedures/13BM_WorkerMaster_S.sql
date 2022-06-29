SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.29
-- Description:	�۾��� ��ȸ
-- =============================================
CREATE PROCEDURE [dbo].[13BM_WorkerMaster_S]
	@PLANTCODE		VARCHAR(20),			-- ����
	@BANCODE		VARCHAR(20),			-- ����� ID
	@WORKERID		VARCHAR(10),			-- �۾���
	@WORKDERNAME	VARCHAR(30),			-- �۾���
	@USEFLAG		VARCHAR(10),			-- ��뿩��

	@LANG			VARCHAR(10) = 'KO',		-- �����
	@RS_CODE		VARCHAR(1)	 OUTPUT,	-- �������� �ڵ�
	@RS_MSG			VARCHAR(100) OUTPUT		-- ���ν������� ������ �޽���

AS
BEGIN


	SELECT WRK.PLANTCODE                 AS PLANTCODE  -- ����
	     , WRK.WORKERID                  AS WORKERID   -- �۾���ID
		 , WRK.WORKERNAME                AS WORKERNAME -- �۾��� ��
		 , WRK.BANCODE                   AS BANCODE    -- �۾���
		 , WRK.GRPID                     AS GRPID      -- �׷�
		 , WRK.DEPTCODE                  AS DEPTCODE   -- �μ�
		 , WRK.PHONENO                   AS PHONENO    -- ����ó
		 , WRK.INDATE                    AS INDATE     -- �Ի���
		 , WRK.OUTDATE                   AS OUTDATE    -- �����
		 , WRK. USEFLAG                  AS USEFLAG    -- ��뿩��
		 , DBO.FN_WORKERNAME(WRK.MAKER)  AS MAKER      -- ������
		 , WRK.MAKEDATE                  AS MAKEDATE   -- �����Ͻ�
		 , DBO.FN_WORKERNAME(WRK.EDITOR) AS EDITOR     -- ������
		 , WRK.EDITDATE                  AS EDITDATE   -- �����Ͻ�
	  FROM TB_WorkerList WRK
	 WHERE ISNULL(WRK.PLANTCODE, '')  LIKE '%'+ISNULL(@PLANTCODE, '')+'%'
	   AND ISNULL(WRK.BANCODE, '')    LIKE '%'+ISNULL(@BANCODE, '')+'%'
	   AND ISNULL(WRK.WORKERID, '')   LIKE '%'+ISNULL(@WORKERID, '')+'%'
	   AND ISNULL(WRK.WORKERNAME, '') LIKE '%'+ISNULL(@WORKDERNAME, '')+'%'
	   AND ISNULL(WRK.BANCODE, '')    LIKE '%'+ISNULL(@BANCODE, '')+'%'

END
GO
