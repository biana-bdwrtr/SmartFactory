USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_InspListByROH_D]    Script Date: 2022-07-14 오후 6:23:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<박형순>
-- Create date: <2022-07-13>
-- Description:	<품목별 수입 검사 항목 삭제>
-- =============================================
ALTER PROCEDURE [dbo].[55MM_InspListByROH_D]
	 @PLANTCODE		VARCHAR(10)		--공장코드
	,@ITEMCODE		VARCHAR(20)		--품번
	,@INSPCODE		VARCHAR(10)		--검사코드

	,@LANG			VARCHAR(10)  = 'KO'
	,@RS_CODE		VARCHAR(1)   OUTPUT
	,@RS_MSG		VARCHAR(100) OUTPUT

AS
BEGIN

	DELETE TB_INSPLISTBYROH
	WHERE	PLANTCODE	=	@PLANTCODE
	AND		ITEMCODE	=	@ITEMCODE
	AND		INSPCODE	=	@INSPCODE

SET @RS_CODE	=	'S'

END
