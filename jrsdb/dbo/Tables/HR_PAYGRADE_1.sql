﻿CREATE TABLE [dbo].[HR_PAYGRADE] (
    [HR_PAYGRADE_ID]         INT             IDENTITY (1, 1) NOT NULL,
    [HR_PAYGRADE_DESCR]      NVARCHAR (2500) NOT NULL,
    [HR_PAYGRADE_AMOUNT_MIN] DECIMAL (18, 2) NOT NULL,
    [HR_PAYGRADE_AMOUNT_MAX] DECIMAL (18, 2) NULL,
    PRIMARY KEY CLUSTERED ([HR_PAYGRADE_ID] ASC)
);

