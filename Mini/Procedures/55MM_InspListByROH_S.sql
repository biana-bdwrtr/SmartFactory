USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_InspListByROH_S]    Script Date: 2022-07-14 오후 6:24:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<박형순>
-- Create date: <2022-07-12>
-- Description:	<품목별 수입검사 리스트 조회>
-- =============================================
ALTER PROCEDURE [dbo].[55MM_InspListByROH_S]

	@PLANTCODE		VARCHAR(10)
   ,@ITEMCODE		VARCHAR(20)
   ,@INSPCODE		VARCHAR(10)

   ,@LANG			VARCHAR(10) = 'KO'
   ,@RS_CODE		VARCHAR(1) OUTPUT
   ,@RS_MSG			VARCHAR(100) OUTPUT


AS
BEGIN

	 SELECT PLANTCODE					AS	PLANTCODE
		   ,ITEMCODE					AS	ITEMCODE
		   ,INSPCODE					AS	INSPCODE
		   ,REMARK						AS	REMARK	
		   ,USEFLAG						AS	USEFLAG	
		   ,MAKEDATE					AS	MAKEDATE
		   ,DBO.FN_WORKERNAME(MAKER)	AS	MAKER
		   ,EDITDATE					AS	EDITDATE
		   ,DBO.FN_WORKERNAME(EDITOR)	AS	EDITOR

	 FROM	TB_INSPLISTBYROH

	 WHERE PLANTCODE	LIKE '%' + @PLANTCODE
	 AND	ITEMCODE	LIKE '%' + @ITEMCODE
	 AND	INSPCODE	LIKE '%' + @INSPCODE + '%'


END


SELECT INSPNAME
FROM TB_IQIMASTER