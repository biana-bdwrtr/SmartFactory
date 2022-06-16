-- 1. �����͸� �����ϴ� �� ��ȸ --> LIKE
-- WHERE ���ǿ� �˻��ϰ��� �ϴ� �������� �Ϻκи� �Է��Ͽ�
-- �ش� ������ ���Ե� ��� �����͸� ǥ�� '%'

-- TB_ItemMaster ���̺� ITEMCODE �÷��� ������ �� 'E'�� ���Ե� �÷� �����͸� ��� ��ȸ
SELECT *
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE '%E%' -- E�� �����ϰ� �ִ� ��� ������ ��ȸ.
 ;

-- TB_ItemMaster ���̺��� ITEMCODE �÷��� ������ �� '64'�� �����ϴ� �����͸� ��� ��ȸ
SELECT *
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE '64%'
 ;

-- TB_ItemMaster ���̺��� ITEMCODE �÷��� ������ �� '3X000E'�� ������ �����͸� ��� ��ȸ
SELECT *
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE '%3X000E'
 ;

-- 2. NULL ���� �ƴ� ������ ��ȸ �� NULL ���� ������ ��ȸ(IS NULL, IS NOT NULL)
--    NULL : �����Ͱ� ���� ����ִ� ����. �����Ͱ� �Ҵ���� ���� ����

-- TB_ItemMaster ���̺��� MAXSTOCK �÷��� NULL�� ���� ��ȸ.
SELECT *
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NULL
;

-- TB_ItemMaster ���̺��� MAXSTOCK �÷��� NULL�� �ƴ� ������ �˻�.
SELECT *
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NOT NULL
 ;

-- TB_ItemMaster ���̺��� BOXSPEC �÷��� �����Ͱ� '01'�� �����鼭 NULL�� �ƴ� PLANTCODE, ITEMCODE, ITEMNAME �÷��� �����͸� �˻��ϼ���.
SELECT PLANTCODE, ITEMCODE, ITEMNAME
  FROM TB_ItemMaster
 WHERE BOXSPEC LIKE '%01'
   AND BOXSPEC IS NOT NULL
;

-- 3. �˻� ��� ���� --> ORDER BY ASC/DESC (ASC: ��������/DESC: ��������)
--    ���̺��� �˻��� ����� ���ǿ� ���� �����Ͽ� ��Ÿ����.

-- TB_ItemMaster ���̺��� ITEMTYPE = 'HALB'��
-- ITEMCODE, ITEMTYPE �÷��� �����͸� ITEMCODE �÷� ������ �������� �������� ��ȸ
SELECT ITEMCODE
     , ITEMTYPE
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
 ORDER BY ITEMCODE ASC;

-- ORDER BY ������ �����÷��� �� ��� ���ʺ��� ���������� �켱������ ���´�.
SELECT ITEMCODE
     , ITEMTYPE
	 , WHCODE
	 , BOXSPEC
  FROM TB_ItemMaster
 ORDER BY ITEMTYPE, WHCODE, BOXSPEC;

-- ��ȸ���� �ʴ� �÷��� ������ ���� ���� �߰��ϱ�
-- TB_ItemMaster ���̺��� ITEMTYPE = 'HALB'�� 
-- ITEMTYPE, WHCODE, BOXSPEC �÷���
-- ITEMCODE ������� �����Ͽ� �˻�
SELECT ITEMTYPE
     , WHCODE
	 , BOXSPEC
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
 ORDER BY ITEMCODE;

-- �������� �����ϱ� DESC
-- TB_ItemMaster ���̺��� ITEMTYPE = 'HALB'��
-- ITEMCODE, ITEMTYPE, �÷��� �����͸� ITEMCODE �÷� ������ �������� ���������Ͽ� ��ȸ
SELECT ITEMCODE
     , ITEMTYPE
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
 ORDER BY ITEMCODE DESC
;

-- TB_ItemMaster ���̺��� INSPFLAG�� NULL�� �ƴ�
-- ITEMTYPE, WHCODE, INSPFLAG �÷���
-- ITEMTYPE ���� ��������, WHCODE ��������, INSPFLAG�� ������������ �����Ͻÿ�.
SELECT ITEMTYPE
     , WHCODE
	 , INSPFLAG
  FROM TB_ItemMaster
 WHERE INSPFLAG IS NOT NULL
 ORDER BY ITEMTYPE ASC, WHCODE DESC, INSPFLAG ASC;

-- �ǽ� --
-- TB_ItemMaster ���̺��� MATERIALGRAD �÷��� ���� NULL �̰�
-- CARTYPE �÷� ���� MD, RB, TL�� �ƴϸ鼭 
-- ITEMCODE �÷� ���� '001'�� �����ϰ� 
-- UNITCOST �÷� ���� 0�� ���� ��� �÷��� 
-- ITEMNAME �÷��� ������������ WHCODE �÷��� ������������ ��ȸ�ϼ���.
SELECT *
  FROM TB_ItemMaster
 WHERE MATERIALGRADE IS NULL
   AND CARTYPE NOT IN ('MD', 'RB', 'TL')
   AND ITEMCODE LIKE '%001%'
   AND UNITCOST = 0
 ORDER BY ITEMNAME DESC, WHCODE ASC;


 -- 4. ������ �պ� �˻� --> DISTINCT
 -- �÷��� �����Ͱ� �ߺ��� ���� ��� �ߺ��� �����͸� �պ��Ͽ� �˻�.
 -- TB_ItemMaster ���̺��� ITEMTYPE�� ��ȸ
 SELECT ITEMTYPE
   FROM TB_ItemMaster;

-- TB_ItemMaster ���̺��� ITEMTYPE�� �պ� �� �˻�
SELECT DISTINCT ITEMTYPE
  FROM TB_ItemMaster;

-- ���� �÷��� ��ȸ �� ��ȸ�ϴ� �÷��� ��� �ߺ��Ǵ� ������ �����ϴ� �����͸� ��ȸ.

-- TB_ItemMaster ���̺��� BASEUNIT = 'KG' ���� ���� ������ �� ITEMTYPE�� ITEMSPEC�� ���ÿ� �ߺ����� �ʴ� �պ��� �����͸� ��ȸ.
SELECT DISTINCT ITEMTYPE
              , ITEMSPEC
  FROM TB_ItemMaster
 WHERE BASEUNIT = 'KG'
 ORDER BY ITEMSPEC;

-- �ǽ� --
-- TB_ItemMaster ���̺��� BOXSPEC�� 'DS-PLT'�� �����ϴ�
-- ITEMTYPE�� WHCODE�� ������ ��ȸ�ϼ���.
SELECT DISTINCT ITEMTYPE
              , WHCODE
  FROM TB_ItemMaster
 WHERE BOXSPEC LIKE 'DS-PLT%'
 ORDER BY ITEMTYPE ASC;

-- 5. �˻��� ������ �� �����ϴ� ���� ������ ���ϱ� --> TOP (N)
--    �˻� ������ �����ϴ� �� �߿� ���������� ������ ���� ������ ǥ��.
-- e.g. �ҷ��� �߻� ǰ�� ���� TOP 10 ���� ������ �� ���� ���.

-- ���� 10���� �����͸� �˻�.
SELECT TOP (10) *
  FROM TB_ItemMaster;

-- ORDER BY �� ���ؼ� ��������/������������ ��ȸ�� 5���� ���� ��ȸ.
SELECT TOP (5) *
  FROM TB_ItemMaster
 ORDER BY MAXSTOCK DESC;


-- �˻� ������ �Է��� ���� ������ ��ȸ.
SELECT TOP(8) *
  FROM TB_ItemMaster
 WHERE WHCODE = 'WH005'
ORDER BY MAXSTOCK DESC;

-- �ǽ� --
-- TB_ItemMaster ���̺��� INPUTFLAG�� 'O'�� ������ ��
-- INOUTDATE(��������)�� ���� �ֱ��� ������ ���� 10���� 
-- PLANTCODE, ITEMCODE, MATLOTNO, WHCODE, INOUTDATE, INOUTQTY �� ��ȸ�ϼ���.
SELECT TOP (10)
       PLANTCODE
     , ITEMCODE
	 , MATLOTNO
	 , WHCODE
	 , INOUTDATE
	 , INOUTQTY
  FROM TB_StockMMrec
 WHERE INOUTFLAG = 'O'
 ORDER BY INOUTDATE DESC;

-- 6. ������ �պ� �˻� --> GROUP BY, HAVING, �����Լ� --> �߿�ڡڡڡڡ�
-- GROUP BY ���ǿ� ���� �ش� �÷��� �����͸� ����.
-- GROUP BY�� ��ȸ�� ������� ��ȸ ������ �־� �˻�(HAVING)
-- ���� �Լ��� ����Ͽ� ���յǴ� �����͸� ������ �� �ִ�.

-- GROUP BY�� �⺻ ����
SELECT ITEMCODE              -- 5. ITEMCODE �÷��� ��ȸ�϶�.
  FROM TB_ItemMaster         -- 1. TB_ItemMaster ���̺���
 WHERE ITEMTYPE = 'ROH'      -- 2. ITEMTYPE = 'ROH'��� ���� ���� �����͸�
 GROUP BY ITEMCODE           -- 3. ITEMCODE �÷� �������� �����ϰ�
HAVING ITEMCODE LIKE '%3%'   -- 4. ���յ� ��� �� ITEMCODE�� 3�� ���� �����ϴ�
;

-- SELECT DISTINCT ITEMCODE
--   FROM TB_ItemMaster;

-- WHERE���� HAVING���� �������̹Ƿ� ������ ����.

-- GROUP BY���� DISTINCT�� �ٸ� ��.
-- DISTINCT: WHERE ������ �����ϴ� �ߺ��� ������ �����Ͽ� �˻�.
-- GROUP BY: ���յ� �������� ����� ������ �ξ�(HAVING) HAVING �������� ��˻�.
--           �����Լ��� ���� ����� �� �����ϴ�.

-- DISTINCT
-- TB_ITEMMASTER ���̺��� ITEMTYPE = 'HALB'�� �� �� �ߺ��� ������ ITEMSPEC �÷������͸� �˻�.
SELECT DISTINCT ITEMSPEC
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB';

-- GROUP BY
-- TB_ITEMMASTER ���̺��� ITEMTYPE = 'HALB'�� �� �� WHCODE�� �����Ͽ� �˻��ϰ� ��� �� WHCODE�� WH003�� ������ �˻�.
SELECT WHCODE
     , COUNT(1) AS CNT
	 , (SELECT COUNT(1) FROM TB_ItemMaster) AS TTL_CNT
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
 GROUP BY WHCODE
HAVING WHCODE = 'WH003'
;

-- ���� GROUP BY�� ������ ��� �÷��� �ݵ�� SELECT ��ȸ �÷��� ���ԵǾ� �־�� �Ѵ�.

-- TB_ITEMMASTER ���̺��� ITEMSPEC �÷��� �����ϰ� �� ����� ��Ÿ������ �ϳ� 
-- GROUP BY�� �� ��� ���ԵǾ� ���� �ʴ� �÷��� SELECT�� ���
SELECT ITEMCODE
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC;
--> �� 'TB_ItemMaster.ITEMCODE'��(��) ���� �Լ��� GROUP BY ���� �����Ƿ� SELECT ��Ͽ��� ����� �� �����ϴ�.


-- �������� �������� ����
SELECT ITEMSPEC
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC;

-- TB_ITEMMASTER ���̺��� ITEMSPEC �÷��� �����Ϸ��� �ϳ� ITEMSPEC�� WHCODE�� �˻� �÷����� ������ ���(����)
SELECT ITEMSPEC
     , WHCODE
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC;
--> �� 'TB_ItemMaster.WHCODE'��(��) ���� �Լ��� GROUP BY ���� �����Ƿ� SELECT ��Ͽ��� ����� �� �����ϴ�.

-- �������� �������� ����
SELECT ITEMSPEC
     , WHCODE
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC, WHCODE;

 -- GROUP BY, HAVING������ ����Ͽ� TB_STOCKMM ���̺�(������ ���)���� 
 -- STOCKQTY�� 1500�� �̻��� �������� INDATE(�԰�����)�� ITEMCODE(ǰ��) �÷��� ��ȸ�ϰ�
 -- ��ȸ�� ��� �� ITEMCODE�� C�� ������ �����͸� �˻��ϼ���.
 SELECT INDATE      -- �԰����ں�
      , ITEMCODE    -- ǰ��
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
 GROUP BY INDATE, ITEMCODE
HAVING ITEMCODE LIKE '%C';

-- ���� HAVING�� ������ �÷��� �ݵ�� GROUP BY�� ���� ���յ� �÷��̾�� �Ѵ�.
-- TB_ITEMMASTER ���̺��� ITEMSPEC�� WHCODE �÷��� �����Ͽ� ���� ������� ITEMTYPE�� �˻��� ���(����)
SELECT ITEMSPEC
     , WHCODE
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC
        , WHCODE
HAVING ITEMTYPE = 'HALB';
--> �� 'TB_ItemMaster.ITEMTYPE'��(��) ���� �Լ��� GROUP BY ���� �����Ƿ� HAVING ������ ����� �� �����ϴ�.

-- ���� ���� �������� ����
SELECT ITEMSPEC
     , WHCODE
  FROM TB_ItemMaster
 GROUP BY ITEMSPEC, WHCODE
HAVING WHCODE = 'WH003'
;

-- �����Լ� --
-- SUM() : ���յǴ� �÷��� �����͸� ��� ���Ѵ�.
-- MIN() : ���յǴ� �÷��� ������ �� ���� ���� ���� ��Ÿ����.
-- MAX() : ���յǴ� �÷��� ������ �� ���� ū ���� ��Ÿ����.
-- COUNT() : ���յ� �÷��� �����ͺ� ������ ��Ÿ����.
-- AVG() : ���յǴ� �÷��� ���� �������� ���� ����� ��Ÿ����.

-- �����Լ��� ����ϴ� �÷��� GROUP BY �� ���յ� ��󿡼� ���� ����.
-- �����Լ��� ������� �ʴ� �÷��� ���ԵǾ� ���� ��� GROUP BY�� �÷� ������� ��ϵž� ��.

-- ITEMCODE�� ��� ���� ���� ��ȸ.
SELECT ITEMCODE
     , COUNT(1) AS ITEM_CNT
  FROM TB_StockMM
 GROUP BY ITEMCODE
;

-- ITEMCODE���� STOCKQTY �� ��ȸ
SELECT ITEMCODE
     , SUM(STOCKQTY) AS STOCKQTY_SUM
  FROM TB_StockMM
 GROUP BY ITEMCODE;

-- ITEMCODE �� STOCKQTY ��� ��ȸ
SELECT ITEMCODE
     , AVG(STOCKQTY) AS STOCKQTY_AVG
	 , COUNT(1) AS ITEMCODE_CNT
	 , SUM(STOCKQTY) AS STOCKQTY_SUM
  FROM TB_StockMM
 GROUP BY ITEMCODE
;

-- ITEMCODE �� STOCKQTY �ּҰ� ��ȸ
SELECT ITEMCODE
	 , MIN(STOCKQTY) AS STOCKQTY_MIN
  FROM TB_StockMM
 GROUP BY ITEMCODE
;

-- ITEMCODE �� STOCKQTY �ִ밪 ��ȸ
SELECT ITEMCODE
	 , MAX(STOCKQTY) AS STOCKQTY_MAX
  FROM TB_StockMM
 GROUP BY ITEMCODE
;

-- ���� �Լ��� ������ ����Ͽ� ���ϴ� ����� ���� �� �ִ�.
-- ITEMTYPE�� UNITCOST�� �հ� �ּҰ� ��ȸ.
-- ����� ������� HAVING �������� �߰��Ͽ� ���ϴ� ����� ��˻��� �� �ִ�.
SELECT ITEMTYPE
     , SUM(UNITCOST) AS UNITCOST_SUM
	 , MIN(UNITCOST) AS UNITCOST_MIN
  FROM TB_ItemMaster
 GROUP BY ITEMTYPE
HAVING SUM(UNITCOST) > 20000
;

-- ���� �Լ��� ����� ����� ��ȸ ���� ���͸� --> HAVING
-- �� ����
-- ����� ������� HAVING �������� �߰��Ͽ� ���ϴ� ��� ���� ���� �����͸� ����.

-- TB_ITEMMASTER ���̺��� UNITCOST�� 0�̻��� ������ �� 
-- ITEMTYPE���� UNITCOST�� �� ��, UNITCOST�� �ִ밪�� ��Ÿ���� 
-- ����� ���� �� UNITCOST�� ���� 100�̻��� �����͸�
-- UNITCOST �ִ밪 �������� �������� ����.
SELECT ITEMTYPE
     , SUM(UNITCOST) AS UNITCOST_SUM
	 , MAX(UNITCOST) AS UNITCOST_MAX
  FROM TB_ItemMaster
 WHERE UNITCOST >= 0
 GROUP BY ITEMTYPE
HAVING SUM(UNITCOST) > 100
 ORDER BY SUM(UNITCOST);

(
SELECT ITEMTYPE
     , SUM(UNITCOST) AS UNITCOST_SUM
	 , MAX(UNITCOST) AS UNITCOST_MAX
  FROM TB_ItemMaster
 WHERE UNITCOST >= 0
 GROUP BY ITEMTYPE
HAVING SUM(UNITCOST) > 100
)
 ORDER BY UNITCOST_MAX; -- SELECT ���� �� �÷� ��Ī�� �ο��Ǿ� ORDER BY������ ��Ī���� ȣ�� ����.

 
SELECT ITEMTYPE
     , SUM(UNITCOST) AS UNITCOST_SUM
	 , MAX(UNITCOST) AS UNITCOST_MAX
  FROM TB_ItemMaster
 WHERE UNITCOST >= 0
 GROUP BY ITEMTYPE
HAVING SUM(UNITCOST) > 100
 ORDER BY UNITCOST_MAX;



 -- �����ͺ��̽����� ���� ó�� ����
 -- : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

-- �ϳ��� �÷��� ���� ���踦 ��Ÿ�� ������ GROUP BY �� DISTINCT�� �����Ͽ� �˻��� ����.
SELECT SUM(UNITCOST) AS ITEMCODE_SUM
  FROM TB_ItemMaster;

--�ڡڡ� �߿� �ڡڡ�--
-- GROUP BY �� �����Լ��� ���� ����� �� �����ϰ� ���δ�.

-- TB_STOCKMM ���̺��� STOCKQTY�� 1000�� �̻��� INDATE(�԰�����)���� ITEMCODE�� ���յ� ������ ������ 1���� ū ������ �˻��϶�.
SELECT INDATE
     , ITEMCODE
     , COUNT(1) AS CNT
  FROM TB_StockMM
 WHERE STOCKQTY >= 1000
 GROUP BY INDATE
        , ITEMCODE
HAVING COUNT(1) > 1;

-- �ǽ� --
-- TB_STOCKMMREC(���� ���� �̷�) ���̺��� ������ ��
-- INOUTQTY(����� ����)�� 1000���� ũ��, INOUTFLAG�� 'I'(�԰��̷�)��
-- INOUTDATE(����� ����)�� WHCODE(â��)�� ���յ� �������� ������ 2�� �̻��� �����͸�
-- INOUTDATE ������������ ��ȸ�ϼ���.
SELECT INOUTDATE
     , WHCODE
	 , COUNT(1) AS CNT
  FROM TB_StockMMrec
 WHERE INOUTQTY > 1000
   AND INOUTFLAG = 'I'
 GROUP BY INOUTDATE, WHCODE
HAVING COUNT(1) >= 2
ORDER BY INOUTDATE ASC;

-- 7. ���� ����(SUB QUERY).
--    : ������ ������Ű�� ���� (WHERE ���̸�, ���� ���� ��� = '?') ������ �ۼ��Ͽ�
--      �����͸� �˻��ϴ� ���.
-- - ���� : SQL ���� �ȿ��� �����ϰ� �� �ٸ� SQL ����(SUB QUERY)�� ����� Ȱ���� �� �ִ�.
-- - ���� : ���� �ӵ��� ��������. ���� ���⼺ ����.


-- ���� ������ ���� �������� ��ȸ

/* 
TB_STOCKMMREC(���� ���� �̷�) ���̺��� PONO(���� ��ȣ)��  'PO202106270001'�� ITEMCODE�� ������ 
TB_ITEMMASTER(ǰ�� ������) ���̺��� ��ȸ�Ͽ� ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷��� ������ �˻�
*/
SELECT ITEMCODE
     , ITEMNAME
	 , ITEMTYPE
	 , CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE = (SELECT ITEMCODE
                     FROM TB_StockMMrec
                    WHERE PONO = 'PO202106270001')
;
-- ���� �������� ��ȸ�Ǿ�� �ϴ� �÷��� ������ ������ �÷��� ������ �����ؾ� �Ѵ�.

-- '='�� ���ǿ��� �ΰ� �̻��� ���� ������ ���� ���� ������ ������ �� ����.
SELECT ITEMCODE -- ǰ���ڵ�
     , ITEMNAME -- ǰ���
  FROM TB_ItemMaster
 WHERE ITEMCODE = (SELECT ITEMCODE
                     FROM TB_StockMMrec
                    WHERE INOUTFLAG = 'I')
;
--> ���� �������� ���� �� �̻� ��ȯ�߽��ϴ�. ���� ���� �տ� =, !=, <, <=, >, >= ���� ���ų� ���� ������ �ϳ��� ������ ���� ��쿡�� ���� ���� ��ȯ�� �� �����ϴ�.

-- �������� �ʴ� ������ �˻�
SELECT ITEMCODE
     , ITEMNAME
  FROM TB_ItemMaster
 WHERE ITEMCODE <> (SELECT ITEMCODE
                      FROM TB_StockMMrec
					 WHERE PONO = 'PO202106270001');

-- �ΰ� �̻��� �����͸� ���� ������ �����ϴ� ���.
SELECT ITEMCODE -- ǰ���ڵ�
     , ITEMNAME -- ǰ���
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT ITEMCODE
                      FROM TB_StockMMrec
                     WHERE INOUTFLAG = 'I')
;

-- ���� ������ ���� ����...�� ���� ����...�� ��������...and so on.
-- TB_StockMM(���� ���) ���̺��� STOCKQTY(��� ����)�� 3000���� ū MATLOTNO(LOTNO)�� ����
-- TB_STOCKMMREC(���� ���� �̷�) ���̺��� ITEMCODE �����͸� 
-- TB_ITEMMASTER(ǰ�� ������) ���̺��� ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷����� �˻�.
SELECT MATLOTNO
  FROM TB_StockMM
 WHERE STOCKQTY > 3000
 ;

-- 2. TB_StockMMrec(���� ���� �̷�) ���̺��� 1������ ��ȸ�� MATLOTNO�� ������ ITEMCODE ��ȸ
SELECT ITEMCODE
  FROM TB_StockMMrec
 WHERE MATLOTNO IN (SELECT MATLOTNO FROM TB_StockMM WHERE STOCKQTY > 3000)

-- 3. TB_ItemMaster(ǰ�� ������) ���̺��� �ش� ITEMCODE ������ ã��.
SELECT ITEMCODE
     , ITEMNAME
	 , ITEMTYPE
	 , CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (
					SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO IN (
										SELECT MATLOTNO 
										  FROM TB_StockMM 
										 WHERE STOCKQTY > 3000
										)
					);

-- ���� ������ �ƴѵ� ���� ����ó�� ���̴� �͵�.
-- 1. SELECT ���� �÷� ��ġ�� �δ� ���.
-- TB_STOCKMM ���̺��� ITEMCODE, INDATE, MATLOTNO �÷��� �����͸� �˻��ϰ�,
-- TB_STOCKMMREC ���̺��� TB_STOCKMM ���̺��� ��ȸ�� MATLOTNO �÷��� �����͸� �����ϰ�,
-- INOUTFLAG = 'OUT'��� ���� ���� INOUTDATE �÷��� �����͸� ��ȸ
SELECT ITEMCODE
     , INDATE
	 , MATLOTNO
	 , (SELECT INOUTDATE 
	      FROM TB_StockMMrec REC 
		 WHERE REC.MATLOTNO = STOCK.MATLOTNO 
		   AND INOUTFLAG = 'OUT') AS INOUTDATE
  FROM TB_StockMM STOCK
;

-- ���� ����
-- 1. TB_STOCKMM���� �����͸� ��ȸ
SELECT ITEMCODE
     , INDATE
	 , MATLOTNO
  FROM TB_StockMM
;

-- 2. �÷��� �ִ� SELECT ������ 1�ܰ迡�� ��ȸ�� MATLOTNO ���� ���� ����.
SELECT INOUTDATE
  FROM TB_StockMMrec
 WHERE MATLOTNO IN ('LOTR2021070817274225'
				  , 'LOTR2021070817274225'
				  , 'LT_R2021082012481881'
				  , 'LTROH1132574030001'
				  , 'LTROH1438534870001'
				  , 'LTROH1459097100001'
				  , 'LTROH1556377070001'
				  , 'LTROH1650200500001'
				  , 'LTROH2130262570001'
				  , 'LTROH2134195800002')
   AND INOUTFLAG = 'OUT';

-- ���� ���̺� TB_StockMM���� ��ȸ 1��
-- SELECT SUBQUERY ��ȸ 9��
-- �� 10���� �˻� ������ ���� --> ��ȿ����


-- SELECT ������ FROM ��ġ�� �δ� ���,
-- TB_STOCKMMREC ���̺� ������ �� INOUTQTY�� 1000���� ũ��, INOUTFLAG�� 'I'��
-- INOUTDATE�� WHCODE�� ���յ� �������� ������ 2�� �̻��� �����͸� �˻��Ͻÿ�.
SELECT INOUTDATE
     , WHCODE
     , COUNT(*) AS CNT
  FROM TB_StockMMrec
 WHERE INOUTQTY > 1000
   AND INOUTFLAG = 'I'
 GROUP BY INOUTDATE, WHCODE
HAVING COUNT(*) >= 2
;

-- GROUP BY ������ �ϳ��� ���̺�� ����ϴ� ���.
SELECT  INOUTDATE, WHCODE, CNT
FROM     (SELECT  INOUTDATE, WHCODE, COUNT(*) AS CNT
                FROM     TB_StockMMrec
                WHERE  (INOUTQTY > 1000) AND (INOUTFLAG = 'I')
                GROUP BY INOUTDATE, WHCODE) AS A
WHERE  (CNT >= 2)
;


-- 8. CASE WHEN ELSE
-- �б⹮, ����� ���¿� ���� ���̳� ������ �ٸ��� �����Ѵ�.
-- �ݵ�� END Ű����� �������� ����� �Ѵ�.

-- 1ST CASE ���
SELECT INOUTFLAG -- ����� ���� --> I: �԰� / O: ���
     , CASE INOUTFLAG WHEN 'I' THEN '�԰�'
	                  WHEN 'O' THEN '���'
					  ELSE '��Ÿ'
		END AS INOUT_FLAG
  FROM TB_StockMMrec
;

-- 2ND CASE ���
SELECT PLANTCODE --����
     , MATLOTNO  --LOT NO.
	 , WHCODE    --â��
	 , STOCKQTY  --��� ����
	 , CASE WHEN STOCKQTY <= 0 THEN '������'
	        WHEN STOCKQTY >= 0 AND STOCKQTY <= 1000 THEN '���� ����'
			ELSE '��� �ʰ�'
	    END AS STOCK_STATE
  FROM TB_StockMM
;

-- 8. NULL�� ���� ���ϴ� �����ͷ� �����ϱ� --> ISNULL(?, ?)

-- TB_StockMMrec ���̺��� PLANTCODE, INOUTDATE, INOUTSEQ, ITEMCODE �÷��� �����͸� �˻��ϰ�,
-- ITEMCODE�� NULL�� ��� 0���� ǥ���ϼ���.
SELECT PLANTCODE
     , INOUTDATE
	 , INOUTSEQ
	 , ISNULL(ITEMCODE, 0) AS ITEMCODE
  FROM TB_StockMMrec