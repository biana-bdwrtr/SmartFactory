USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_IQIMaster_U]    Script Date: 2022-07-14 오후 6:28:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김유진
-- Create date: 2022-07-12
-- Description:	수입검사 마스터 수정
-- =============================================
ALTER PROCEDURE [dbo].[55MM_IQIMaster_U]
	@PLANTCODE	VARCHAR(10),	-- 공장 코드
	@INSPCODE	VARCHAR(10),	-- 검사 코드
	@INSPNAME	VARCHAR(30),	-- 검사 명칭
	@IQITYPE	VARCHAR(10),	-- 검사 유형
	@POSpec		VARCHAR(50),	-- 관련 규정
	@LSL   		VARCHAR(10),	-- 관리 하한선
	@USL   		VARCHAR(10),	-- 관리 상한선
	@REMARK		VARCHAR(200),	-- 비고
	@USEFLAG	VARCHAR(1),		-- 사용여부	
	@EDITDATE	DATETIME,		-- 수정일시
	@EDITOR		VARCHAR(10),	-- 수정자

	@LANG			VARCHAR(10)  = 'KO',
	@RS_CODE		VARCHAR(1)   OUTPUT,
	@RS_MSG			VARCHAR(100) OUTPUT
AS
BEGIN
	-- 현재 시간 정의 공통 변수
	DECLARE @LD_NOWDATE DATETIME,
			@LS_NOWDATE VARCHAR(10);
		SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23);	-- yyyy-MM-dd

	DECLARE @LF_LSL FLOAT;
	DECLARE @LF_USL FLOAT;

	IF (@IQITYPE = 'V')	-- 육안 검사일 때
	BEGIN
		SET @LF_LSL = NULL;
		SET @LF_USL = NULL;
	END

	IF (@LSL = '' OR @USL = '')	-- 상하한선이 빈 값일 때
	BEGIN
		SET @LF_LSL = NULL;
		SET @LF_USL = NULL;
	END

	ELSE	-- 상하한선 값이 있을 때
	BEGIN
		SET @LF_LSL = CONVERT(FLOAT,@LSL);
		SET @LF_USL = CONVERT(FLOAT,@USL);
	END

	UPDATE TB_IQIMASTER
	   SET INSPCODE = @INSPCODE	 
         , INSPNAME = @INSPNAME  
         , IQITYPE	= @IQITYPE  
         , POSpec	= @POSpec	 
         , LSL 		= @LF_LSL		 
         , USL		= @LF_USL	 
		 , REMARK	= @REMARK
		 , USEFLAG	= @USEFLAG
		 , EDITDATE	= @LD_NOWDATE
		 , EDITOR   = @EDITOR
	 WHERE PLANTCODE	= @PLANTCODE  -- 공장
       AND INSPCODE 	= @INSPCODE	  -- 검사 코드
         ; 
	
	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상작동';
END