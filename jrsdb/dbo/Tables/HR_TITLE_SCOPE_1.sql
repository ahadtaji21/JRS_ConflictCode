﻿CREATE TABLE [dbo].[HR_TITLE_SCOPE] (
    [HR_TITLE_SCOPE_ID]    INT             IDENTITY (1, 1) NOT NULL,
    [HR_TITLE_SCOPE_DESCR] NVARCHAR (2500) NOT NULL,
    PRIMARY KEY CLUSTERED ([HR_TITLE_SCOPE_ID] ASC)
);
