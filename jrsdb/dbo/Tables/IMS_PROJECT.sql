﻿CREATE TABLE [dbo].[IMS_PROJECT] (
    [IMS_PROJECT_ID]          INT           IDENTITY (1, 1) NOT NULL,
    [IMS_PROJECT_CODE]        VARCHAR (10)  NULL,
    [IMS_PROJECT_DESCRIPTION] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_IMS_PROJECT] PRIMARY KEY CLUSTERED ([IMS_PROJECT_ID] ASC)
);
