USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[55MM_InspListByROH_I]    Script Date: 2022-07-14 오후 6:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<박형순>
-- Create date: <2022-07-13>
-- Description:	<품목별 수입검사 항목 입력>
-- =============================================
ALTER PROCEDURE [dbo].[55MM_InspListByROH_I]
		@PLANTCODE	VARCHAR(10)
	   ,@ITEMCODE 	VARCHAR(20)
	   ,@INSPCODE 	VARCHAR(10)
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

IF( @ITEMCODE = (SELECT INSPCODE FROM TB_INSPLISTBYROH WHERE ITEMCODE = @ITEMCODE
												       AND   INSPCODE = @INSPCODE))
BEGIN
	SET @RS_MSG = '이미 등록된 검사항목 입니다.'
	SET @RS_CODE = 'E'
	RETURN
END

INSERT INTO TB_INSPLISTBYROH(PLANTCODE,		ITEMCODE,	INSPCODE,	REMARK,	USEFLAG,				MAKER,		MAKEDATE)
		VALUES				(@PLANTCODE,	@ITEMCODE,	@INSPCODE,	@REMARK,ISNULL(@USEFLAG,'Y')	,@WORKERID	,@LD_NOWDATE	)


		SET @RS_CODE = 'S'

END
