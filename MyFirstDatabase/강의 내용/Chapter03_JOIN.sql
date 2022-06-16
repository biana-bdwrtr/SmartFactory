/*
1. ���̺� �� ������ ���� �� ��ȸ(JOIN)
JOIN : �� �̻��� ���̺��� �����ؼ������͸� �˻��ϴ� ���.
       ���̺��� ���� �����ϱ� ���ؼ��� �ϳ� �̻��� �÷��� �����ϰ� �־�� ��.
  ON : �� ���̺��� ������ ���� �÷� ���� ��ɾ�.

  - ���� ����(INNER JOIN) : JOIN
  - �ܺ� ����(OUTER JOIN) : LEFT JOIN, RIGHT JOIN, FULL JOIN
*/

-- JOIN 
-- �������� �κи� ��ȸ�Ǵ� ���Ṯ.

/*
TB_Cust ���̺�� TB_SaleList ���̺��� 
���� DB_Cust.ID, TB_SaleList.CUST_ID �÷� ���� ���� ������ �����͸� ������
�� ID, �� �̸�, �Ǹ�����, ����, �Ǹż����� ǥ��
*/

-- ** ����� ǥ���� JOIN���� ON

-- �Ǹ� ��Ȳ ����Ʈ ���̺��� �������� �� ������ JOIN�� ���
SELECT A.CUST_ID                                           -- �� ID
     , B.NAME+' �ٺ�'AS CUST_NAME                          -- �� ��
	 , A.DATE                                              -- �Ǹ� ����
	 , A.FRUIT_NAME                                        -- ���� �̸�
	 , CONVERT(CHAR, A.AMOUNT)+'��' AS "�Ǹż���"          -- �Ǹż���
  FROM TB_SaleList A JOIN TB_Cust B ON A.CUST_ID = B.ID;

-- �� ������ �������� ��ȸ�ϰ��� �������� ��ȸ�ϸ�
-- �Ʒ��� ���ó�� �� ������ ���� ��Ÿ����.
SELECT *
  FROM TB_Cust
;

-- ������ ���̺��� �������� ���̺�� �ϰ� �Ǹ� ���̺��� ���� ���̺�� JOIN������
-- ���� ���̺� �ִ� �����Ͱ� ��Ÿ���� �ʴ� ��찡 �����.
SELECT A.ID
     , A.NAME
	 , B.DATE
	 , B.FRUIT_NAME
	 , B.AMOUNT
  FROM TB_Cust A JOIN TB_SaleList B 
                   ON A.ID = B.CUST_ID
;
-- JOIN: �������� �κи� ��ȸ�Ǹ�
-- ����Ǵ� ���̺� �� �����ϴ� �÷��� �����Ͱ� �� �� �����ؾ� �����͸� ��Ÿ����.

SELECT A.ID
     , A.NAME
	 , A.PHONE
	 , B.DATE
	 , B.FRUIT_NAME
	 , B.AMOUNT
  FROM TB_Cust A
     , TB_SaleList B
 WHERE A.ID = B.CUST_ID
;