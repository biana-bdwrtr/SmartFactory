USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_InspListByROH_U]    Script Date: 2022-07-14 오후 6:27:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<박형순>
-- Create date: <2022-07-13>
-- Description:	<품목별 수입검사 항목 수정>
-- =============================================
ALTER PROCEDURE [dbo].[55MM_InspListByROH_U]
		@PLANTCODE	VARCHAR(10)
	   ,@ITEMCODE 	VARCHAR(20)
	   --,@INSPCODE 	VARCHAR(10)
	   ,@REMARK   	VARCHAR(200)
	   ,@USEFLAG  	VARCHAR(1)
	   ,@WORKERID	VARCHAR(10)

       ,@LANG		VARCHAR(10)  = 'KO'
       ,@RS_CODE	VARCHAR(1)   OUTPUT
       ,@RS_MSG		VARCHAR(100) OUTPUT
AS
BEGIN

	DECLARE @LD_NOWDATE DATETIME     -- 프로시져 실행 일시
	       ,@LS_NOWDATE VARCHAR(10)  -- 프로시져 실핼 일자.
	    SET @LD_NOWDATE = GETDATE();
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23);

UPDATE	TB_INSPLISTBYROH		
SET		--INSPCODE	=	@INSPCODE
		REMARK		=	@REMARK
	,	USEFLAG		=	@USEFLAG
	,	EDITOR		=	@WORKERID
	,	EDITDATE	=	@LD_NOWDATE
WHERE	ITEMCODE	=	@ITEMCODE

	SET @RS_CODE	=	'S'

END
