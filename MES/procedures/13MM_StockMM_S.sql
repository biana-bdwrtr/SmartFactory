SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.04
-- Description:	���� ��� ��Ȳ ��ȸ.
-- =============================================
CREATE PROCEDURE [dbo].[13MM_StockMM_S]
    @PLANTCODE		VARCHAR(10) -- ���� �ڵ�
  , @ITEMCODE		VARCHAR(20) -- ǰ�� �ڵ�
  , @MATLOTNO		VARCHAR(30) -- LOT NO

  , @LANG			VARCHAR(10) = 'KO' 
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	SELECT STK.PLANTCODE                       AS PLANTCODE -- �����
		 , STK.ITEMCODE                        AS ITEMCODE  -- ǰ��
		 , ITM.ITEMNAME                        AS ITEMNAME  -- ǰ���
		 , STK.MATLOTNO                        AS MATLOTNO  -- LOTNO
		 , STK.WHCODE                          AS WHCODE    -- â��
		 , STK.STOCKQTY                        AS STOCKQTY  -- ������
		 , STK.UNITCODE                        AS UNITCODE  -- ����
		 , STK.CUSTCODE                        AS CUSTCODE  -- �ŷ�ó
		 , CSM.CUSTNAME                        AS CUSTNAME  -- �ŷ�ó ��
		 , STK.INDATE                          AS INDATE    -- �԰�����
		 , DBO.FN_WORKERNAME(STK.MAKER)        AS MAKER     -- ������
		 , CONVERT(VARCHAR, STK.MAKEDATE, 120) AS MAKEDATE  -- �����Ͻ�
	  FROM TB_StockMM STK LEFT JOIN TB_ItemMaster ITM
								 ON STK.PLANTCODE = ITM.PLANTCODE
								AND STK.ITEMCODE  = ITM.ITEMCODE
						  LEFT JOIN TB_CustMaster CSM
								 ON STK.PLANTCODE = CSM.PLANTCODE
								AND STK.CUSTCODE  = CSM.CUSTCODE
	 WHERE STK.PLANTCODE			 LIKE '%' + @PLANTCODE + '%'
	   AND STK.MATLOTNO				 LIKE '%' + @MATLOTNO  + '%'
	   AND ISNULL(STK.ITEMCODE, '')  LIKE '%' + @ITEMCODE  + '%'
	;
END
GO
