
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022-06-17
-- Description:	���ν��� ����� �ǽ�.(���ϰ��� ���� ���� ���)
-- =============================================
CREATE PROCEDURE SPROC_SaleList2_IUD
	-- �Ķ���� ���� �κ�.
	@DATE		VARCHAR(10), -- ����.
	@CUSTID		INT,         -- �� ID.
	@FRUIT_NAME	VARCHAR(20), -- ���� �̸�
	@AMOUNT		INT          -- ���� ����.
AS
BEGIN
	-- ���ν����� ������ SQL ����
	-- 1. TB_SALELIST2 ���̺� ������ ����.
	DELETE TB_SaleList2;

	-- 2. TB_SALELIST2 ���̺� ������ ����ϱ�
	INSERT INTO TB_SaleList2 VALUES(@DATE, @CUSTID, @FRUIT_NAME, @AMOUNT);

	-- 3. ������ �����ϱ�
	UPDATE TB_SaleList2
	   SET AMOUNT = 10
	     , DATE = '2022-06-01'
     WHERE CUST_ID = @CUSTID;
END
GO
