USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_IQIMaster_S]    Script Date: 2022-07-14 오후 6:28:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김유진
-- Create date: 2022-07-12
-- Description:	수입검사 마스터 조회
-- =============================================
ALTER PROCEDURE [dbo].[55MM_IQIMaster_S]
	@PLANTCODE		VARCHAR(10),	-- 공장 코드
	@INSPCODE		VARCHAR(10),	-- 검사 코드
	@INSPNAME		VARCHAR(30),	-- 검사 명칭
	@USEFLAG		VARCHAR(1),		-- 사용여부

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

	SELECT PLANTCODE						AS PLANTCODE	-- 공장 코드
		  ,INSPCODE							AS INSPCODE		-- 검사 코드
		  ,INSPNAME							AS INSPNAME		-- 검사 명칭
		  ,IQITYPE							AS IQITYPE		-- 검사 유형
		  ,POSpec							AS POSpec		-- 관련 규정
		  ,LSL   							AS LSL   		-- 관리하한선
		  ,USL   							AS USL   		-- 관리상한선
		  ,REMARK							AS REMARK		-- 비고
		  ,USEFLAG							AS USEFLAG		-- 사용여부
		  ,CONVERT(VARCHAR, MAKEDATE, 120)	AS MAKEDATE		-- 등록일시
		  ,DBO.FN_WORKERNAME(MAKER) 		AS MAKER 		-- 등록자
		  ,CONVERT(VARCHAR, EDITDATE, 120)	AS EDITDATE		-- 수정일시
		  ,DBO.FN_WORKERNAME(EDITOR)		AS EDITOR		-- 수정자
	  FROM TB_IQIMASTER
	 WHERE PLANTCODE LIKE '%' + @PLANTCODE
	   AND INSPCODE LIKE '%' + @INSPCODE + '%'
	   AND INSPNAME LIKE '%' + @INSPNAME + '%'
	   AND USEFLAG LIKE '%' + @USEFLAG
END
