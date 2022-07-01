SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.01
-- Description:	�ŷ�ó ����
-- =============================================
ALTER PROCEDURE [dbo].[13BM_CustMaster_U]
	@PLANTCODE		VARCHAR(10)  -- ����
  , @CUSTCODE 		VARCHAR(10)  -- �ŷ�ó �ڵ�
  , @CUSTTYPE 		VARCHAR(100) -- �ŷ�ó ����
  , @CUSTNAME 		VARCHAR(100) -- �ŷ�ó ��
  , @ADDRESS		VARCHAR(100) -- �ּ�
  , @PHONE			VARCHAR(100) -- ����ó
  , @USEFLAG 		VARCHAR(1)   -- ��뿩��
  , @EDITOR			VARCHAR(20)  -- ������

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT


AS
BEGIN
	UPDATE TB_CustMaster
	   SET CUSTTYPE 	= @CUSTTYPE	  -- �ŷ�ó ����
         , CUSTNAME 	= @CUSTNAME	  -- �ŷ�ó ��
         , ADDRESS		= @ADDRESS	  -- �ּ�
         , PHONE		= @PHONE	  -- ����ó
         , USEFLAG 		= @USEFLAG	  -- ��뿩��
         , EDITOR		= @EDITOR	  -- ������
		 , EDITDATE		= GETDATE()	  -- ��������
	 WHERE PLANTCODE	= @PLANTCODE  -- ����
       AND CUSTCODE 	= @CUSTCODE	  -- �ŷ�ó �ڵ�
         ; 
	
	SET @RS_CODE = 'S';
	SET @RS_MSG  = '�����۵�';

END
GO
