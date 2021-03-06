
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Max Hutchinson>
-- Create date: 02/02/2018
-- Description:	<Notify of failed routine whilst allowing other routines to continue>
-- Last Modified By: 	<Max Hutchinson>
-- Last Modified Date: 	<018/02/2018>
-- Last Modified Desc: 	<Fixed up Wording>
-- Prerequisite: 
-- =============================================

CREATE procedure [dbo].[SP-Process-failure]
@err_msg as varchar(2000),
@failed_sp as varchar(500),
@send_to as varchar(200) = null
as

	declare @default_email varchar(100) = (select default_send_from from dbo.sys_system);
	declare @sysadmin_email varchar(100) = (select sysadmin_email from dbo.sys_system);

	if @send_to is null set @send_to = @sysadmin_email --'max.hutchinson258@gmail.co.uk';

	declare @msg_body as varchar(max);

	set @msg_body = 'Stored procedure ' + @failed_sp + ' failed with error "' + @err_msg + '"';

	EXEC msdb.dbo.sp_send_dbmail @from_address = @default_email,
		@profile_name = 'MailProfile',
		@recipients = @send_to,
		@body = @msg_body,  
		@subject = 'Stored Procedure Failure',
		@body_format = 'Text',
		@reply_to = @default_email;

