USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13BM_StopListMaster_I]    Script Date: 2022-06-30 오후 5:32:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.06.30
-- Description:	비가동 항목 삽입
-- =============================================
--ALTER PROCEDURE [dbo].[13BM_StopListMaster_I]
ALTER PROCEDURE [dbo].[13BM_StopListMaster_I]
	@PLANTCODE		VARCHAR(10)		-- 공장
  , @STOPCODE		VARCHAR(10)		-- 비가동 코드
  , @STOPNAME		VARCHAR(20)		-- 비가동 명
  , @REMARK			VARCHAR(255)    -- 비고
  , @USEFLAG		VARCHAR(1)		-- 사용여부
  , @MAKER			VARCHAR(20)     -- 생성자

  , @LANG			VARCHAR(10) = 'KO'
  , @RS_CODE		VARCHAR(1) OUTPUT
  , @RS_MSG			VARCHAR(100) OUTPUT

AS
BEGIN
	DECLARE @CNT INT = 0;

	-- 1. 직접 오류 내역을 비교하는 구문.
	/*
	BEGIN -- {
		IF (SELECT COUNT(*)
		      FROM TB_StopListMaster WITH(NOLOCK)
		     WHERE PLANTCODE = @PLANTCODE
		       AND STOPCODE  = @STOPCODE) > 0
		BEGIN
			SET @RS_CODE = 'E';
			SET @RS_MSG  = '이미 비가동 코드입니다.';
			RETURN;
		END;
	END; -- }
	*/

	-- 2. 변수에 담은 값으로 비교하는 경우
	SELECT @CNT = COUNT(*)
	  FROM TB_WorkerList WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @STOPCODE;
	
	IF (@CNT > 0)
	BEGIN
		SET @RS_CODE = 'E';
		SET @RS_MSG  = '이미 비가동 코드입니다.';
		RETURN;
	END;
	 

	INSERT INTO TB_StopListMaster(PLANTCODE, STOPCODE, STOPNAME, REMARK, USEFLAG, MAKER, MAKEDATE) 
	VALUES (@PLANTCODE, @STOPCODE, @STOPNAME, @REMARK, @USEFLAG, @MAKER, GETDATE());

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 작동';
	
END
