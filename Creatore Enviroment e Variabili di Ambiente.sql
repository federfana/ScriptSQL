 
 --------- dichiaro le variabili dell'ambiente sorgente
declare @environment_name_src as nvarchar(255) = N'GatewayOrchestrator_ODS'
declare @folder_name_src as nvarchar(255) = N'SystemIntegration'
declare @name sysname, 
    @sensitive bit, 
    @description nvarchar(1024), 
    @value sql_variant, 
    @type nvarchar(128)
 
 --------- dichiaro le variabili dell'ambiente destinazione
declare @environment_name_dst as nvarchar(255) = N'GatewayOrchestrator_test'
declare @folder_name_dst as nvarchar(255) = N'SystemIntegration'
declare @environment_description as nvarchar(255) = N'descrizione'
 
----- creo l'ambiente nuovo
 --EXEC [SSISDB].[catalog].create_environment @folder_name=@folder_name_dst, 
 --       @environment_name=@environment_name_dst,
 --      @environment_description = @environment_description

--- copio le var dal vecchio al nuovo
 DECLARE cur CURSOR FOR
	Select v.name, v.sensitive, v.description,v.value, v.type 
	from [SSISDB].[catalog].environment_variables  v
	inner JOIN [SSISDB].[catalog].environments e on e.environment_id = v.environment_id
	inner join [SSISDB].[catalog].folders f on f.folder_id = e.folder_id
	where  f.name =@folder_name_src and e.name=@environment_name_src

OPEN cur
FETCH NEXT FROM cur INTO @name, @sensitive, @description, @value, @type

-- print '----'
--print 'creo l''ambiente ' 
--print 'EXEC [SSISDB].[catalog].create_environment @folder_name='+@folder_name_dst +', @environment_name='+@environment_name_dst +', @environment_description ='+ @environment_description

 
WHILE (@@FETCH_STATUS = 0)
    BEGIN
        --PRINT 'IF NOT EXISTS (SELECT 1 FROM [SSISDB].[catalog].[environment_variables] WHERE environment_id = @environment_id AND name = N''' + @name + ''')
		--EXEC [SSISDB].[catalog].[create_environment_variable] 
		--				@variable_name=  @name  , 
		--				@sensitive= @sensitive , 
		--				@description= @description, 
		--				@environment_name= @environment_name_dst ,
		--				@folder_name=  @folder_name_dst, 
		--				@value=@value, 
		--				@data_type= @type
 
		
       print 'EXEC [SSISDB].[catalog].[create_environment_variable] 
						@variable_name= '''+ @name +'''  , @sensitive= '''+convert(varchar,@sensitive) +''' , @description='''+ @description +''', @environment_name= '''+@environment_name_dst +''',
						@folder_name=  '''+@folder_name_dst +''', @value=N'''+convert(varchar(max),@value)+''', @data_type='''+ @type+''''
	 
    FETCH NEXT FROM cur INTO @name, @sensitive, @description, @value, @type
    END
 --print '---- END ----'
CLOSE cur
DEALLOCATE cur