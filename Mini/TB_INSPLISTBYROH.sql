-- ITEMCODE�� ROH���� Ȯ��

INSERT INTO TB_INSPLISTBYROH (PLANTCODE, ITEMCODE,    INSPCODE, REMARK, USEFLAG, MAKEDATE,   MAKER)
                      VALUES ('1000',    'KFQS13-00', 'A01',    NULL,   'Y',     GETDATE(), 'KFQS13')
					       , ('1000',    'KFQS13-00', 'A05',    NULL,   'Y',     GETDATE(), 'KFQS13')
						   , ('1000',    'KFQS13-00', 'A09',    NULL,   'Y',     GETDATE(), 'KFQS13')
;



SELECT *
  FROM TB_ItemMaster
 WHERE ITEMNAME LIKE '%���%';

SELECT *
  FROM TB_INSPLISTBYROH;