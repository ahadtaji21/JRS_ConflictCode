﻿CREATE TABLE [dbo].[IMS_USER_ROLE] (
    [IMS_USER_ROLE_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [IMS_USER_ROLE_CODE]  VARCHAR (25)   NOT NULL,
    [IMS_USER_ROLE_DESCR] NVARCHAR (250) NOT NULL,
    PRIMARY KEY CLUSTERED ([IMS_USER_ROLE_ID] ASC),
    UNIQUE NONCLUSTERED ([IMS_USER_ROLE_CODE] ASC)
);

