create database idlife;
GO

use idlife;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[NameSuffix] [nvarchar](50) NOT NULL,
	[Company] [nvarchar](50) NOT NULL,
	[CustomerTypeID] [int] NOT NULL,
	[CustomerStatusID] [int] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[Phone2] [nvarchar](20) NOT NULL,
	[MobilePhone] [nvarchar](20) NOT NULL,
	[Fax] [nvarchar](20) NOT NULL,
	[MainAddress1] [nvarchar](100) NOT NULL,
	[MainAddress2] [nvarchar](100) NULL,
	[MainAddress3] [nvarchar](100) NOT NULL,
	[MainCity] [nvarchar](50) NOT NULL,
	[MainState] [nvarchar](50) NOT NULL,
	[MainZip] [nvarchar](50) NOT NULL,
	[MainCountry] [nvarchar](50) NOT NULL,
	[MainCounty] [nvarchar](50) NOT NULL,
	[MainVerified] [bit] NOT NULL,
	[MailAddress1] [nvarchar](100) NOT NULL,
	[MailAddress2] [nvarchar](100) NULL,
	[MailAddress3] [nvarchar](100) NOT NULL,
	[MailCity] [nvarchar](50) NOT NULL,
	[MailState] [nvarchar](50) NOT NULL,
	[MailZip] [nvarchar](50) NOT NULL,
	[MailCountry] [nvarchar](50) NOT NULL,
	[MailCounty] [nvarchar](50) NOT NULL,
	[MailVerified] [bit] NOT NULL,
	[OtherAddress1] [nvarchar](100) NOT NULL,
	[OtherAddress2] [nvarchar](100) NULL,
	[OtherAddress3] [nvarchar](100) NOT NULL,
	[OtherCity] [nvarchar](50) NOT NULL,
	[OtherState] [nvarchar](50) NOT NULL,
	[OtherZip] [nvarchar](50) NOT NULL,
	[OtherCountry] [nvarchar](50) NOT NULL,
	[OtherCounty] [nvarchar](50) NOT NULL,
	[OtherVerified] [bit] NOT NULL,
	[CanLogin] [bit] NOT NULL,
	[LoginName] [nvarchar](100) NULL,
	[PasswordHash] [varbinary](50) NULL,
	[RankID] [int] NULL,
	[EnrollerID] [int] NULL,
	[SponsorID] [int] NULL,
	[BirthDate] [datetime] NULL,
	[CurrencyCode] [nvarchar](3) NOT NULL,
	[PayableToName] [nvarchar](50) NOT NULL,
	[DefaultWarehouseID] [int] NULL,
	[PayableTypeID] [int] NOT NULL,
	[CheckThreshold] [money] NOT NULL,
	[LanguageID] [int] NULL,
	[Gender] [nvarchar](1) NOT NULL,
	[TaxCode] [nvarchar](50) NULL,
	[TaxCodeTypeID] [int] NOT NULL,
	[IsSalesTaxExempt] [bit] NOT NULL,
	[SalesTaxCode] [nvarchar](50) NULL,
	[SalesTaxExemptExpireDate] [datetime] NULL,
	[VatRegistration] [nvarchar](50) NOT NULL,
	[BinaryPlacementTypeID] [int] NOT NULL,
	[UseBinaryHoldingTank] [bit] NOT NULL,
	[IsInBinaryHoldingTank] [bit] NOT NULL,
	[IsEmailSubscribed] [bit] NULL,
	[EmailSubscribeIP] [nvarchar](50) NULL,
	[IsSMSSubscribed] [bit] NULL,
	[Notes] [nvarchar](max) NULL,
	[Field1] [nvarchar](100) NOT NULL,
	[Field2] [nvarchar](100) NOT NULL,
	[Field3] [nvarchar](100) NOT NULL,
	[Field4] [nvarchar](100) NOT NULL,
	[Field5] [nvarchar](100) NOT NULL,
	[Field6] [nvarchar](100) NOT NULL,
	[Field7] [nvarchar](100) NOT NULL,
	[Field8] [nvarchar](100) NOT NULL,
	[Field9] [nvarchar](100) NOT NULL,
	[Field10] [nvarchar](100) NOT NULL,
	[Field11] [nvarchar](100) NOT NULL,
	[Field12] [nvarchar](100) NOT NULL,
	[Field13] [nvarchar](100) NOT NULL,
	[Field14] [nvarchar](100) NOT NULL,
	[Field15] [nvarchar](100) NOT NULL,
	[Date1] [datetime] NULL,
	[Date2] [datetime] NULL,
	[Date3] [datetime] NULL,
	[Date4] [datetime] NULL,
	[Date5] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](30) NOT NULL,
	[ModifiedBy] [nvarchar](30) NOT NULL,
	[EmailUnsubscribeDate] [datetime] NULL,
	[EmailSubscribeDate] [datetime] NULL,
	[SMSSubscribeDate] [datetime] NULL,
	[SMSUnsubscribeDate] [datetime] NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customers_CustomerStatusID] ON [dbo].[Customers]
(
	[CustomerStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customers_CustomerTypeID] ON [dbo].[Customers]
(
	[CustomerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customers_EnrollerID] ON [dbo].[Customers]
(
	[EnrollerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Customers_LoginName] ON [dbo].[Customers]
(
	[LoginName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerSites](
	[CustomerID] [int] NOT NULL,
	[WebAlias] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Company] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](100) NOT NULL,
	[Phone2] [nvarchar](100) NOT NULL,
	[Fax] [nvarchar](100) NOT NULL,
	[Address1] [nvarchar](200) NOT NULL,
	[Address2] [nvarchar](200) NOT NULL,
	[City] [nvarchar](100) NOT NULL,
	[State] [nvarchar](100) NOT NULL,
	[Zip] [nvarchar](100) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Notes1] [nvarchar](max) NOT NULL,
	[Notes2] [nvarchar](max) NOT NULL,
	[Notes3] [nvarchar](max) NOT NULL,
	[Notes4] [nvarchar](max) NOT NULL,
	[Url1] [nvarchar](200) NOT NULL,
	[Url2] [nvarchar](200) NOT NULL,
	[Url3] [nvarchar](200) NOT NULL,
	[Url4] [nvarchar](200) NOT NULL,
	[Url5] [nvarchar](200) NOT NULL,
	[Url6] [nvarchar](200) NOT NULL,
	[Url7] [nvarchar](200) NOT NULL,
	[Url8] [nvarchar](200) NOT NULL,
	[Url9] [nvarchar](200) NOT NULL,
	[Url10] [nvarchar](200) NOT NULL,
	[Url1Description] [nvarchar](200) NOT NULL,
	[Url2Description] [nvarchar](200) NOT NULL,
	[Url3Description] [nvarchar](200) NOT NULL,
	[Url4Description] [nvarchar](200) NOT NULL,
	[Url5Description] [nvarchar](200) NOT NULL,
	[Url6Description] [nvarchar](200) NOT NULL,
	[Url7Description] [nvarchar](200) NOT NULL,
	[Url8Description] [nvarchar](200) NOT NULL,
	[Url9Description] [nvarchar](200) NOT NULL,
	[Url10Description] [nvarchar](200) NOT NULL,
	[DataImage1] [varbinary](max) NULL,
	[DataImageType1] [nvarchar](200) NULL,
	[DataImage2] [varbinary](max) NULL,
	[DataImageType2] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerSites] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_CustomerSites_WebAlias] ON [dbo].[CustomerSites]
(
	[WebAlias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerAccounts](
	[CustomerID] [int] NOT NULL,
	[PrimaryCreditCardDisplay] [nvarchar](50) NULL,
	[PrimaryExpirationMonth] [int] NULL,
	[PrimaryExpirationYear] [int] NULL,
	[PrimaryCreditCardTypeID] [int] NOT NULL,
	[PrimaryBillingName] [nvarchar](50) NOT NULL,
	[PrimaryBillingAddress] [nvarchar](100) NULL,
	[PrimaryBillingAddress2] [nvarchar](100) NULL,
	[PrimaryBillingCity] [nvarchar](50) NULL,
	[PrimaryBillingState] [nvarchar](50) NULL,
	[PrimaryBillingZip] [nvarchar](50) NULL,
	[PrimaryBillingCountry] [nvarchar](50) NULL,
	[SecondaryCreditCardDisplay] [nvarchar](50) NULL,
	[SecondaryExpirationMonth] [int] NULL,
	[SecondaryExpirationYear] [int] NULL,
	[SecondaryCreditCardTypeID] [int] NOT NULL,
	[SecondaryBillingName] [nvarchar](50) NOT NULL,
	[SecondaryBillingAddress] [nvarchar](100) NULL,
	[SecondaryBillingAddress2] [nvarchar](100) NULL,
	[SecondaryBillingCity] [nvarchar](50) NULL,
	[SecondaryBillingState] [nvarchar](50) NULL,
	[SecondaryBillingZip] [nvarchar](50) NULL,
	[SecondaryBillingCountry] [nvarchar](50) NULL,
	[BankAccountNumber] [nvarchar](50) NULL,
	[BankRoutingNumber] [nvarchar](50) NOT NULL,
	[BankNameOnAccount] [nvarchar](50) NOT NULL,
	[BankAccountAddress] [nvarchar](100) NULL,
	[BankAccountCity] [nvarchar](50) NULL,
	[BankAccountState] [nvarchar](50) NULL,
	[BankAccountZip] [nvarchar](50) NULL,
	[BankAccountCountry] [nvarchar](50) NULL,
	[DriversLicenseNumber] [nvarchar](50) NOT NULL,
	[DepositNameOnAcount] [nvarchar](50) NOT NULL,
	[DepositAccountNumber] [nvarchar](50) NOT NULL,
	[DepositRoutingNumber] [nvarchar](50) NOT NULL,
	[Iban] [nvarchar](50) NOT NULL,
	[SwiftCode] [nvarchar](50) NOT NULL,
	[DepositBankName] [nvarchar](100) NOT NULL,
	[DepositBankAddress] [nvarchar](250) NOT NULL,
	[DepositBankCity] [nvarchar](50) NOT NULL,
	[DepositBankState] [nvarchar](50) NOT NULL,
	[DepositBankZip] [nvarchar](50) NOT NULL,
	[DepositBankCountry] [nvarchar](50) NOT NULL,
	[PrimaryWalletTypeID] [int] NOT NULL,
	[PrimaryWalletAccount] [nvarchar](max) NULL,
	[SecondaryWalletTypeID] [int] NOT NULL,
	[SecondaryWalletAccount] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CustomerAccounts] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[CodingTypes](
	[CodingTypeID] [int] NOT NULL,
	[CodingTypeDescription] [nvarchar](100) NULL,
 CONSTRAINT [PK_CodingTypes] PRIMARY KEY CLUSTERED 
(
	[CodingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerTypes](
	[CustomerTypeID] [int] NOT NULL,
	[CustomerTypeDescription] [nvarchar](50) NOT NULL,
	[PriceTypeID] [int] NOT NULL,
 CONSTRAINT [PK_CustomerTypes] PRIMARY KEY CLUSTERED 
(
	[CustomerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ranks](
	[RankID] [int] NOT NULL,
	[RankDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Ranks] PRIMARY KEY CLUSTERED 
(
	[RankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UniLevelTree](
	[CustomerID] [int] NOT NULL,
	[SponsorID] [int] NOT NULL,
	[NestedLevel] [int] NOT NULL,
	[Placement] [int] NOT NULL,
	[Lft] [int] NOT NULL,
	[Rgt] [int] NOT NULL,
 CONSTRAINT [PK_UniLevelTree] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UniLevelTree_Lft] ON [dbo].[UniLevelTree]
(
	[Lft] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UniLevelTree_SponsorID] ON [dbo].[UniLevelTree]
(
	[SponsorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EnrollerTree](
	[CustomerID] [int] NOT NULL,
	[EnrollerID] [int] NOT NULL,
	[NestedLevel] [int] NOT NULL,
	[Lft] [int] NOT NULL,
	[Rgt] [int] NOT NULL,
 CONSTRAINT [PK_EnrollerTree] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EnrollerTree_EnrollerID] ON [dbo].[EnrollerTree]
(
	[EnrollerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EnrollerTree_Lft] ON [dbo].[EnrollerTree]
(
	[Lft] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerStatuses](
	[CustomerStatusID] [int] NOT NULL,
	[CustomerStatusDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CustomerStatuses] PRIMARY KEY CLUSTERED 
(
	[CustomerStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CustomerSubscriptions](
	[SubscriptionID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ExpireDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerSubscriptions] PRIMARY KEY CLUSTERED 
(
	[SubscriptionID] ASC,
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CodedRanks](
	[CodedRankEntryID] [int] NOT NULL,
	[CodingTypeID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[RankID] [int] NOT NULL,
	[CodedDate] [datetime] NOT NULL,
	[CodedToCustomerID] [int] NOT NULL,
	[EntryDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CodedRanks] PRIMARY KEY CLUSTERED 
(
	[CodedRankEntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CodedRanks_CodingTypeID] ON [dbo].[CodedRanks]
(
	[CodingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CodedRanks_CustomerID] ON [dbo].[CodedRanks]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderStatusID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[CurrencyCode] [nvarchar](3) NOT NULL,
	[WarehouseID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[OrderTypeID] [int] NOT NULL,
	[PriceTypeID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[NameSuffix] [nvarchar](50) NOT NULL,
	[Company] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](100) NOT NULL,
	[Address2] [nvarchar](100) NOT NULL,
	[Address3] [nvarchar](100) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Zip] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[County] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Notes] [nvarchar](500) NOT NULL,
	[Total] [money] NOT NULL,
	[SubTotal] [money] NOT NULL,
	[TaxTotal] [money] NOT NULL,
	[ShippingTotal] [money] NOT NULL,
	[DiscountTotal] [money] NOT NULL,
	[DiscountPercent] [money] NOT NULL,
	[WeightTotal] [money] NOT NULL,
	[BusinessVolumeTotal] [money] NOT NULL,
	[CommissionableVolumeTotal] [money] NOT NULL,
	[TrackingNumber1] [nvarchar](50) NOT NULL,
	[TrackingNumber2] [nvarchar](50) NOT NULL,
	[TrackingNumber3] [nvarchar](50) NOT NULL,
	[TrackingNumber4] [nvarchar](50) NOT NULL,
	[TrackingNumber5] [nvarchar](50) NOT NULL,
	[Other1Total] [money] NOT NULL,
	[Other2Total] [money] NOT NULL,
	[Other3Total] [money] NOT NULL,
	[Other4Total] [money] NOT NULL,
	[Other5Total] [money] NOT NULL,
	[Other6Total] [money] NOT NULL,
	[Other7Total] [money] NOT NULL,
	[Other8Total] [money] NOT NULL,
	[Other9Total] [money] NOT NULL,
	[Other10Total] [money] NOT NULL,
	[ShippingTax] [money] NOT NULL,
	[OrderTax] [money] NOT NULL,
	[FedTaxTotal] [money] NOT NULL,
	[StateTaxTotal] [money] NOT NULL,
	[FedShippingTax] [money] NOT NULL,
	[StateShippingTax] [money] NOT NULL,
	[CityShippingTax] [money] NOT NULL,
	[CityLocalShippingTax] [money] NOT NULL,
	[CountyShippingTax] [money] NOT NULL,
	[CountyLocalShippingTax] [money] NOT NULL,
	[Other11] [nvarchar](200) NULL,
	[Other12] [nvarchar](200) NULL,
	[Other13] [nvarchar](200) NULL,
	[Other14] [nvarchar](200) NULL,
	[Other15] [nvarchar](200) NULL,
	[Other16] [nvarchar](200) NULL,
	[Other17] [nvarchar](200) NULL,
	[Other18] [nvarchar](200) NULL,
	[Other19] [nvarchar](200) NULL,
	[Other20] [nvarchar](200) NULL,
	[IsCommissionable] [bit] NOT NULL,
	[AutoOrderID] [int] NULL,
	[ReturnOrderID] [int] NULL,
	[ReplacementOrderID] [int] NULL,
	[ParentOrderID] [int] NULL,
	[BatchID] [int] NOT NULL,
	[DeclineCount] [int] NOT NULL,
	[TransferToCustomerID] [int] NULL,
	[PartyID] [int] NULL,
	[WebCarrierID1] [int] NULL,
	[WebCarrierID2] [int] NULL,
	[WebCarrierID3] [int] NULL,
	[WebCarrierID4] [int] NULL,
	[WebCarrierID5] [int] NULL,
	[ShippedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LockedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](30) NOT NULL,
	[ModifiedBy] [nvarchar](30) NOT NULL,
	[SuppressPackSlipPrice] [bit] NOT NULL,
	[ReturnCategoryID] [int] NULL,
	[ReplacementCategoryID] [int] NULL,
	[IsRMA] [bit] NOT NULL,
	[TaxIntegrationCalculate] [nvarchar](200) NULL,
	[TaxIntegrationCommit] [nvarchar](200) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Orders_CurrencyCode] ON [dbo].[Orders]
(
	[CurrencyCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID] ON [dbo].[Orders]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_OrderDate] ON [dbo].[Orders]
(
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_OrderStatusID] ON [dbo].[Orders]
(
	[OrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_PartyID] ON [dbo].[Orders]
(
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_ReturnOrderID] ON [dbo].[Orders]
(
	[ReturnOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Orders_WarehouseID] ON [dbo].[Orders]
(
	[WarehouseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderID] [int] NOT NULL,
	[OrderLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemCode] [nvarchar](20) NOT NULL,
	[ItemDescription] [nvarchar](500) NOT NULL,
	[Quantity] [money] NOT NULL,
	[PriceEach] [money] NOT NULL,
	[PriceTotal] [money] NOT NULL,
	[Tax] [money] NOT NULL,
	[WeightEach] [money] NOT NULL,
	[Weight] [money] NULL,
	[BusinessVolumeEach] [money] NOT NULL,
	[BusinessVolume] [money] NOT NULL,
	[CommissionableVolumeEach] [money] NOT NULL,
	[CommissionableVolume] [money] NOT NULL,
	[Other1Each] [money] NOT NULL,
	[Other1] [money] NOT NULL,
	[Other2Each] [money] NOT NULL,
	[Other2] [money] NOT NULL,
	[Other3Each] [money] NOT NULL,
	[Other3] [money] NOT NULL,
	[Other4Each] [money] NOT NULL,
	[Other4] [money] NOT NULL,
	[Other5Each] [money] NOT NULL,
	[Other5] [money] NOT NULL,
	[OriginalTaxableEach] [money] NOT NULL,
	[OriginalBusinessVolumeEach] [money] NOT NULL,
	[OriginalCommissionableVolumeEach] [money] NOT NULL,
	[Other6Each] [money] NOT NULL,
	[Other6] [money] NOT NULL,
	[Other7Each] [money] NOT NULL,
	[Other7] [money] NOT NULL,
	[Other8Each] [money] NOT NULL,
	[Other8] [money] NOT NULL,
	[Other9Each] [money] NOT NULL,
	[Other9] [money] NOT NULL,
	[Other10Each] [money] NOT NULL,
	[Other10] [money] NOT NULL,
	[ParentItemID] [int] NULL,
	[Taxable] [money] NOT NULL,
	[FedTax] [money] NOT NULL,
	[StateTax] [money] NOT NULL,
	[CityTax] [money] NOT NULL,
	[CityLocalTax] [money] NOT NULL,
	[CountyTax] [money] NOT NULL,
	[CountyLocalTax] [money] NOT NULL,
	[ManualTax] [money] NOT NULL,
	[IsStateTaxOverride] [bit] NOT NULL,
	[Reference1] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[OrderLine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderTypes](
	[OrderTypeID] [int] NOT NULL,
	[OrderTypeDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrderTypes] PRIMARY KEY CLUSTERED 
(
	[OrderTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatuses](
	[OrderStatusID] [int] NOT NULL,
	[OrderStatusDescription] [nvarchar](50) NULL,
 CONSTRAINT [PK_OrderStatuses] PRIMARY KEY CLUSTERED 
(
	[OrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoOrders](
	[AutoOrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[AutoOrderStatusID] [int] NOT NULL,
	[FrequencyTypeID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[StopDate] [datetime] NULL,
	[LastRunDate] [datetime] NULL,
	[NextRunDate] [datetime] NULL,
	[CancelledDate] [datetime] NULL,
	[CurrencyCode] [nvarchar](3) NOT NULL,
	[WarehouseID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[AutoOrderPaymentTypeID] [int] NOT NULL,
	[AutoOrderProcessTypeID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[NameSuffix] [nvarchar](50) NOT NULL,
	[Company] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](100) NOT NULL,
	[Address2] [nvarchar](100) NOT NULL,
	[Address3] [nvarchar](100) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Zip] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[County] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Notes] [nvarchar](500) NOT NULL,
	[Total] [money] NOT NULL,
	[SubTotal] [money] NOT NULL,
	[TaxTotal] [money] NOT NULL,
	[ShippingTotal] [money] NOT NULL,
	[DiscountTotal] [money] NOT NULL,
	[BusinessVolumeTotal] [money] NOT NULL,
	[CommissionableVolumeTotal] [money] NOT NULL,
	[AutoOrderDescription] [nvarchar](100) NOT NULL,
	[Other11] [nvarchar](400) NULL,
	[Other12] [nvarchar](400) NULL,
	[Other13] [nvarchar](400) NULL,
	[Other14] [nvarchar](400) NULL,
	[Other15] [nvarchar](400) NULL,
	[Other16] [nvarchar](400) NULL,
	[Other17] [nvarchar](400) NULL,
	[Other18] [nvarchar](400) NULL,
	[Other19] [nvarchar](400) NULL,
	[Other20] [nvarchar](400) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](30) NOT NULL,
	[ModifiedBy] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_AutoOrders] PRIMARY KEY CLUSTERED 
(
	[AutoOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AutoOrders_CustomerID] ON [dbo].[AutoOrders]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoOrderStatuses](
	[AutoOrderStatusID] [int] NOT NULL,
	[AutoOrderStatusDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AutoOrderStatuses] PRIMARY KEY CLUSTERED 
(
	[AutoOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscriptions](
	[SubscriptionID] [int] NOT NULL,
	[SubscriptionDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Subscriptions] PRIMARY KEY CLUSTERED 
(
	[SubscriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodTypes](
	[PeriodTypeID] [int] NOT NULL,
	[PeriodTypeDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodTypes] PRIMARY KEY CLUSTERED 
(
	[PeriodTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Periods](
	[PeriodTypeID] [int] NOT NULL,
	[PeriodID] [int] NOT NULL,
	[PeriodDescription] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[AcceptedDate] [datetime] NULL,
 CONSTRAINT [PK_Periods] PRIMARY KEY CLUSTERED 
(
	[PeriodTypeID] ASC,
	[PeriodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodVolumes](
	[PeriodTypeID] [int] NOT NULL,
	[PeriodID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[RankID] [int] NULL,
	[PaidRankID] [int] NULL,
	[Volume1] [money] NOT NULL,
	[Volume2] [money] NOT NULL,
	[Volume3] [money] NOT NULL,
	[Volume4] [money] NOT NULL,
	[Volume5] [money] NOT NULL,
	[Volume6] [money] NOT NULL,
	[Volume7] [money] NOT NULL,
	[Volume8] [money] NOT NULL,
	[Volume9] [money] NOT NULL,
	[Volume10] [money] NOT NULL,
	[Volume11] [money] NOT NULL,
	[Volume12] [money] NOT NULL,
	[Volume13] [money] NOT NULL,
	[Volume14] [money] NOT NULL,
	[Volume15] [money] NOT NULL,
	[Volume16] [money] NOT NULL,
	[Volume17] [money] NOT NULL,
	[Volume18] [money] NOT NULL,
	[Volume19] [money] NOT NULL,
	[Volume20] [money] NOT NULL,
	[Volume21] [money] NOT NULL,
	[Volume22] [money] NOT NULL,
	[Volume23] [money] NOT NULL,
	[Volume24] [money] NOT NULL,
	[Volume25] [money] NOT NULL,
	[Volume26] [money] NOT NULL,
	[Volume27] [money] NOT NULL,
	[Volume28] [money] NOT NULL,
	[Volume29] [money] NOT NULL,
	[Volume30] [money] NOT NULL,
	[Volume31] [money] NOT NULL,
	[Volume32] [money] NOT NULL,
	[Volume33] [money] NOT NULL,
	[Volume34] [money] NOT NULL,
	[Volume35] [money] NOT NULL,
	[Volume36] [money] NOT NULL,
	[Volume37] [money] NOT NULL,
	[Volume38] [money] NOT NULL,
	[Volume39] [money] NOT NULL,
	[Volume40] [money] NOT NULL,
	[Volume41] [money] NOT NULL,
	[Volume42] [money] NOT NULL,
	[Volume43] [money] NOT NULL,
	[Volume44] [money] NOT NULL,
	[Volume45] [money] NOT NULL,
	[Volume46] [money] NOT NULL,
	[Volume47] [money] NOT NULL,
	[Volume48] [money] NOT NULL,
	[Volume49] [money] NOT NULL,
	[Volume50] [money] NOT NULL,
	[Volume51] [money] NOT NULL,
	[Volume52] [money] NOT NULL,
	[Volume53] [money] NOT NULL,
	[Volume54] [money] NOT NULL,
	[Volume55] [money] NOT NULL,
	[Volume56] [money] NOT NULL,
	[Volume57] [money] NOT NULL,
	[Volume58] [money] NOT NULL,
	[Volume59] [money] NOT NULL,
	[Volume60] [money] NOT NULL,
	[Volume61] [money] NOT NULL,
	[Volume62] [money] NOT NULL,
	[Volume63] [money] NOT NULL,
	[Volume64] [money] NOT NULL,
	[Volume65] [money] NOT NULL,
	[Volume66] [money] NOT NULL,
	[Volume67] [money] NOT NULL,
	[Volume68] [money] NOT NULL,
	[Volume69] [money] NOT NULL,
	[Volume70] [money] NOT NULL,
	[Volume71] [money] NOT NULL,
	[Volume72] [money] NOT NULL,
	[Volume73] [money] NOT NULL,
	[Volume74] [money] NOT NULL,
	[Volume75] [money] NOT NULL,
	[Volume76] [money] NOT NULL,
	[Volume77] [money] NOT NULL,
	[Volume78] [money] NOT NULL,
	[Volume79] [money] NOT NULL,
	[Volume80] [money] NOT NULL,
	[Volume81] [money] NOT NULL,
	[Volume82] [money] NOT NULL,
	[Volume83] [money] NOT NULL,
	[Volume84] [money] NOT NULL,
	[Volume85] [money] NOT NULL,
	[Volume86] [money] NOT NULL,
	[Volume87] [money] NOT NULL,
	[Volume88] [money] NOT NULL,
	[Volume89] [money] NOT NULL,
	[Volume90] [money] NOT NULL,
	[Volume91] [money] NOT NULL,
	[Volume92] [money] NOT NULL,
	[Volume93] [money] NOT NULL,
	[Volume94] [money] NOT NULL,
	[Volume95] [money] NOT NULL,
	[Volume96] [money] NOT NULL,
	[Volume97] [money] NOT NULL,
	[Volume98] [money] NOT NULL,
	[Volume99] [money] NOT NULL,
	[Volume100] [money] NOT NULL,
	[Volume101] [money] NOT NULL,
	[Volume102] [money] NOT NULL,
	[Volume103] [money] NOT NULL,
	[Volume104] [money] NOT NULL,
	[Volume105] [money] NOT NULL,
	[Volume106] [money] NOT NULL,
	[Volume107] [money] NOT NULL,
	[Volume108] [money] NOT NULL,
	[Volume109] [money] NOT NULL,
	[Volume110] [money] NOT NULL,
	[Volume111] [money] NOT NULL,
	[Volume112] [money] NOT NULL,
	[Volume113] [money] NOT NULL,
	[Volume114] [money] NOT NULL,
	[Volume115] [money] NOT NULL,
	[Volume116] [money] NOT NULL,
	[Volume117] [money] NOT NULL,
	[Volume118] [money] NOT NULL,
	[Volume119] [money] NOT NULL,
	[Volume120] [money] NOT NULL,
	[Volume121] [money] NOT NULL,
	[Volume122] [money] NOT NULL,
	[Volume123] [money] NOT NULL,
	[Volume124] [money] NOT NULL,
	[Volume125] [money] NOT NULL,
	[Volume126] [money] NOT NULL,
	[Volume127] [money] NOT NULL,
	[Volume128] [money] NOT NULL,
	[Volume129] [money] NOT NULL,
	[Volume130] [money] NOT NULL,
	[Volume131] [money] NOT NULL,
	[Volume132] [money] NOT NULL,
	[Volume133] [money] NOT NULL,
	[Volume134] [money] NOT NULL,
	[Volume135] [money] NOT NULL,
	[Volume136] [money] NOT NULL,
	[Volume137] [money] NOT NULL,
	[Volume138] [money] NOT NULL,
	[Volume139] [money] NOT NULL,
	[Volume140] [money] NOT NULL,
	[Volume141] [money] NOT NULL,
	[Volume142] [money] NOT NULL,
	[Volume143] [money] NOT NULL,
	[Volume144] [money] NOT NULL,
	[Volume145] [money] NOT NULL,
	[Volume146] [money] NOT NULL,
	[Volume147] [money] NOT NULL,
	[Volume148] [money] NOT NULL,
	[Volume149] [money] NOT NULL,
	[Volume150] [money] NOT NULL,
	[Volume151] [money] NOT NULL,
	[Volume152] [money] NOT NULL,
	[Volume153] [money] NOT NULL,
	[Volume154] [money] NOT NULL,
	[Volume155] [money] NOT NULL,
	[Volume156] [money] NOT NULL,
	[Volume157] [money] NOT NULL,
	[Volume158] [money] NOT NULL,
	[Volume159] [money] NOT NULL,
	[Volume160] [money] NOT NULL,
	[Volume161] [money] NOT NULL,
	[Volume162] [money] NOT NULL,
	[Volume163] [money] NOT NULL,
	[Volume164] [money] NOT NULL,
	[Volume165] [money] NOT NULL,
	[Volume166] [money] NOT NULL,
	[Volume167] [money] NOT NULL,
	[Volume168] [money] NOT NULL,
	[Volume169] [money] NOT NULL,
	[Volume170] [money] NOT NULL,
	[Volume171] [money] NOT NULL,
	[Volume172] [money] NOT NULL,
	[Volume173] [money] NOT NULL,
	[Volume174] [money] NOT NULL,
	[Volume175] [money] NOT NULL,
	[Volume176] [money] NOT NULL,
	[Volume177] [money] NOT NULL,
	[Volume178] [money] NOT NULL,
	[Volume179] [money] NOT NULL,
	[Volume180] [money] NOT NULL,
	[Volume181] [money] NOT NULL,
	[Volume182] [money] NOT NULL,
	[Volume183] [money] NOT NULL,
	[Volume184] [money] NOT NULL,
	[Volume185] [money] NOT NULL,
	[Volume186] [money] NOT NULL,
	[Volume187] [money] NOT NULL,
	[Volume188] [money] NOT NULL,
	[Volume189] [money] NOT NULL,
	[Volume190] [money] NOT NULL,
	[Volume191] [money] NOT NULL,
	[Volume192] [money] NOT NULL,
	[Volume193] [money] NOT NULL,
	[Volume194] [money] NOT NULL,
	[Volume195] [money] NOT NULL,
	[Volume196] [money] NOT NULL,
	[Volume197] [money] NOT NULL,
	[Volume198] [money] NOT NULL,
	[Volume199] [money] NOT NULL,
	[Volume200] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[OtherData1] [nvarchar](max) NULL,
	[OtherData2] [nvarchar](max) NULL,
	[OtherData3] [nvarchar](max) NULL,
	[OtherData4] [nvarchar](max) NULL,
	[OtherData5] [nvarchar](max) NULL,
	[OtherData6] [nvarchar](max) NULL,
	[OtherData7] [nvarchar](max) NULL,
 CONSTRAINT [PK_PeriodVolumes] PRIMARY KEY CLUSTERED 
(
	[PeriodTypeID] ASC,
	[PeriodID] ASC,
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Commissions](
	[CommissionRunID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CurrencyCode] [nvarchar](3) NOT NULL,
	[Earnings] [money] NOT NULL,
	[PreviousBalance] [money] NOT NULL,
	[BalanceForward] [money] NOT NULL,
	[Fee] [money] NOT NULL,
	[Total] [money] NOT NULL,
 CONSTRAINT [PK_Commissions] PRIMARY KEY CLUSTERED 
(
	[CommissionRunID] ASC,
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommissionRuns](
	[CommissionRunID] [int] NOT NULL,
	[CommissionRunDescription] [nvarchar](100) NOT NULL,
	[PeriodTypeID] [int] NOT NULL,
	[PeriodID] [int] NOT NULL,
	[RunDate] [datetime] NULL,
	[AcceptedDate] [datetime] NULL,
	[CommissionRunStatusID] [int] NOT NULL,
	[HideFromWeb] [bit] NOT NULL,
	[PlanID] [int] NULL,
 CONSTRAINT [PK_CommissionRuns] PRIMARY KEY CLUSTERED 
(
	[CommissionRunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommissionBonuses](
	[CommissionRunID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BonusID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK_CommissionBonuses] PRIMARY KEY CLUSTERED 
(
	[CommissionRunID] ASC,
	[CustomerID] ASC,
	[BonusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommissionRunStatuses](
	[CommissionRunStatusID] [int] NOT NULL,
	[CommissionRunStatusDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CommissionRunStatuses] PRIMARY KEY CLUSTERED 
(
	[CommissionRunStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bonuses](
	[BonusID] [int] NOT NULL,
	[BonusDescription] [nvarchar](100) NOT NULL,
	[PeriodTypeID] [int] NOT NULL,
 CONSTRAINT [PK_Bonuses] PRIMARY KEY CLUSTERED 
(
	[BonusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.UniLevelTree values (1,9,4,5,50,53)
insert into dbo.EnrollerTree values (1,8,3,6,7)

insert into dbo.PeriodTypes values (1, 'Weekly')
insert into dbo.PeriodTypes values (2, 'Monthly')

-- Seed Data

insert into dbo.Ranks values (1,'Member');
insert into dbo.Ranks values (2,'Independent Associate');
insert into dbo.Ranks values (3,'Director');
insert into dbo.Ranks values (4,'Area Director');
insert into dbo.Ranks values (5,'Regional Director');
insert into dbo.Ranks values (6,'Managing Director');
insert into dbo.Ranks values (7,'Senior Director');
insert into dbo.Ranks values (8,'Executive Director');
insert into dbo.Ranks values (9,'National Director');
insert into dbo.Ranks values (10,'VP Director');
insert into dbo.Ranks values (11,'Presidential Director');
insert into dbo.Ranks values (12,'National Pres Director');
insert into dbo.Ranks values (13,'International Pres Director');
insert into dbo.Ranks values (14,'Global Pres Director');

insert into dbo.CustomerTypes values (1,'Retail Customer',1);
insert into dbo.CustomerTypes values (2,'Member Associate',2);
insert into dbo.CustomerTypes values (3,'Household Member',2);
insert into dbo.CustomerTypes values (4,'Household Associate',3);
insert into dbo.CustomerTypes values (5,'Independent Associate',3);
insert into dbo.CustomerTypes values (6,'Wellness Associate',4);
insert into dbo.CustomerTypes values (7,'Wellness Customer',4);
insert into dbo.CustomerTypes values (8,'Carington RBC',5);
insert into dbo.CustomerTypes values (9,'Carington Customer',6);
insert into dbo.CustomerTypes values (10,'RBC',7);
insert into dbo.CustomerTypes values (11,'RBC Customer',8);

insert into dbo.CustomerStatuses values (0,'Deleted');
insert into dbo.CustomerStatuses values (1,'Active');
insert into dbo.CustomerStatuses values (2,'Terminated');
insert into dbo.CustomerStatuses values (3,'Inactive');
insert into dbo.CustomerStatuses values (4,'Suspended');

insert into dbo.Subscriptions values(1, 'Lite')
insert into dbo.Subscriptions values(2, 'Premium')
insert into dbo.Subscriptions values(3, 'IDWellness')
insert into dbo.Subscriptions values(4, 'Premium Plus')

insert into dbo.Customers values (1,'Anakin','','Skywalker','','',5,1,'askywalker@icentris.com','385-549-9496','','888-555-1212','888-555-1212','12346 Orion Ct East','','','Willis','TX',77318,'US','',0,'12876 Orion Ct East','','','Willis','TX',77318,'US','',0,'','','','','','','','',0,1,'stumurry',0x201BA0B02D1D64F975D66CFBEE5F06A4C305B5975EF31C22357F5C45,2,813500,813500,'1957-04-26 00:00:00.000','usd','',NULL,5,0.0000,NULL,'F','****3918',1,0,'',NULL,'',4,0,0,0,NULL,0,NULL,1,'','','','','','',1,'','','','','','',1,NULL,NULL,NULL,NULL,NULL,'2012-03-27 00:00:00.000','2017-03-22 16:51:19.137','IMPORT','tk85832','2014-01-17 10:24:00.000',NULL,NULL,NULL);

insert into dbo.CustomerSites values (1,'dv','Luke','Skywalker','','lskywalker@icentris.com','385-549-9496','','','3332 Cross Bend Rd','','Plano','TX','75023','US','','','','','','','','','','','','','','','','','','','','','','','','',NULL,NULL,NULL,NULL,'2014-09-20 18:03:11.150');

insert into dbo.CustomerAccounts values (1,'***********1178',6,2022,3,'Stu Murry','P.O. Box 490','','Little Elm','TX',75068,'US','***********2709',10,2018,2,'Stu Murry','P.O. Box 1628','','Sherman','TX',75091,'US','','','','401 S. Coit Rd.','McKinney','TX',75072,'US','','iCentris, Inc','***********4236',111916326,'','','Independent Bank','3090 Craig Dr PO Box 3035','McKinney','TX',75070,'US',0,'',0,'','2019-04-18 14:48:39.443','Lorem.Ipsum');

insert into dbo.CustomerSubscriptions values(1,1,1, GETDATE(), DATEADD(MONTH, 1, GETDATE()))

insert into dbo.PeriodVolumes values (1,1,1,1,1, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, GETDATE(), null, null, null, null, null, null, null)
insert into dbo.Periods values (1,1,'Week 1 1/20-1/26', GETDATE(), GETDATE(), GETDATE())

-- Enable Change Tracking
ALTER DATABASE idlife
SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 7 DAYS, AUTO_CLEANUP = ON);

ALTER TABLE dbo.Customers
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.CustomerSites
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.CustomerAccounts
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.CustomerSubscriptions
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.Orders
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.OrderDetails
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.PeriodVolumes
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.Commissions
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.UniLevelTree
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

ALTER TABLE dbo.EnrollerTree
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = OFF)

