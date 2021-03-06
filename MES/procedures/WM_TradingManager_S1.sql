USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[WM_TradingManager_S1]    Script Date: 2022-07-11 오후 12:24:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2022-07-17
-- Description:	출고 내역 공통(거래면세 공통) 조회
-- =============================================
ALTER PROCEDURE  [dbo].[WM_TradingManager_S1]
    @PLANTCODE VARCHAR(10) -- 공장
   ,@TRADINGNO VARCHAR(30) -- 거래명세 번호
   ,@CARNO     VARCHAR(20) -- 차량번호
   ,@STARTDATE VARCHAR(10) -- 출고 시작 일자
   ,@ENDDATE   VARCHAR(10) -- 출고 종료 일자
   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT PLANTCODE	AS PLANTCODE 
    	  ,TRADINGNO	AS TRADINGNO 
    	  ,TRADINGDATE	AS TRADINGDATE 
    	  ,CARNO		AS CARNO 
    	  ,MAKEDATE		AS MAKEDATE 
    	  ,MAKER		AS MAKER 
      FROM TB_TradingWM WITH(NOLOCK)
     WHERE PLANTCODE   LIKE '%' + @PLANTCODE +'%'
       AND TRADINGNO   LIKE '%' + @TRADINGNO +'%'
       AND CARNO       LIKE '%' + @CARNO     +'%'
       AND TRADINGDATE BETWEEN @STARTDATE AND @ENDDATE
END
