USE [AppDev_SH]
GO
/****** Object:  StoredProcedure [dbo].[13SP_STANDARD_S]    Script Date: 2022-06-28 ���� 5:26:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		�̱��
-- Create date: 2022.06.28
-- Description:	�����ڵ� ����
-- =============================================
CREATE PROCEDURE [dbo].[13SP_STANDARD_D]
--ALTER PROCEDURE [dbo].[13SP_STANDARD_S]
	@MAJORCODE		VARCHAR(10), -- ���ڵ�
	@MINORCODE		VARCHAR(20)  -- ���ڵ�
AS
BEGIN
	DELETE TB_Standard 
     WHERE MAJORCODE = @MAJORCODE
	   AND MINORCODE = @MINORCODE;
END
