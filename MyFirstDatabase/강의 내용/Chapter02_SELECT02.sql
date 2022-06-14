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

