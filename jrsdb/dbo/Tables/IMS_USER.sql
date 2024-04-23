﻿CREATE TABLE [dbo].[IMS_USER] (
    [IMS_USER_UID]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IMS_USER_CREATION_DATE] DATETIME         DEFAULT (getdate()) NULL,
    [IMS_USER_LOCALE]        VARCHAR (10)     DEFAULT ('en') NOT NULL,
    [IMS_USER_USERNAME]      VARCHAR (25)     NULL,
    [IMS_USER_PASSWORD]      VARCHAR (64)     NULL,
    [IMS_USER_REFRESH_TOKEN] NVARCHAR (100)   NULL,
    PRIMARY KEY CLUSTERED ([IMS_USER_UID] ASC)
);




