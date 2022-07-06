SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[13PP_StockPP_S]
  @PLANTCODE		  VARCHAR(30) -- ����
, @LOTNO			  VARCHAR(30) -- LOTNO
, @ITEMCODE			  VARCHAR(30) -- ǰ��
, @ITEMNAME			  VARCHAR(30) -- ǰ���
, @ITEMTYPE			  VARCHAR(30) -- ǰ�� ����

, @LANG				  VARCHAR(10) = 'KO'
, @RS_CODE			  VARCHAR(1) OUTPUT
, @RS_MSG			  VARCHAR(100) OUTPUT


AS
BEGIN
	SELECT 0                                      AS CHK           	 -- ������ ��� ���� ����ϴ� üũ�ڽ�
	     , SPP.PLANTCODE     					  AS PLANTCODE     	 -- ���� �ڵ�
	     , SPP.ITEMCODE      					  AS ITEMCODE      	 -- ǰ�� �ڵ�
	     , ITM.ITEMNAME      					  AS ITEMNAME      	 -- ǰ�� �� 
	     , ITM.ITEMTYPE      					  AS ITEMTYPE      	 -- ǰ�� ����
	     , SPP.LOTNO         					  AS LOTNO         	 -- LOT NO
	     , SPP.WHCODE        					  AS WHCODE        	 -- â�� �ڵ�
	     , SPP.STORAGELOCCODE					  AS STORAGELOCCODE	 -- ���� ��ġ
	     , SPP.STOCKQTY      					  AS STOCKQTY      	 -- ��� ����
	     , SPP.NOWQTY        					  AS NOWQTY        	 -- �� ���
	     , SPP.UNITCODE      					  AS UNITCODE      	 -- ����
	     , SPP.INDATE        					  AS INDATE        	 -- �԰� ����
	     , DBO.FN_WORKERNAME(SPP.MAKER)			  AS MAKER         	 -- �����
	     , CONVERT(VARCHAR, SPP.MAKEDATE, 120)	  AS MAKEDATE      	 -- ��� �Ͻ�
	     , DBO.FN_WORKERNAME(SPP.EDITOR)		  AS EDITOR        	 -- ������
	     , CONVERT(VARCHAR, SPP.EDITDATE, 120)    AS EDITDATE      	 -- ���� �Ͻ�
	  FROM TB_StockPP SPP WITH(NOLOCK) LEFT JOIN TB_ItemMaster ITM WITH(NOLOCK)
	                                          ON SPP.PLANTCODE = ITM.PLANTCODE
											 AND SPP.ITEMCODE  = ITM.ITEMCODE
	 WHERE SPP.PLANTCODE LIKE '%' + @PLANTCODE
	   AND SPP.LOTNO     LIKE '%' + @LOTNO    + '%'
	   AND ISNULL(ITM.ITEMTYPE, '')  LIKE '%' + @ITEMTYPE
	   AND ISNULL(ITM.ITEMNAME, '')  LIKE '%' + @ITEMNAME + '%'
	   AND ISNULL(SPP.ITEMCODE, '')  LIKE '%' + @ITEMCODE + '%'
	;
	
	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';
END
GO
