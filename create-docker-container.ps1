docker run `
-e MSSQL_PID=Developer `
-e "ACCEPT_EULA=Y" `
-e "ACCEPT_EULA_ML=Y" `
-e "MSSQL_SA_PASSWORD=1qaz2wsx@@" `
-p 1433:1433 `
--name sqlserverdev `
--env MSSQL_AGENT_ENABLED=True `
-d mcr.microsoft.com/mssql/server:2022-latest