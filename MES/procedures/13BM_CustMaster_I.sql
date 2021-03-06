USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13BM_CustMaster_I]    Script Date: 2022-07-01 오전 11:08:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.07.01
-- Description:	거래처 삽입
-- =============================================
ALTER PROCEDURE [dbo].[13BM_CustMaster_I]
	@PLANTCODE		VARCHAR(10)  -- 공장
  , @CUSTCODE 		VARCHAR(10)  -- 거래처 코드
  , @CUSTTYPE 		VARCHAR(100) -- 거래처 구분
  , @CUSTNAME 		VARCHAR(100) -- 거래처 명
  , @ADDRESS		VARCHAR(100) -- 주소
  , @PHONE			VARCHAR(100) -- 연락처
  , @USEFLAG 		VARCHAR(1)   -- 사용여부
  , @MAKER			VARCHAR(20)  -- 생성자

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	DECLARE @CNT INT = 0;

	SELECT @CNT = COUNT(*)  -- 이미 등록된 거래처 개수
	  FROM TB_CustMaster WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND CUSTCODE  = @CUSTCODE;
	IF (@CNT > 0)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '이미 등록된 거래처 코드입니다.';
		RETURN;
	END;

	INSERT INTO TB_CustMaster(PLANTCODE, CUSTCODE, CUSTTYPE, CUSTNAME, ADDRESS, PHONE, USEFLAG, MAKER, MAKEDATE)
	VALUES(@PLANTCODE, @CUSTCODE, @CUSTTYPE, @CUSTNAME, @ADDRESS, @PHONE, @USEFLAG, @MAKER, GETDATE());


	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상작동';
END
