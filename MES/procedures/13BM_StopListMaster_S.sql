SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.30
-- Description:	�񰡵� �׸� ��ȸ
-- =============================================
ALTER PROCEDURE [dbo].[13BM_StopListMaster_S]
--CREATE PROCEDURE [dbo].[13BM_StopListMaster_S]
	@PLANTCODE		VARCHAR(10)		-- ����
  , @STOPCODE		VARCHAR(10)		-- �񰡵� �ڵ�
  , @STOPNAME		VARCHAR(20)		-- �񰡵� ��
  , @USEFLAG		VARCHAR(1)		-- ��뿩��

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	SELECT SLM.PLANTCODE                       AS   PLANTCODE	-- ����
         , SLM.STOPCODE	                       AS	STOPCODE	-- �񰡵� �ڵ�
         , SLM.STOPNAME	                       AS	STOPNAME	-- �񰡵� ��
         , SLM.REMARK	                       AS	REMARK		-- ���
         , SLM.USEFLAG	                       AS	USEFLAG		-- ��뿩��
         , DBO.FN_WORKERNAME(SLM.MAKER)   	   AS	MAKER   	-- ������
         , CONVERT(VARCHAR, SLM.MAKEDATE, 120) AS	MAKEDATE	-- ��������
         , DBO.FN_WORKERNAME(SLM.EDITOR)       AS	EDITOR   	-- ������
         , CONVERT(VARCHAR, SLM.EDITDATE, 120) AS	EDITDATE	-- ��������
	  FROM TB_StopListMaster SLM WITH(NOLOCK)
	 WHERE SLM.PLANTCODE LIKE ISNULL('%' + @PLANTCODE + '%', '')
	   AND SLM.STOPCODE  LIKE ISNULL('%' + @STOPCODE + '%', '')
	   AND SLM.STOPNAME  LIKE ISNULL('%' + @STOPNAME + '%', '')
	   AND SLM.USEFLAG   LIKE ISNULL('%' + @USEFLAG + '%', '');

END
GO
