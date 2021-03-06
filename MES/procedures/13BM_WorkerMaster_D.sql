USE [DC_EDU_SH]
GO
/****** Object:  StoredProcedure [dbo].[13BM_WorkerMaster_D]    Script Date: 2022-06-30 오후 3:59:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이기수
-- Create date: 2022.06.30
-- Description:	작업자 내역 삭제
-- =============================================
ALTER PROCEDURE [dbo].[13BM_WorkerMaster_D]
	@PLANTCODE			VARCHAR(10) -- 공장
  , @WORKERID			VARCHAR(20) -- 작업자 ID

  , @LANG				VARCHAR(10) = 'KO'
  , @RS_CODE			VARCHAR(1)   OUTPUT
  , @RS_MSG				VARCHAR(100) OUTPUT
  
AS
BEGIN

	DELETE TB_WorkerList
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKERID;

	SET @RS_CODE = 'S';
	SET @RS_MSG = '정상 작동';

END
