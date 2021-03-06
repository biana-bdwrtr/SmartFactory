USE [AppDev_SH]
GO
/****** Object:  StoredProcedure [dbo].[13SP_STANDARD_S]    Script Date: 2022-06-28 오후 5:40:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.06.28
-- Description:	공통코드 조회
-- =============================================
--CREATE PROCEDURE [dbo].[13SP_STANDARD_S]
ALTER PROCEDURE [dbo].[13SP_STANDARD_S]
	@MAJORCODE		VARCHAR(10), -- 주코드
	@MINORCODE		VARCHAR(20)  -- 부코드
AS
BEGIN
	SELECT STD.MAJORCODE AS MAJORCODE -- 주코드
	     , STD.MINORCODE AS MINORCODE -- 부코드
		 , STD.CODENAME AS  CODENAME  -- 코드명
		 , STD.DISPLAYNO AS DISPLAYNO -- 표시순번
	  FROM TB_Standard STD
     WHERE STD.MAJORCODE LIKE '%' + @MAJORCODE + '%'
	   AND STD.MINORCODE LIKE '%' + @MINORCODE + '%'
	 ORDER BY STD.MAJORCODE, STD.DISPLAYNO ASC;
END
