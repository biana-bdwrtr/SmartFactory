SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.07.06
-- Description:	���� ���� ����� ���� �۾��� ��ȸ.
-- =============================================
ALTER PROCEDURE [DBO].[13PP_ActualOutput_S] 
  @PLANTCODE                 VARCHAR(10) -- ����
, @WORKCENTERCODE            VARCHAR(10) -- �۾���

, @LANG                      VARCHAR(10) = 'KO'
, @RS_CODE                   VARCHAR(1) OUTPUT
, @RS_MSG                    VARCHAR(100) OUTPUT


AS
BEGIN
	SELECT WCM.PLANTCODE                       AS PLANTCODE      -- ����
	     , WCM.WORKCENTERCODE                  AS WORKCENTERCODE -- �۾��� �ڵ�
	     , WCM.WORKCENTERNAME                  AS WORKCENTERNAME -- �۾��� ��
		 , WCS.ORDERNO                         AS ORDERNO        -- �۾����� ���� �۾� ���� ���� ��ȣ
		 , WCS.ITEMCODE                        AS ITEMCODE       -- �۾����� ���� �۾� ���� ǰ�� �ڵ�
		 , ITM.ITEMNAME                        AS ITEMNAME       -- �۾����� ���� �۾� ���� ǰ�� ��
		 , PP.PLANQTY                          AS ORDERQTY       -- �۾����� ���� �۾� ���� ����
		 , PP.PRODQTY                          AS PRODQTY        -- ��ǰ ����
		 , PP.BADQTY                           AS BADQTY         -- �ҷ� ����
		 , PP.UNITCODE                         AS UNITCODE       -- ����
		 , WCS.STATUS                          AS WORKSTATUSCODE -- ���� ����(����/�񰡵�)
		 , CASE WHEN WCS.STATUS = 'R' /* RUN */ THEN '����' 
		        ELSE '�񰡵�' END              AS WORKSTATUS
		 , STH.LOTNO                           AS MATLOTNO       -- �۾��� ���� LOT NO
		 , STH.STOCKQTY                        AS COMPONENTQTY   -- ���� LOT NO �ܷ�
		 , WCS.WORKER                          AS WORKER         -- �۾��� ID
		 , DBO.FN_WORKERNAME(WCS.WORKER)       AS WORKERNAME     -- �۾��� ��
		 , PP.FIRSTSTARTDATE                   AS STARTDATE      -- ���� ���� �Ͻ�
		 , PP.ORDERCLOSEDATE                   AS ENDDATE        -- ���� ���� �Ͻ�
	  FROM TB_WorkCenterMaster WCM WITH(NOLOCK) LEFT JOIN TP_WorkcenterStatus WCS WITH(NOLOCK) -- �۾��� ���� ���� ���̺�
	                                                   ON WCM.PLANTCODE      = WCS.PLANTCODE
													  AND WCM.WORKCENTERCODE = WCS.WORKCENTERCODE
												LEFT JOIN TB_ItemMaster ITM WITH(NOLOCK)
												       ON WCS.PLANTCODE = ITM.PLANTCODE
													  AND WCS.ITEMCODE  = ITM.ITEMCODE
												LEFT JOIN TB_ProductPlan PP WITH(NOLOCK)
												       ON WCS.PLANTCODE = PP.PLANTCODE
													  AND WCS.ORDERNO   = PP.ORDERNO
												LEFT JOIN TB_StockHALB STH WITH(NOLOCK) -- ��� ��� ���̺�(�۾��庰 ���� LOT ���� ���̺�)
												       ON WCM.PLANTCODE        = STH.PLANTCODE
													  AND WCM.WORKCENTERCODE   = STH.WORKCENTERCODE
	 WHERE WCM.PLANTCODE      LIKE '%' +      @PLANTCODE
	   AND WCM.WORKCENTERCODE LIKE '%' + @WORKCENTERCODE
	   AND ISNULL(WCM.USEFLAG, 'Y') <> 'N'
	;

	SET @RS_CODE = 'S';
	SET @RS_MSG = '���� �۵�';
END
GO
