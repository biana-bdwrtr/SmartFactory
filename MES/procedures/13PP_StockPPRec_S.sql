SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.06
-- Description:	���� â�� ����� �̷� ��ȸ
-- =============================================
ALTER PROCEDURE [dbo].[13PP_StockPPRec_S]
  @PLANTCODE	 VARCHAR(10) -- ���� �ڵ�
, @LOTNO 		 VARCHAR(30) -- LOT NO
, @ITEMCODE		 VARCHAR(30) -- ǰ��
, @STARTDATE  	 VARCHAR(10) -- ���� ���� ����
, @ENDDATE 		 VARCHAR(10) -- ���� ���� ����

, @LANG			 VARCHAR(10) = 'KO'
, @RS_CODE		 VARCHAR(1) OUTPUT
, @RS_MSG		 VARCHAR(100) OUTPUT
AS
BEGIN
	SELECT SPR.PLANTCODE						   AS PLANTCODE	-- ���� �ڵ�
	     , SPR.LOTNO 						       AS LOTNO 	-- LOTNO
	     , SPR.ITEMCODE 						   AS ITEMCODE 	-- ǰ��
	     , ITM.ITEMNAME 						   AS ITEMNAME 	-- ǰ��
	     , SPR.RECDATE   						   AS INOUTDATE	-- ���������
	     , SPR.WHCODE   						   AS WHCODE   	-- â��
	     , SPR.INOUTCODE						   AS INOUTCODE	-- ��������
	     , SPR.INOUTFLAG						   AS INOUTFLAG	-- ���� ����
	     , SPR.INOUTQTY 						   AS INOUTQTY 	-- ���� ����
	     , SPR.UNITCODE 						   AS BASEUNIT 	-- ����
	     , DBO.FN_WORKERNAME(SPR.MAKER)			   AS MAKER    	-- �����
	     , CONVERT(VARCHAR, SPR.MAKEDATE, 120)	   AS MAKEDATE 	-- ��� �Ͻ�
	  FROM TB_StockPPrec SPR WITH(NOLOCK) LEFT JOIN TB_ItemMaster ITM
	                                             ON SPR.PLANTCODE = ITM.PLANTCODE
												AND SPR.ITEMCODE  = ITM.ITEMCODE
	 WHERE SPR.PLANTCODE            LIKE '%' + @PLANTCODE
	   AND ISNULL(SPR.LOTNO, '')    LIKE '%' + @LOTNO + '%'
	   AND ISNULL(SPR.ITEMCODE, '') LIKE '%' + @ITEMCODE
	   AND SPR.RECDATE BETWEEN @STARTDATE AND @ENDDATE
	;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '���� �۵�';



END
GO
