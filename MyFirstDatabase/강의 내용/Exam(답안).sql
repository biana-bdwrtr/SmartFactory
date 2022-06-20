-- 1�� --
SELECT *
  FROM TB_StockMMrec
 WHERE MATLOTNO NOT IN (SELECT MATLOTNO
                          FROM TB_StockMM);

-- 2�� --
-- �ܰ� 1 --
-- ���� ��� ���̺��� STOCKQTY�� 5000���� ���� MATLOTNO
SELECT MATLOTNO
  FROM TB_StockMM
 WHERE STOCKQTY < 5000

-- �ܰ� 2 --
-- 1�ܰ��� ������ ��������̷� ���̺��� ITEMCODE ã�Ƴ���
SELECT ITEMCODE
  FROM TB_StockMMrec
 WHERE MATLOTNO IN (SELECT MATLOTNO
					  FROM TB_StockMM
					 WHERE STOCKQTY < 5000);

-- �ܰ� 3 --
-- 2�ܰ迡�� ���� ITEMCODE ������� ���� ǰ�񸶽��� ���̺��� ǰ�� ���� ��ȸ.
SELECT ITEMCODE
     , ITEMNAME
	 , MAXSTOCK
	 , BASEUNIT
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO IN (SELECT MATLOTNO
										  FROM TB_StockMM
										 WHERE STOCKQTY < 5000)
					);

-- 3�� --
SELECT *
  FROM (
		SELECT INOUTDATE
			 , WHCODE
			 , COUNT(*) AS CNT
		  FROM TB_StockMMrec
		 WHERE INOUTQTY > 1000
		   AND INOUTFLAG = 'I'
		 GROUP BY INOUTDATE, WHCODE
		) A
 WHERE A.CNT >= 2
;


-- 4�� --
-- 1�ܰ�
-- 11�Ϻ��� 13�ϱ����� ���� �� ���� �ݾ� ����.
SELECT A.CUST_ID
     , SUM(A.AMOUNT * B.PRICE) AS FRUIT_PRICE
  FROM TB_SaleList A LEFT JOIN TB_FRUIT B
                            ON A.FRUIT_NAME = B.FRUIT_NAME
 WHERE A.DATE BETWEEN '2022-06-11' AND '2022-06-13'
 GROUP BY A.CUST_ID

-- 2�ܰ�
-- �� ���� �ݾ��� ���� ū 1��� ���ϱ�.
SELECT TOP (1) A.CUST_ID
     , SUM(A.AMOUNT * B.PRICE) AS FRUIT_PRICE
  FROM TB_SaleList A LEFT JOIN TB_FRUIT B
                            ON A.FRUIT_NAME = B.FRUIT_NAME
 WHERE A.DATE BETWEEN '2022-06-11' AND '2022-06-13'
 GROUP BY A.CUST_ID
 ORDER BY FRUIT_PRICE DESC;

-- 3�ܰ�
-- ������ ���űݾ��� ���� ū ����� ���� �̷� ���ϱ�

]