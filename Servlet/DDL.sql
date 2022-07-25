/*
 * �Խ��� ���̺�(t_board)
 * ��ȣ		������	PK
 * ����		������	not null
 * �ۼ���		������	not null
 * ����		������	not null
 * ��ȸ��		������	default 0
 * ����Ͻ�	��¥��	default sysdate
 */

CREATE TABLE t_board(
	  no 		number(5) 		PRIMARY KEY
	, title 	varchar2(200) 	NOT NULL
	, writer 	varchar2(30) 	NOT NULL
	, content 	varchar2(4000) 	NOT NULL
	, view_cnt 	number(5) 		DEFAULT 0
	, reg_date 	DATE 			DEFAULT sysdate
);

-- �Խ��� �Ϸù�ȣ ����
CREATE SEQUENCE seq_t_board_no nocache;

SELECT NO, title, writer, reg_date
  FROM T_BOARD tb ;

INSERT INTO T_BOARD (no, title, writer, content)
VALUES (seq_t_board_no.nextval, '�ƽ� 1��', '�ڳ���', '�ƽζ� 1���̴�.');

INSERT INTO T_BOARD (no, title, writer, content)
VALUES (seq_t_board_no.nextval, '���� 2��', '�̵���', '�Ƽ�..');

INSERT INTO T_BOARD (no, title, writer, content)
VALUES (seq_t_board_no.nextval, '������', '���Ѽ�', '�ٺ�~');

COMMIT;