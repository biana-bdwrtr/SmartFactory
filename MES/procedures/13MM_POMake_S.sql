SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.04
-- Description:	�������� ���� �� �԰� ���� ��ȸ.
-- =============================================
ALTER PROCEDURE [DBO].[13MM_POMake_S]
     @PLANTCODE			VARCHAR(10) -- ���� �ڵ�
   , @ITEMCODE			VARCHAR(10) -- ǰ�� �ڵ�
   , @CUSTCODE			VARCHAR(10) -- �ŷ�ó �ڵ�
   , @STARTDATE			VARCHAR(10) -- ���� ����
   , @ENDDATE			VARCHAR(10) -- ���� ����
   , @PONO  			VARCHAR(10) -- ���� ��ȣ

   , @LANG				VARCHAR(10) = 'KO'
   , @RS_CODE			VARCHAR(1) OUTPUT
   , @RS_MSG			VARCHAR(100) OUTPUT
AS
BEGIN
	SELECT POM.PLANTCODE                       AS PLANTCODE	  -- ���� �ڵ�
	     , POM.PONO                            AS PONO 		  -- ���� ��ȣ
	     , POM.POSEQ                           AS POSEQ		  -- ���� ������
	     , POM.PODATE                          AS PODATE	  -- ���� ����
	     , POM.ITEMCODE                        AS ITEMCODE	  -- ���� ǰ��
	     , POM.POQTY                           AS POQTY 	  -- ���� ����
	     , POM.UNITCODE                        AS UNITCODE	  -- ����
	     , POM.CUSTCODE                        AS CUSTCODE	  -- ���� ��ü
	     , CASE WHEN ISNULL(POM.INFLAG, 'N') = 'Y' THEN 1
		        ELSE 0 END                     AS CHK		  -- �԰� ���
	     , POM.INQTY                           AS INQTY		  -- �԰� ����
	     , POM.LOTNO                           AS LOTNO		  -- LOT NO
	     , POM.INDATE                          AS INDATE 	  -- �԰� ����
	     , POM.INWORKER                        AS INWORKER	  -- �԰���
	     , DBO.FN_WORKERNAME(POM.MAKER)        AS MAKER
	     , CONVERT(VARCHAR, POM.MAKEDATE, 120) AS MAKEDATE	
	     , DBO.FN_WORKERNAME(POM.EDITOR)       AS EDITOR 	
	     , CONVERT(VARCHAR, POM.EDITDATE, 120) AS EDITDATE	
	  FROM TB_POMake POM WITH(NOLOCK)
	 WHERE POM.PLANTCODE             LIKE  '%'+ @PLANTCODE +'%'
	   AND POM.PONO      LIKE  '%'+ @PONO +'%'
	   AND POM.PODATE BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(POM.ITEMCODE, '')  LIKE  '%'+ @ITEMCODE +'%'
	   AND ISNULL(POM.CUSTCODE, '')  LIKE  '%'+ @CUSTCODE +'%'
	;

	SET @RS_CODE = 'S';
	SET @RS_MSG = '���� ó��';

END
GO
