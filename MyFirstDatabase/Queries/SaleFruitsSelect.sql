USE MyFirstDataBase
SELECT C.NAME
     , C.PHONE
	 , L.SALE_DATE
     , L.QTY
	 , F.PRICE
	 , L.TOTAL_SALES
  FROM T_FRUIT F
     , T_FruitCustomer C
	 , T_SaleFruitList L
 WHERE L.CUST_ID = C.CUST_ID
   AND L.FRUIT = F.FRUIT
   AND L.SALE_DATE = F.DATE
 ORDER BY L.SALE_DATE, L.FRUIT ASC;