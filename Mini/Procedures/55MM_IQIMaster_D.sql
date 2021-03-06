USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_IQIMaster_D]    Script Date: 2022-07-14 오후 6:27:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김유진
-- Create date: 2022-07-12
-- Description:	수입검사 마스터 삭제
-- =============================================
ALTER PROCEDURE [dbo].[55MM_IQIMaster_D]
	@PLANTCODE		VARCHAR(10),	-- 공장 코드
	@INSPCODE		VARCHAR(10),	-- 검사 코드

	@LANG			VARCHAR(10)  = 'KO',
	@RS_CODE		VARCHAR(1)   OUTPUT,
	@RS_MSG			VARCHAR(100) OUTPUT
AS
BEGIN
	DELETE TB_IQIMASTER
	 WHERE PLANTCODE = @PLANTCODE -- 공장 코드
	   AND INSPCODE  = @INSPCODE; -- 검사 코드

	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상 작동';
END
