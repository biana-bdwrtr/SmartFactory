USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13BM_CustMaster_S]    Script Date: 2022-07-01 오전 11:15:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.07.01
-- Description:	거래처 조회
-- =============================================
ALTER PROCEDURE [dbo].[13BM_CustMaster_S]
	@PLANTCODE		VARCHAR(10)  -- 공장
  , @CUSTCODE 		VARCHAR(10)  -- 거래처 코드
  , @CUSTTYPE 		VARCHAR(100) -- 거래처 구분
  , @CUSTNAME 		VARCHAR(100) -- 거래처 명
  , @USEFLAG 		VARCHAR(1)   -- 사용여부

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	SELECT CSM.PLANTCODE                         AS PLANTCODE	-- 공장
         , CSM.CUSTCODE	                         AS CUSTCODE	-- 거래처 코드
         , CSM.CUSTTYPE	                         AS CUSTTYPE	-- 거래처 구분
         , CSM.CUSTNAME	                         AS CUSTNAME	-- 거래처 명
         , CSM.ADDRESS	                         AS ADDRESS		-- 주소
         , CSM.PHONE  	                         AS PHONE  		-- 연락처
         , CSM.USEFLAG	                         AS USEFLAG		-- 사용여부
         , DBO.FN_WORKERNAME(CSM.MAKER)  	     AS MAKER  		-- 생성자
         , CONVERT(VARCHAR, CSM.MAKEDATE, 120)	 AS MAKEDATE	-- 생성일자
         , DBO.FN_WORKERNAME(CSM.EDITOR)         AS EDITOR 		-- 수정자
         , CONVERT(VARCHAR, CSM.EDITDATE, 120)	 AS EDITDATE	-- 수정일자
	  FROM TB_CustMaster CSM WITH(NOLOCK)
	 WHERE CSM.PLANTCODE             LIKE '%' + ISNULL(@PLANTCODE, '') + '%'
	   AND CSM.CUSTCODE              LIKE '%' + ISNULL(@CUSTCODE , '') + '%'
	   AND CSM.CUSTTYPE              LIKE '%' + ISNULL(@CUSTTYPE , '') + '%'
	   AND CSM.CUSTNAME              LIKE '%' + ISNULL(@CUSTNAME , '') + '%'
	   AND ISNULL(CSM.USEFLAG, '')   LIKE '%' + ISNULL(@USEFLAG  , '') + '%'
	 ORDER BY CSM.PLANTCODE, CSM.CUSTCODE ASC;

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상작동';
END
