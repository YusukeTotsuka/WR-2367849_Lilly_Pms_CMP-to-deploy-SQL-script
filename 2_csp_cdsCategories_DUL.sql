/** $Workfile: csp_cdsCategories_DUL_build.sql $
**
** Copyright(c) 2016, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
******************************************************************************
** Author: Yusuke Totsuka
** Creation Date: 23-June-2016
** Work Request: 2367849
** URL: lilly-pms.mdsol.com
** Description: Creates temp data for Rave-PCV integration for DUL study.  
**				This script will be scheduled to execute every 2 hours.
** Changes:
******************************************************************************/

IF object_id('dbo.csp_cdsCategories_DUL') is not null
    DROP PROCEDURE dbo.csp_cdsCategories_DUL
GO

Create PROCEDURE csp_cdsCategories_DUL(@UserID int )
AS   
BEGIN  

 SET NOCOUNT ON
 select * from c_cdsCategories_DUL ORDER BY 4,1  
END  
  

GO





---------WEBSERVICE DATASET CONFIGURATION STARTS HERE
----Perform inserts/updates
declare	@Error_Number int, @Error_Message nvarchar(2000), @dt datetime	   
select @Error_Number = 0, @dt = GETUTCDATE()

begin transaction
begin try	
/*Backup the WebServicesConfigurableDataset tables*/
-----=====================================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' 
AND name = 'BK_WR_2367849_WebServicesConfigurableDatasetConfiguration')
BEGIN
	CREATE TABLE BK_WR_2367849_WebServicesConfigurableDatasetConfiguration 
	(
	[ConfigurationId] [int] ,
	[DatasetName] [nvarchar](2000) ,
	[Created] [datetime] ,
	[Updated] [datetime] ,
	[BackupDate] [datetime]
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' 
AND name = 'BK_WR_2367849_WebServicesConfigurableDatasetObjects')
BEGIN
	CREATE TABLE BK_WR_2367849_WebServicesConfigurableDatasetObjects 
	(
	[ConfigurableDatasetObjectId] [int] ,
	[DatabaseObject] [nvarchar](2000),
	[Name] [nvarchar](2000) ,
	[DatabaseObjectType] [int],
	[RequiresUserFiltering] [bit],
	[Sequence] [int] ,
	[ConfigurationId] [int] ,
	[Created] [datetime],
	[Updated] [datetime] ,
	[BackupDate] [datetime]
	)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' 
AND name = 'BK_WR_2367849_WebServicesConfigurableDatasetFormats')
BEGIN
	CREATE TABLE BK_WR_2367849_WebServicesConfigurableDatasetFormats
	(
	[ConfigurableDatasetFormatId] [int] ,
    [FormatName] [varchar](max) ,
    [Header] [varchar](max) ,
    [RowTemplate] [varchar](max) ,
    [Footer] [varchar](max) , 
	[ConfigurationId] [int] ,
    [FormatTypeId]	[int] ,
	[Created] [datetime],
	[Updated] [datetime] ,
    [ContentType]	[nvarchar](400),
  	[BackupDate] [datetime]
	)
END

--- backup tables
INSERT INTO BK_WR_2367849_WebServicesConfigurableDatasetConfiguration
(
	[ConfigurationId] ,
	[DatasetName]  ,
	[Created]  ,
	[Updated] ,
	[BackupDate] 
)
SELECT
	[ConfigurationId] ,
	[DatasetName]  ,
	[Created]  ,
	[Updated] ,
	@dt 
from WebServicesConfigurableDatasetConfiguration


INSERT INTO BK_WR_2367849_WebServicesConfigurableDatasetObjects
(
	[ConfigurableDatasetObjectId] ,
	[DatabaseObject] ,
	[Name]  ,
	[DatabaseObjectType] ,
	[RequiresUserFiltering],
	[Sequence] ,
	[ConfigurationId]  ,
	[Created] ,
	[Updated] ,
	[BackupDate] 
)
SELECT
	[ConfigurableDatasetObjectId] ,
	[DatabaseObject] ,
	[Name]  ,
	[DatabaseObjectType] ,
	[RequiresUserFiltering],
	[Sequence] ,
	[ConfigurationId]  ,
	[Created] ,
	[Updated] ,
	@dt 
from WebServicesConfigurableDatasetObjects 

INSERT INTO BK_WR_2367849_WebServicesConfigurableDatasetFormats
(
	[ConfigurableDatasetFormatId] ,
	[FormatName] ,
	[Header]  ,
	[RowTemplate] ,
	[Footer],
	[ConfigurationId] ,
	[FormatTypeId]  ,
	[Created] ,
	[Updated] ,
    [ContentType],
	[BackupDate] 
)
SELECT
	[ConfigurableDatasetFormatId] ,
	[FormatName] ,
	[Header]  ,
	[RowTemplate] ,
	[Footer],
	[ConfigurationId] ,
	[FormatTypeId]  ,
	[Created] ,
	[Updated] ,
        [ContentType],
	@dt 
from WebServicesConfigurableDatasetFormats


-----=====================================================

-- 2) make entry into WebServicesConfigurableDatasetConfiguration
      declare @configID int set @configID = 0
      declare @DatasetName nvarchar(2000) set @DatasetName = 'cdsCategories_DUL'
      declare @DatabaseObjectName nvarchar(2000) 
      set @DatabaseObjectName = 'csp_cdsCategories_DUL'
      declare @RequiresUserFiltering int set @RequiresUserFiltering = 1
      
      select @configID = ConfigurationId 
      from dbo.WebServicesConfigurableDatasetConfiguration 
      where DatasetName = @DatasetName      
      if @configID = 0
      begin
        insert dbo.[WebServicesConfigurableDatasetConfiguration]
           ([DatasetName],[created],[updated])
        values (@DatasetName, @dt, @dt)
        set @configID = @@identity
      end
      else
      begin
        update dbo.[WebServicesConfigurableDatasetConfiguration] set
          [DatasetName] = @DatasetName,[Updated] = @dt
        where @configID = ConfigurationId 
      end
      
-- 3) make entry into dbo.WebServicesConfigurableDatasetObjects
     declare @ObjectId int set @ObjectId = 0
     
     select @ObjectId = ConfigurableDatasetObjectId 
     from dbo.WebServicesConfigurableDatasetObjects
     where @DatabaseObjectName = DatabaseObject and @configID = ConfigurationId           
      
      if @ObjectId = 0
      begin
        insert dbo.[WebServicesConfigurableDatasetObjects]
           ([DatabaseObject], [DatabaseObjectType], [RequiresUserFiltering], 
           [Sequence], [ConfigurationId], [Name], [created], [updated])
        values (@DatabaseObjectName, 2, @RequiresUserFiltering, 1, 
			@configID, @DatabaseObjectName, @dt, @dt)
        set @ObjectId = @@identity
      end
      else
      begin
        update dbo.WebServicesConfigurableDatasetObjects set
           [DatabaseObject] = @DatabaseObjectName, [DatabaseObjectType] = 2
          ,[RequiresUserFiltering] = @RequiresUserFiltering,[Sequence] = 1
          ,[ConfigurationId]=@configID,[Name] = @DatabaseObjectName
          ,[Updated] = @dt
        where @ObjectId = ConfigurableDatasetObjectId                 
      end
     

  -- 4) make entry into dbo.WebServicesConfigurableDatasetFormats
     Declare @formatID int set @formatID = 0
     --Declare @formatTypeID int set @formatTypeID = 1 
     Declare @formatTypeID int set @formatTypeID = 2 -- use 2 as default. dot liquid      
     declare @FormatName nvarchar(2000) set @FormatName = 'csv' 
     declare @ContentType nvarchar(100) set @ContentType = 'text/csv; charset=utf-8'
     declare @Header nvarchar(max) set @Header = null
     declare @Footer varchar(1000) set @Footer = null
     declare @RowTemplate nvarchar(max) 
	 declare @PVCInfo nvarchar(50)
	 
     /*Takako 11Sep2012 - Do not display dummy columns for Category 30 and 40*/
     set @RowTemplate = '{% if document.section == "header" %}"'+'PMW Status"'+CHAR(13)+CHAR(10)+ '{{ request.Date | date:''yyyyMMdd''}}' + CHAR(13)+CHAR(10)+'"01","PMS-TLC-Dul","PMS-TLC-Dul","","","1"' +CHAR(13)+CHAR(10)+ '"15_title","ps04apno","ps04uniq","ps04idat","ps04iuid","ps04udat","ps04uuid","ps04prot","ps04mcod","ps04apno","ps04uniq","ps04mfid","ps04mfnm","ps04huno","ps04huid","ps04hudt","ps04creq","ps04ccon","ps04cdnm","ps04cdcd"'+CHAR(13)+CHAR(10)+ '"30_title","ps04apno","ps04uniq","ps06arno","ps06idat","ps06iuid","ps06udat","ps06uuid","ps06prot","ps06mcod","ps06uniq","ps06arno","ps06prno","ps06usid","ps06pini","ps06nam1","ps06nam2","ps06psex","ps06pbrt","ps06brtg","ps06brty","ps06brtm","ps06brtd","ps06pkrt","ps06pkr2","ps06ppsd","ps06pped","ps06stat","ps06entd","ps06sino","ps06grop","ps06nenr","ps06jyog","ps06idcm","ps06type","ps06fflg","drcd","touyo","drnm"'+CHAR(13)+CHAR(10)+ '"40_title","ps04apno","ps04uniq","ps06arno","ps07idat","ps07iuid","ps07udat","ps07uuid","ps07prot","ps07mcod","ps07uniq","ps07prno","ps07usid","ps07pcnt","ps07revi","ps07cldt","ps07uabd","ps07uabl","ps07drst","ps07mkst","ps07uflg","ps07nflg","ps07vist","ps07scnt","ps07ltdt","ps07stat","ps07fist","ps07kari","ps07stop","ps07stre","ps07huno","ps07iidd","ps07imdd","ps07iidm","ps07imdm","ps07teki","ps07mlid","ps07mldt","ps07clid","ps07cld2","ps07uaid","ps07uab2","ps07kaid","ps07kar2","ps07spdt","ps07kisa","ps07mnam","ps07drcd","ps07mfid","ps07mfnm","ps07mkcd","ps07mknm","ps07dnam","ps07tdcd","ps07tmid","ps07tmnm","ps07tkcd","ps07tknm","ps07smai","ps07dldt","ps07dsnd","ps07mreq","ps07kcnt","ps07erru","ps07mcf2","ps07mci2","ps07mc2m","ps07mff2","ps07mfi2","ps07mf2m","ps07aeno","ps07fdat","ps07fuid","ps07ndsp","ps07frno","drcd","drnm"'+CHAR(13)+CHAR(10)+ '"50_title","ps04apno","ps04uniq","ps06arno","ps22idat","ps22iuid","ps22udat","ps22uuid","ps22prot","ps22uniq","ps22prno","ps22vist","ps22seqn","ps22mreq","ps22dcfm","ps22dsnd","ps22mcfm","ps22lgdt","ps22case","ps22sddr","ps22mkrq","ps22dcid","ps22mcid","ps22lgid","ps22mcf2","ps22mci2","ps22cmnt","ps22pdfc","ps22sddm","ps22mkrm","ps22dcnm","ps22mcnm","ps22lgnm","ps22mc2m","ps22sdid","ps22sdnm","ps22sddt","ps22frdt","ps22frid","ps22ksfg","ps22infs","ps22infd","drcd","drnm"'+CHAR(13)+CHAR(10)+ '{% endif %}{% if document.section == "body" %}"{{current.Title| replace:''"'',''""''}}","{{current.Col_01| replace:''"'',''""''}}","{{current.Col_02| replace:''"'',''""''}}","{{current.Col_03| replace:''"'',''""''}}","{{current.Col_04| replace:''"'',''""''}}","{{current.Col_05| replace:''"'',''""''}}","{{current.Col_06| replace:''"'',''""''}}","{{current.Col_07| replace:''"'',''""''}}","{{current.Col_08| replace:''"'',''""''}}","{{current.Col_09| replace:''"'',''""''}}","{{current.Col_10| replace:''"'',''""''}}","{{current.Col_11| replace:''"'',''""''}}","{{current.Col_12| replace:''"'',''""''}}","{{current.Col_13| replace:''"'',''""''}}","{{current.Col_14| replace:''"'',''""''}}","{{current.Col_15| replace:''"'',''""''}}","{{current.Col_16| replace:''"'',''""''}}","{{current.Col_17| replace:''"'',''""''}}","{{current.Col_18| replace:''"'',''""''}}","{{current.Col_19| replace:''"'',''""''}}"{% if current.Title == "30" or current.Title == "40" or current.Title == "50" %},"{{current.Col_20| replace:''"'',''""''}}","{{current.Col_21| replace:''"'',''""''}}","{{current.Col_22| replace:''"'',''""''}}","{{current.Col_23| replace:''"'',''""''}}","{{current.Col_24| replace:''"'',''""''}}","{{current.Col_25| replace:''"'',''""''}}","{{current.Col_26| replace:''"'',''""''}}","{{current.Col_27| replace:''"'',''""''}}","{{current.Col_28| replace:''"'',''""''}}","{{current.Col_29| replace:''"'',''""''}}","{{current.Col_30| replace:''"'',''""''}}","{{current.Col_31| replace:''"'',''""''}}","{{current.Col_32| replace:''"'',''""''}}","{{current.Col_33| replace:''"'',''""''}}","{{current.Col_34| replace:''"'',''""''}}","{{current.Col_35| replace:''"'',''""''}}","{{current.Col_36| replace:''"'',''""''}}","{{current.Col_37| replace:''"'',''""''}}","{{current.Col_38| replace:''"'',''""''}}"{% endif %}{% if current.Title == "40" or current.Title == "50" %},"{{current.Col_39| replace:''"'',''""''}}","{{current.Col_40| replace:''"'',''""''}}","{{current.Col_41| replace:''"'',''""''}}","{{current.Col_42| replace:''"'',''""''}}","{{current.Col_43| replace:''"'',''""''}}"{% endif %}{% if current.Title == "40" %},"{{current.Col_44| replace:''"'',''""''}}","{{current.Col_45| replace:''"'',''""''}}","{{current.Col_46| replace:''"'',''""''}}","{{current.Col_47| replace:''"'',''""''}}","{{current.Col_48| replace:''"'',''""''}}","{{current.Col_49| replace:''"'',''""''}}","{{current.Col_50| replace:''"'',''""''}}","{{current.Col_51| replace:''"'',''""''}}","{{current.Col_52| replace:''"'',''""''}}","{{current.Col_53| replace:''"'',''""''}}","{{current.Col_54| replace:''"'',''""''}}","{{current.Col_55| replace:''"'',''""''}}","{{current.Col_56| replace:''"'',''""''}}","{{current.Col_57| replace:''"'',''""''}}","{{current.Col_58| replace:''"'',''""''}}","{{current.Col_59| replace:''"'',''""''}}","{{current.Col_60| replace:''"'',''""''}}","{{current.Col_61| replace:''"'',''""''}}","{{current.Col_62| replace:''"'',''""''}}","{{current.Col_63| replace:''"'',''""''}}","{{current.Col_64| replace:''"'',''""''}}","{{current.Col_65| replace:''"'',''""''}}","{{current.Col_66| replace:''"'',''""''}}","{{current.Col_67| replace:''"'',''""''}}","{{current.Col_68| replace:''"'',''""''}}","{{current.Col_69| replace:''"'',''""''}}","{{current.Col_70| replace:''"'',''""''}}","{{current.Col_71| replace:''"'',''""''}}","{{current.Col_72| replace:''"'',''""''}}","{{current.Col_73| replace:''"'',''""''}}","{{current.Col_74| replace:''"'',''""''}}","{{current.Col_75| replace:''"'',''""''}}","{{current.Col_76| replace:''"'',''""''}}"{% endif %}'+CHAR(13)+CHAR(10)+ '{% endif %}'     
     select @formatID = ConfigurableDatasetFormatId from WebServicesConfigurableDatasetFormats 
     where @FormatName = FormatName and @configID = ConfigurationId      
     if @formatID = 0
     begin
       INSERT INTO [WebServicesConfigurableDatasetFormats]
           ([FormatName], [Header], [RowTemplate], [Footer], [ConfigurationId],[FormatTypeId],[created],[updated],[ContentType])
       VALUES (@FormatName, @Header, @RowTemplate, @Footer, @ConfigId, @formatTypeID,@dt,@dt,@ContentType)
        set @formatID = @@identity
     end
     else
     begin
       update WebServicesConfigurableDatasetFormats set
          [FormatName] =@FormatName, [Header] = @Header, [RowTemplate] = @RowTemplate, [Footer] =@Footer
         ,[ConfigurationId] = @ConfigId,[FormatTypeId] = @formatTypeID
         ,[Updated] = @dt, [ContentType] = @ContentType
        where @formatID = ConfigurableDatasetFormatId 
                
     end
end try

begin catch
	select @Error_Number = error_number()
	select @Error_Message = error_message()
end catch

if @Error_Number = 0
	commit transaction
else
begin
	rollback transaction
	print @Error_Message
end

