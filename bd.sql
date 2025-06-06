USE [master]
GO
/****** Object:  Database [V_23]    Script Date: 30.05.2024 10:35:48 ******/
CREATE DATABASE [V_23]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'V_22', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\V_23.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'V_22_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\V_23_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [V_23] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [V_23].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [V_23] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [V_23] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [V_23] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [V_23] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [V_23] SET ARITHABORT OFF 
GO
ALTER DATABASE [V_23] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [V_23] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [V_23] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [V_23] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [V_23] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [V_23] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [V_23] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [V_23] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [V_23] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [V_23] SET  DISABLE_BROKER 
GO
ALTER DATABASE [V_23] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [V_23] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [V_23] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [V_23] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [V_23] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [V_23] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [V_23] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [V_23] SET RECOVERY FULL 
GO
ALTER DATABASE [V_23] SET  MULTI_USER 
GO
ALTER DATABASE [V_23] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [V_23] SET DB_CHAINING OFF 
GO
ALTER DATABASE [V_23] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [V_23] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [V_23] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [V_23] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'V_23', N'ON'
GO
ALTER DATABASE [V_23] SET QUERY_STORE = OFF
GO
USE [V_23]
GO
/****** Object:  User [Zalupa]    Script Date: 30.05.2024 10:35:49 ******/
CREATE USER [Zalupa] FOR LOGIN [Zalupa] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ibank]    Script Date: 30.05.2024 10:35:49 ******/
CREATE USER [ibank] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ibank]
GO
/****** Object:  UserDefinedFunction [dbo].[sf_GetTeamPersonCount]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 231118
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[sf_GetTeamPersonCount](@outgoing SMALLINT)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @returnvalue SMALLINT;
	SELECT @returnvalue = COUNT(*) FROM dbo.ft_GetPersonsFromTeam(@outgoing)
	RETURN(@returnvalue);
END
GO
/****** Object:  Table [dbo].[recruitment_office_name]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recruitment_office_name](
	[id] [tinyint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_recruitment_office_name] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person_orphan]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person_orphan](
	[passport_serial] [char](12) NOT NULL,
	[is_orphan] [bit] NULL,
	[has_certificate] [bit] NULL,
 CONSTRAINT [PK_person_orphan] PRIMARY KEY CLUSTERED 
(
	[passport_serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[passport_serial] [char](12) NOT NULL,
	[last_name] [nvarchar](max) NOT NULL,
	[first_name] [nvarchar](max) NOT NULL,
	[patronymic] [nvarchar](max) NOT NULL,
	[birth_date] [date] NOT NULL,
	[birth_place] [nvarchar](max) NOT NULL,
	[passport_issue] [nvarchar](max) NOT NULL,
	[passport_issue_date] [date] NOT NULL,
	[passport_division_code] [char](7) NOT NULL,
	[address] [nvarchar](max) NOT NULL,
	[phone_home] [char](10) NOT NULL,
	[phone_mobile] [char](10) NOT NULL,
	[recruitment_office_id] [tinyint] NOT NULL,
	[codeword] [nvarchar](20) NOT NULL,
	[comment] [nvarchar](max) NULL,
	[date_added] [datetime] NOT NULL,
 CONSTRAINT [PK_person_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_person_passport_serial] UNIQUE NONCLUSTERED 
(
	[passport_serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person_track]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person_track](
	[passport_serial] [char](12) NOT NULL,
	[track] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person_card]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person_card](
	[passport_serial] [char](12) NOT NULL,
	[account_number] [char](16) NOT NULL,
	[date_added] [datetime] NOT NULL,
 CONSTRAINT [PK_person_card_1] PRIMARY KEY CLUSTERED 
(
	[passport_serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person_team]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person_team](
	[passport_serial] [char](12) NOT NULL,
	[outgoing] [smallint] NOT NULL,
	[date_added] [datetime] NOT NULL,
 CONSTRAINT [PK_person_team] PRIMARY KEY CLUSTERED 
(
	[passport_serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ft_SearchPerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 231118
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[ft_SearchPerson]
(	
	@last_name NVARCHAR(MAX),
	@first_name NVARCHAR(MAX),
	@patronymic NVARCHAR(MAX),
	@passport_serial VARCHAR(12),
	@accoun_number VARCHAR(16)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT person.*
	, (SELECT name FROM recruitment_office_name WHERE id = person.recruitment_office_id) AS recruitment_office
	, person_card.account_number, person_orphan.is_orphan, person_track.track, person_team.outgoing
	FROM person
	LEFT JOIN person_card ON person.passport_serial = person_card.passport_serial
	LEFT JOIN person_team ON person.passport_serial = person_team.passport_serial
	LEFT JOIN person_orphan ON person.passport_serial = person_orphan.passport_serial
	LEFT JOIN person_track ON person.passport_serial = person_track.passport_serial
	WHERE person.last_name LIKE @last_name
	AND person.first_name LIKE @first_name
	AND person.patronymic LIKE @patronymic
	AND person.passport_serial LIKE @passport_serial
	AND (person_card.account_number IS NULL OR person_card.account_number LIKE @accoun_number)
)
GO
/****** Object:  UserDefinedFunction [dbo].[ft_GetPersonsFromTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ft_GetPersonsFromTeam](@outgoing SMALLINT)
RETURNS TABLE
AS
	RETURN
		SELECT person_team.passport_serial, person.last_name, person.first_name, person.patronymic, person.birth_date, person.recruitment_office_id, recruitment_office_name.name as recruitment_office, person_card.account_number
		FROM person_team
		JOIN person ON person.passport_serial = person_team.passport_serial
		JOIN person_card ON person_card.passport_serial = person_team.passport_serial
		JOIN recruitment_office_name ON person.recruitment_office_id = recruitment_office_name.id
		WHERE person_team.outgoing = @outgoing
GO
/****** Object:  UserDefinedFunction [dbo].[ft_SearchPersonToAssignCard]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ft_SearchPersonToAssignCard]
(	
	@last_name NVARCHAR(MAX),
	@first_name NVARCHAR(MAX),
	@patronymic NVARCHAR(MAX),
	@passport_serial VARCHAR(12)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT person.passport_serial, person.last_name, person.first_name, person.patronymic, person.birth_date, person.comment
	, person_orphan.is_orphan, person_team.outgoing
	FROM person
	LEFT JOIN person_team ON person.passport_serial = person_team.passport_serial
	LEFT JOIN person_orphan ON person.passport_serial = person_orphan.passport_serial
	WHERE person.passport_serial NOT IN (SELECT passport_serial FROM person_card)
	AND person.last_name LIKE @last_name
	AND person.first_name LIKE @first_name
	AND person.patronymic LIKE @patronymic
	AND person.passport_serial LIKE @passport_serial
)
GO
/****** Object:  Table [dbo].[action]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[action](
	[id] [tinyint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_action] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[action_log]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[action_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_id] [tinyint] NOT NULL,
	[action_date] [smalldatetime] NOT NULL,
	[metadata] [nvarchar](max) NULL,
 CONSTRAINT [PK_action_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[card]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[card](
	[account_number] [char](16) NOT NULL,
	[codeword] [nvarchar](20) NULL,
	[date_added] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_card_1] PRIMARY KEY CLUSTERED 
(
	[account_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[checklist]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[checklist](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[office_id] [tinyint] NOT NULL,
	[list] [bit] NOT NULL,
	[paper] [bit] NOT NULL,
	[base] [bit] NOT NULL,
	[pass] [bit] NOT NULL,
	[count_s] [tinyint] NOT NULL,
	[count_snc] [tinyint] NOT NULL,
	[count_c] [tinyint] NOT NULL,
	[comment] [nvarchar](max) NOT NULL,
	[date] [date] NOT NULL,
 CONSTRAINT [PK_checklist] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person_team_metadata]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person_team_metadata](
	[passport_serial] [char](12) NOT NULL,
	[account_number_registered_in_military_id] [bit] NOT NULL,
 CONSTRAINT [PK_person_team_metadata] PRIMARY KEY CLUSTERED 
(
	[passport_serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[team]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[team](
	[outgoing] [smallint] NOT NULL,
	[team] [smallint] NOT NULL,
	[date_added] [datetime] NOT NULL,
	[statement] [smallint] NULL,
	[statement_date] [datetime] NULL,
 CONSTRAINT [PK_team] PRIMARY KEY CLUSTERED 
(
	[outgoing] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[action_log] ADD  CONSTRAINT [DF_action_log_action_date]  DEFAULT (getdate()) FOR [action_date]
GO
ALTER TABLE [dbo].[card] ADD  CONSTRAINT [DF_card_date]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[person] ADD  CONSTRAINT [DF_person_date]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[person_card] ADD  CONSTRAINT [DF_person_card_date_added]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[person_team] ADD  CONSTRAINT [DF_person_team_date_added]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[person_team_metadata] ADD  CONSTRAINT [DF_person_team_metadata_account_number_registered_in_military_id]  DEFAULT ((0)) FOR [account_number_registered_in_military_id]
GO
ALTER TABLE [dbo].[team] ADD  CONSTRAINT [DF_team_date]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[person]  WITH CHECK ADD  CONSTRAINT [FK_person_person] FOREIGN KEY([id])
REFERENCES [dbo].[person] ([id])
GO
ALTER TABLE [dbo].[person] CHECK CONSTRAINT [FK_person_person]
GO
ALTER TABLE [dbo].[person]  WITH NOCHECK ADD  CONSTRAINT [FK_person_person_card] FOREIGN KEY([passport_serial])
REFERENCES [dbo].[person_card] ([passport_serial])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[person] NOCHECK CONSTRAINT [FK_person_person_card]
GO
ALTER TABLE [dbo].[person]  WITH NOCHECK ADD  CONSTRAINT [FK_person_person_orphan] FOREIGN KEY([passport_serial])
REFERENCES [dbo].[person_orphan] ([passport_serial])
GO
ALTER TABLE [dbo].[person] NOCHECK CONSTRAINT [FK_person_person_orphan]
GO
ALTER TABLE [dbo].[person]  WITH NOCHECK ADD  CONSTRAINT [FK_person_person_team] FOREIGN KEY([passport_serial])
REFERENCES [dbo].[person_team] ([passport_serial])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[person] NOCHECK CONSTRAINT [FK_person_person_team]
GO
ALTER TABLE [dbo].[person]  WITH CHECK ADD  CONSTRAINT [FK_person_recruitment_office_name] FOREIGN KEY([recruitment_office_id])
REFERENCES [dbo].[recruitment_office_name] ([id])
GO
ALTER TABLE [dbo].[person] CHECK CONSTRAINT [FK_person_recruitment_office_name]
GO
ALTER TABLE [dbo].[person_card]  WITH NOCHECK ADD  CONSTRAINT [FK_person_card_card] FOREIGN KEY([account_number])
REFERENCES [dbo].[card] ([account_number])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[person_card] NOCHECK CONSTRAINT [FK_person_card_card]
GO
ALTER TABLE [dbo].[person_team]  WITH NOCHECK ADD  CONSTRAINT [FK_person_team_team] FOREIGN KEY([outgoing])
REFERENCES [dbo].[team] ([outgoing])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[person_team] NOCHECK CONSTRAINT [FK_person_team_team]
GO
/****** Object:  StoredProcedure [dbo].[pr_AccountNumberRegisteredChanged]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_AccountNumberRegisteredChanged]
	@passport_serial							AS CHAR(12),
	@account_number_registered_in_military_id	AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE person_team_metadata SET account_number_registered_in_military_id = @account_number_registered_in_military_id WHERE passport_serial = @passport_serial
	IF @@ROWCOUNT = 0
	   INSERT INTO person_team_metadata(passport_serial, account_number_registered_in_military_id) VALUES (@passport_serial, @account_number_registered_in_military_id)
	
	INSERT INTO action_log(action_id, metadata) VALUES (13, FORMATMESSAGE('{"passport_serial":"%s", "account_number_registered_in_military_id":"%i"}', @passport_serial, @account_number_registered_in_military_id))
END
GO
/****** Object:  StoredProcedure [dbo].[pr_AddPerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего
-- =============================================
CREATE PROCEDURE [dbo].[pr_AddPerson]
	@passport_serial			AS CHAR(12),
	@last_name					AS NVARCHAR(MAX),
	@first_name					AS NVARCHAR(MAX),
	@patronymic					AS NVARCHAR(MAX),
	@birth_date					AS VARCHAR(MAX),
	@birth_place				AS NVARCHAR(MAX),
	@passport_issue				AS NVARCHAR(MAX),
	@passport_issue_date		AS VARCHAR(MAX),
	@passport_division_code		AS CHAR(7),
	@address					AS NVARCHAR(MAX),
	@phone_home					AS CHAR(10),
	@phone_mobile				AS CHAR(10),
	@recruitment_office_id		AS TINYINT,
	@codeword					AS NVARCHAR(20),
	@comment					AS NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO person
           ([passport_serial]
           ,[last_name]
           ,[first_name]
           ,[patronymic]
           ,[birth_date]
           ,[birth_place]
           ,[passport_issue]
           ,[passport_issue_date]
           ,[passport_division_code]
           ,[address]
           ,[phone_home]
           ,[phone_mobile]
           ,[recruitment_office_id]
           ,[codeword]
           ,[comment])
     VALUES
           (@passport_serial
           ,@last_name
           ,@first_name
           ,@patronymic
           ,convert(date,(SUBSTRING(@birth_date,7,4)+'-'+SUBSTRING(@birth_date,4,2)+'-'+SUBSTRING(@birth_date,1,2)))
           ,@birth_place
           ,@passport_issue
           ,convert(date,(SUBSTRING(@passport_issue_date,7,4)+'-'+SUBSTRING(@passport_issue_date,4,2)+'-'+SUBSTRING(@passport_issue_date,1,2)))
           ,@passport_division_code
           ,@address
           ,@phone_home
           ,@phone_mobile
           ,@recruitment_office_id
           ,@codeword
           ,@comment)
	INSERT INTO action_log(action_id, metadata) VALUES (1, 
	FORMATMESSAGE('{"passport_serial":"%s", "last_name":"%s", "first_name":"%s", "patronymic":"%s", "birth_date":"%s", "birth_place":"%s", "passport_issue":"%s", "passport_issue_date":"%s", "passport_division_code":"%s", "address":"%s", "phone_home":"%s", "phone_mobile":"%s", "recruitment_office_id":"%i", "codeword":"%s", "comment":"%s"}'
		   ,@passport_serial
           ,@last_name
           ,@first_name
           ,@patronymic
           --,CONVERT(varchar(MAX), @birth_date, 103)
           ,@birth_place
           ,@passport_issue
           ,CONVERT(varchar(MAX), @passport_issue_date, 103)
           ,@passport_division_code
           ,@address
           ,@phone_home
           ,@phone_mobile
           ,@recruitment_office_id
           ,@codeword
           ,@comment))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_AssignCard]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего в исходящий
-- =============================================
CREATE PROCEDURE [dbo].[pr_AssignCard]
	@passport_serial	AS CHAR(12),
	@account_number		AS CHAR(16)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO person_card(passport_serial, account_number) VALUES (@passport_serial, @account_number)
	INSERT INTO action_log(action_id, metadata) VALUES (9, FORMATMESSAGE('{"passport_serial":"%s", "account_number":"%i"}', @passport_serial, @account_number))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_AssignTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего в исходящий
-- =============================================
CREATE PROCEDURE [dbo].[pr_AssignTeam]
	@passport_serial	AS NCHAR(12),
	@outgoing			AS INT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO person_team(passport_serial, outgoing) VALUES (@passport_serial, @outgoing)
	INSERT INTO action_log(action_id, metadata) VALUES (7, FORMATMESSAGE('{"passport_serial":"%s", "outgoing":"%i"}', @passport_serial, @outgoing))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_ChangePerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего
-- =============================================
CREATE PROCEDURE [dbo].[pr_ChangePerson]
	@passport_serial			AS VARCHAR(20),
	@last_name					AS NVARCHAR(MAX),
	@first_name					AS NVARCHAR(MAX),
	@patronymic					AS NVARCHAR(MAX),
	@birth_place				AS NVARCHAR(MAX),
	@birth_date					AS DATE,
	@address					AS NVARCHAR(MAX),
	@phone_home					AS CHAR(10),
	@phone_mobile				AS CHAR(10),
	@recruitment_office_id		AS TINYINT,
	@codeword					AS NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE person 
	SET
           last_name = @last_name
           ,first_name = @first_name
           ,patronymic = @patronymic
           ,birth_date = @birth_date
           ,birth_place = @birth_place
		   ,address = @address
		   ,phone_home = @phone_home
		   ,phone_mobile = @phone_mobile
		   ,recruitment_office_id = @recruitment_office_id
		   ,codeword = @codeword
	WHERE passport_serial = @passport_serial

	INSERT INTO action_log(action_id, metadata) VALUES (2, 
	FORMATMESSAGE('{"passport_serial":"%s", "last_name":"%s", "first_name":"%s", "patronymic":"%s", "birth_date":"%s", "birth_place":"%s", "address":"%s", "phone_home":"%s", "phone_mobile":"%s", "recruitment_office_id":"%i", "codeword":"%s"}'
		   ,@passport_serial
           ,@last_name
           ,@first_name
           ,@patronymic
           ,CAST(@birth_date as VARCHAR)
           ,@birth_place,
		   @address,
		   @phone_home,
		   @phone_mobile,
		   @recruitment_office_id,
		   @codeword))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_ChangePersonDocument]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего
-- =============================================
CREATE PROCEDURE [dbo].[pr_ChangePersonDocument]
	@old_document_serial_number	AS VARCHAR(20),
	@new_document_serial_number	AS VARCHAR(20),
	@new_document_issue AS NVARCHAR(MAX),
	@new_document_issue_date AS DATE,
	@new_document_division_code AS NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE person SET passport_serial = @new_document_serial_number WHERE passport_serial = @old_document_serial_number
	UPDATE person_team SET passport_serial = @new_document_serial_number WHERE passport_serial = @old_document_serial_number
	UPDATE person_card SET passport_serial = @new_document_serial_number WHERE passport_serial = @old_document_serial_number
	UPDATE person_team_metadata SET passport_serial = @new_document_serial_number WHERE passport_serial = @old_document_serial_number
	UPDATE person_orphan SET passport_serial = @new_document_serial_number WHERE passport_serial = @old_document_serial_number

	UPDATE person SET passport_issue = @new_document_issue WHERE passport_serial = @new_document_serial_number
	UPDATE person SET passport_issue_date = @new_document_issue_date WHERE passport_serial = @new_document_serial_number
	UPDATE person SET passport_division_code = @new_document_division_code WHERE passport_serial = @new_document_serial_number

	INSERT INTO action_log(action_id, metadata) VALUES (1, 
	FORMATMESSAGE('{"old_document_serial_number":"%s", "new_document_serial_number":"%s"}'
		   ,@old_document_serial_number
           ,@new_document_serial_number))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_ChangePersonMinimalistic]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего
-- =============================================
CREATE PROCEDURE [dbo].[pr_ChangePersonMinimalistic]
	@passport_serial			AS VARCHAR(20),
	@last_name					AS NVARCHAR(MAX),
	@first_name					AS NVARCHAR(MAX),
	@patronymic					AS NVARCHAR(MAX),
	@birth_place				AS NVARCHAR(MAX),
	@birth_date					AS DATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE person 
	SET
           last_name = @last_name
           ,first_name = @first_name
           ,patronymic = @patronymic
           ,birth_date = @birth_date
           ,birth_place = @birth_place
	WHERE passport_serial = @passport_serial

	INSERT INTO action_log(action_id, metadata) VALUES (2, 
	FORMATMESSAGE('{"passport_serial":"%s", "last_name":"%s", "first_name":"%s", "patronymic":"%s", "birth_date":"%s", "birth_place":"%s"}'
		   ,@passport_serial
           ,@last_name
           ,@first_name
           ,@patronymic
           ,CAST(@birth_date as VARCHAR)
           ,@birth_place))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_CreateTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Создание исходящего
-- =============================================
CREATE PROCEDURE [dbo].[pr_CreateTeam]
	@outgoing	AS SMALLINT,
	@team	AS SMALLINT,
	@statement	AS SMALLINT = NULL,
	@statement_date	AS VARCHAR(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO team(outgoing, team, statement, statement_date) VALUES (@outgoing, @team, @statement,convert(datetime,(SUBSTRING(@statement_date,7,4)+'-'+SUBSTRING(@statement_date,4,2)+'-'+SUBSTRING(@statement_date,1,2))) )
	--INSERT INTO action_log(action_id, metadata) VALUES (4, FORMATMESSAGE('{"outgoing":"%i", "team":"%i", "statement":"%i", "statement_date":"%i"}', @outgoing, @team, @statement, CAST(@statement_date as VARCHAR)))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_DeassignCard]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Удаление военнослужащего из исходящего
-- =============================================
CREATE PROCEDURE [dbo].[pr_DeassignCard]
	@passport_serial	AS CHAR(12)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
	@account_number NCHAR(16)

	SELECT @account_number = account_number FROM person_card WHERE passport_serial = @passport_serial

	DELETE FROM person_team WHERE passport_serial = @passport_serial
	INSERT INTO action_log(action_id, metadata) VALUES (10, FORMATMESSAGE('{"passport_serial":"%s", "account_number":"%i"}', @passport_serial, @account_number))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_DeassignTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Удаление военнослужащего из исходящего
-- =============================================
CREATE PROCEDURE [dbo].[pr_DeassignTeam]
	@passport_serial	AS CHAR(12)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
	@outgoing INT

	SELECT @outgoing = outgoing FROM person_team WHERE passport_serial = @passport_serial

	DELETE FROM person_team WHERE passport_serial = @passport_serial
	INSERT INTO action_log(action_id, metadata) VALUES (8, FORMATMESSAGE('{"passport_serial":"%s", "outgoing":"%i"}', @passport_serial, @outgoing))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_DeletePerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Создание исходящего
-- =============================================
CREATE PROCEDURE [dbo].[pr_DeletePerson]
	@passport_serial	AS CHAR(12)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM person WHERE passport_serial =  @passport_serial
	DELETE FROM person_card WHERE passport_serial =  @passport_serial
	DELETE FROM person_team WHERE passport_serial =  @passport_serial
	DELETE FROM person_team_metadata WHERE passport_serial =  @passport_serial
	INSERT INTO action_log(action_id, metadata) VALUES (3, FORMATMESSAGE('{"passport_serial":"%s"}', @passport_serial))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_DeleteTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Создание исходящего
-- =============================================
CREATE PROCEDURE [dbo].[pr_DeleteTeam]
	@outgoing	AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @document_serial AS CHAR(12)
	SELECT * Into #team_table FROM person_team WHERE outgoing = @outgoing

	WHILE (SELECT COUNT(*) FROM #team_table) > 0
	BEGIN
		SELECT TOP 1 @document_serial = passport_serial FROM #team_table

		EXEC pr_DeassignTeam @document_serial

		DELETE #team_table WHERE passport_serial = @document_serial
	END

	DELETE FROM team WHERE outgoing =  @outgoing
	INSERT INTO action_log(action_id, metadata) VALUES (6, FORMATMESSAGE('{"outgoing":"%i"}', @outgoing))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_EditPerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Aragas
-- Create date: 211118;
-- Description:	Добавление военнослужащего
-- =============================================
CREATE PROCEDURE [dbo].[pr_EditPerson]
	@passport_serial			AS CHAR(12),
	@last_name					AS NVARCHAR(MAX),
	@first_name					AS NVARCHAR(MAX),
	@patronymic					AS NVARCHAR(MAX),
	@birth_date					AS DATE,
	@birth_place				AS NVARCHAR(MAX),
	@passport_issue				AS NVARCHAR(MAX),
	@passport_issue_date		AS DATE,
	@passport_division_code		AS CHAR(7),
	@address					AS NVARCHAR(MAX),
	@phone_home					AS CHAR(10),
	@phone_mobile				AS CHAR(10),
	@recruitment_office_id		AS TINYINT,
	@codeword					AS NVARCHAR(20),
	@date_added					AS SMALLDATETIME,
	@comment					AS NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE person 
	SET
           last_name = @last_name
           ,first_name = @first_name
           ,patronymic = @patronymic
           ,birth_date = @birth_date
           ,birth_place = @birth_place
           ,passport_issue = @passport_issue
           ,passport_issue_date = @passport_issue_date
           ,passport_division_code = @passport_division_code
           ,address = @address
           ,phone_home = @phone_home
           ,phone_mobile = @phone_mobile
           ,recruitment_office_id = @recruitment_office_id
           ,codeword = @codeword
           ,date_added = @date_added
           ,comment = @comment 
	WHERE passport_serial = @passport_serial

	INSERT INTO action_log(action_id, metadata) VALUES (2, 
	FORMATMESSAGE('{"passport_serial":"%s", "last_name":"%s", "first_name":"%s", "patronymic":"%s", "birth_date":"%s", "birth_place":"%s", "passport_issue":"%s", "passport_issue_date":"%s", "passport_division_code":"%s", "address":"%s", "phone_home":"%s", "phone_mobile":"%s", "recruitment_office_id":"%i", "codeword":"%s", "date_added":"%s", "comment":"%s"}'
		   ,@passport_serial
           ,@last_name
           ,@first_name
           ,@patronymic
           ,CAST(@birth_date as VARCHAR)
           ,@birth_place
           ,@passport_issue
           ,CAST(@passport_issue_date as VARCHAR)
           ,@passport_division_code
           ,@address
           ,@phone_home
           ,@phone_mobile
           ,@recruitment_office_id
           ,@codeword
           ,CAST(@date_added as VARCHAR)
           ,@comment))
END

GO
/****** Object:  StoredProcedure [dbo].[pr_GetAddedPersonsFromYesterday]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetAddedPersonsFromYesterday]
AS
	SELECT ROW_NUMBER() OVER(ORDER BY id ASC) AS id
		  ,[last_name]
		  ,[first_name]
		  ,[patronymic]
		  ,CONVERT(varchar(MAX), person.birth_date, 103)
		  ,SUBSTRING([birth_place], 1, 32)
		  ,[passport_serial]
		  ,[passport_issue]
		  ,CONVERT(varchar(MAX), passport_issue_date, 103)
		  ,[passport_division_code]
		  ,[address]
		  , 'Москва' as city
		  ,[phone_home]
		  ,[phone_mobile]
		  ,[codeword]
		  ,[recruitment_office_id]
	  FROM [dbo].[person]
	 -- WHERE -- Если день является понедельником, вернуть данные за 4 дня(чтоб включилась пятница), иначе за 1 день
	  --(DATEPART(DW, getdate() + @@DATEFIRST - 1) = 1 AND CONVERT(date, date_added) >= CONVERT(date, DATEADD(dd, -4, getdate())))
	  --OR
	  --(DATEPART(DW, getdate() + @@DATEFIRST - 1) != 1 AND CONVERT(date, date_added) >= CONVERT(date, DATEADD(dd, -1, getdate())))
GO
/****** Object:  StoredProcedure [dbo].[pr_GetAllPersonsForImport]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetAllPersonsForImport]
	
	-- ============================================================================
	-- Author:		Aragas
	-- Create date: 211118
	-- Description: Счетчик людей с присвоенными картами, но не отправленных
	-- ============================================================================

	-- ПАРАМЕТРЫ
			
AS 

SELECT * FROM person WHERE passport_serial NOT IN (SELECT passport_serial FROM person_marked_exported)

GO
/****** Object:  StoredProcedure [dbo].[pr_GetAssignedCardCount]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetAssignedCardCount]
	
	-- ============================================================================
	-- Author:		Aragas
	-- Create date: 211118
	-- Description: Счетчик людей с присвоенными картами, но не отправленных
	-- ============================================================================	
AS 
	SELECT COUNT(*) 
	FROM person_card
	WHERE person_card.passport_serial IN (SELECT passport_serial FROM person)
GO
/****** Object:  StoredProcedure [dbo].[pr_GetAssignedCardCountToday]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetAssignedCardCountToday]
AS
	SELECT COUNT(*) FROM person_card
	WHERE CAST(person_card.date_added AS DATE) = CAST(GETDATE() AS DATE)
	AND (person_card.passport_serial IN (SELECT passport_serial FROM person))
GO
/****** Object:  StoredProcedure [dbo].[pr_GetAssignedCardWithoutTeamCount]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetAssignedCardWithoutTeamCount]
	
	-- ============================================================================
	-- Author:		Aragas
	-- Create date: 211118
	-- Description: Счетчик людей с присвоенными картами, но не отправленных
	-- ============================================================================	
AS 
	SELECT COUNT(*)
	FROM person_card
	WHERE (person_card.passport_serial NOT IN (SELECT passport_serial FROM person_team))
GO
/****** Object:  StoredProcedure [dbo].[pr_GetDactyloscopyReport]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GetDactyloscopyReport]
AS
	SELECT ROW_NUMBER() OVER(ORDER BY id ASC) AS id
		  ,[last_name]
		  ,[first_name]
		  ,[patronymic]
		  ,CONVERT(varchar(MAX), person.birth_date, 103)
	  FROM [dbo].[person]
	  JOIN person_team ON person.passport_serial = person_team.passport_serial
GO
/****** Object:  StoredProcedure [dbo].[pr_GetOrphansForSPIC]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Aragas
-- Create date: 211118
-- Description:	Отмечаем военнослужащих, которые были экспортированы в ссаную банковскую прогу
-- =============================================
CREATE PROCEDURE [dbo].[pr_GetOrphansForSPIC]
	@date_start	AS DATE,
	@date_end AS DATE
AS
BEGIN
	SET NOCOUNT ON;

	SELECT person.last_name, person.first_name, person.patronymic, person.birth_date
	FROM person
	JOIN person_orphan ON person.passport_serial = person_orphan.passport_serial
    JOIN person_team ON person.passport_serial = person_team.passport_serial
	WHERE person_orphan.is_orphan = 1
	AND CAST(person_team.date_added as DATE) >= @date_start
    AND CAST(person_team.date_added as DATE) <= @date_end
END

GO
/****** Object:  StoredProcedure [dbo].[pr_GetPersonsFromTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetPersonsFromTeam](@outgoing SMALLINT)
AS
	
	SELECT person_team.passport_serial, person.last_name, person.first_name, person.patronymic, person.birth_date, person.recruitment_office_id, recruitment_office_name.name as recruitment_office, person_card.account_number
	FROM person_team
	JOIN person ON person.passport_serial = person_team.passport_serial
	JOIN person_card ON person_card.passport_serial = person_team.passport_serial
	JOIN recruitment_office_name ON person.recruitment_office_id = recruitment_office_name.id
	WHERE person_team.outgoing = @outgoing
	ORDER BY 
		--recruitment_office_id,
		last_name, 
		first_name, 
		patronymic
GO
/****** Object:  StoredProcedure [dbo].[pr_GetPersonsWithCardList]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetPersonsWithCardList]
	
	-- ========================================================================================
	-- Author:		Гавнюки с шилом в задницах, на основе запросов Flash
	-- Create date: 270313
	-- Description: вывод списка людей с прописанными картами, готовых к назначению в исходящий
	-- ========================================================================================

	-- ПАРАМЕТРЫ
			
AS 

SELECT person.passport_serial, last_name, first_name, patronymic, birth_date, recruitment_office_id, recruitment_office_name.name as recruitment_office, account_number, person_track.track
FROM person 
JOIN person_card ON person_card.passport_serial = person.passport_serial
JOIN recruitment_office_name ON person.recruitment_office_id = recruitment_office_name.id
LEFT JOIN person_track ON person.passport_serial = person_track.passport_serial
WHERE person.passport_serial NOT IN (SELECT passport_serial FROM person_team)
ORDER BY
	recruitment_office_id,
	last_name,
	first_name,
	patronymic
GO
/****** Object:  StoredProcedure [dbo].[pr_GetPersonsWithoutCard]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_GetPersonsWithoutCard]
	
	-- ========================================================================================
	-- Author:		Гавнюки с шилом в задницах, на основе запросов Flash
	-- Create date: 270313
	-- Description: вывод списка людей с прописанными картами, готовых к назначению в исходящий
	-- ========================================================================================

	-- ПАРАМЕТРЫ
			
AS 

SELECT person.passport_serial, last_name, first_name, patronymic, birth_date, comment
FROM person 
WHERE person.passport_serial NOT IN (SELECT passport_serial FROM person_team)
AND person.passport_serial NOT IN (SELECT passport_serial FROM person_card)
ORDER BY
	last_name,
	first_name,
	patronymic
GO
/****** Object:  StoredProcedure [dbo].[pr_GetReportForVTB]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_GetReportForVTB]
AS
BEGIN
	SELECT	ROW_NUMBER() OVER(ORDER BY person.last_name, person.first_name, person.patronymic ASC),
			person.last_name,
			person.first_name,
			person.patronymic,
			'М',
			CONVERT(varchar(MAX), person.birth_date, 103),
			person.birth_place,
			person.passport_serial,
			CONCAT(person.passport_issue, ' ', CONVERT(varchar(MAX), person.passport_issue_date, 103), ' ', person.passport_division_code),
			person.address,
			'Москва',
			'4956766434',
			person.phone_home,
			person.phone_mobile,
			'',
			'',
			'в/ч-13240',
			'Рядовой',
			'',
			person.codeword,
			'',
			'',
			'',
			'',
			'',
			person_card.account_number,
			'stop',
			person.recruitment_office_id
	FROM person
	JOIN person_card ON person.passport_serial = person_card.passport_serial
END
GO
/****** Object:  StoredProcedure [dbo].[pr_GetTeamOfficerInfo]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_GetTeamOfficerInfo]
	@OutNum				AS SMALLINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY last_name)				[п/п]
		  ,person.last_name										[Фамилия]
		  ,person.first_name									[Имя]
		  ,person.patronymic									[Отчество]
		  ,CONVERT(VARCHAR, person.birth_date, 104)				[Дата рождения]
		  ,person.birth_place									[Место рождения]
		  ,person.passport_serial								[Паспорт]
		  ,person.passport_issue								[Кем выдан]
		  ,CONVERT(VARCHAR, person.passport_issue_date, 104)	[Дата выдачи]
		  ,person.passport_division_code						[Подразделение]
		  ,person.address										[Адрес проживания]
		  ,person.phone_home									[Домашний телефон]
		  ,person.phone_mobile									[Мобильный телефон]
		  ,'ВТБ'												[Наименование банка]
		  ,person_card.account_number							[Номер карты]
	  FROM person
	  JOIN person_card ON person_card.passport_serial = person.passport_serial
	  JOIN person_team T ON T.passport_serial = person.passport_serial
	  WHERE T.outgoing = @OutNum
	  ORDER BY 
		  person.last_name, 
		  person.first_name, 
		  person.patronymic
END
GO
/****** Object:  StoredProcedure [dbo].[pr_GetTeams]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118
-- Description:	Получаем список команд и кол-во призывников в команде
CREATE PROCEDURE [dbo].[pr_GetTeams]
AS
BEGIN
	DECLARE @outgoing SMALLINT, @team SMALLINT, @person_count INT, @is_complete BIT, @date_added DATE, @statement SMALLINT, @statement_date DATETIME
	DECLARE @databases TABLE
	(
		outgoing SMALLINT,
		team SMALLINT,
		person_count SMALLINT,   
		is_complete BIT,
		date_added DATE,
		statement SMALLINT,
		statement_date DATETIME
	)

	SELECT * Into #Temp FROM team ORDER BY outgoing asc

	WHILE (SELECT COUNT(*) FROM #Temp) > 0
	BEGIN
		SELECT TOP 1 @outgoing = outgoing, @team = team, @date_added = date_added, @statement = statement, @statement_date = statement_date FROM #Temp ORDER BY outgoing DESC
		SELECT @person_count = (SELECT dbo.sf_GetTeamPersonCount(@outgoing))
		SELECT @is_complete = CAST(
		CASE 
			WHEN (@person_count = (
				SELECT COUNT(*) 
				FROM person_team 
				JOIN person_team_metadata 
				ON person_team.passport_serial = person_team_metadata.passport_serial
				WHERE person_team.outgoing = @outgoing AND person_team_metadata.account_number_registered_in_military_id = 1)) THEN 1 
			ELSE 0 
		END AS BIT)

		INSERT INTO @databases(outgoing, team, person_count, is_complete, date_added, statement, statement_date) VALUES(@outgoing, @team, @person_count, @is_complete, @date_added, @statement, @statement_date)
		DELETE #Temp WHERE outgoing = @outgoing
	END
	DROP TABLE #Temp

	SELECT * FROM @databases
END
/*
SELECT 
*
, (SELECT dbo.sf_GetTeamPersonCount(team.outgoing)) as person_count
, CAST(
	CASE 
		WHEN (SELECT dbo.sf_GetTeamPersonCount(team.outgoing)) >= ALL  
			   (  
				SELECT 1 
				FROM person_team    
				WHERE person_team.outgoing = team.outgoing  
			   )  
			THEN 1 
		ELSE 0 
	END AS bit) as is_complete
FROM team
*/
GO
/****** Object:  StoredProcedure [dbo].[pr_GetVTBReport]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pr_GetVTBReport]
AS
	SELECT [dbo].[person].[id] as '№'
		  ,[dbo].[person].[last_name] as 'Фамилия'
		  ,[dbo].[person].[first_name] as 'Имя'
		  ,[dbo].[person].[patronymic] as 'Отчество'
		  ,'Мужской' as 'Пол'
		  ,CONVERT(DATE, [dbo].[person].birth_date) as 'Дата рождения'
		  ,SUBSTRING([dbo].[person].[birth_place], 1, 32) as 'Место рождения'
		  ,[dbo].[person].[passport_serial] as 'серия и номер паспорта'
		  ,CONCAT([dbo].[person].[passport_issue], FORMAT([dbo].[person].[passport_issue_date], 'ddMMyy', 'en-US')) as 'Где и когда выдан'
		  ,[dbo].[person].[address] as 'Адрес проживания'
		  , 'Москва' as 'Город'
		  ,'' as 'Рабочий телефон'
		  ,'' as 'Домашний телефон'
		  ,[dbo].[person].[phone_mobile] as 'Телефон мобильный'
		  ,'' as 'Эмбоссируемое имя'
		  ,'' as 'Эмбоссируемая фамилия'
		  ,'13240' as 'Номер воинской части'
		  ,'рядовой' as 'Воинское звание'
		  ,'' as 'Эмбоссируемое название компании'
		  ,[dbo].[person].[codeword] as 'Кодовое слово'
		  ,'' as 'Поле комментариев 1'
		  ,'' as 'Адрес Email'
		  ,'НЕИЗВЕСТНО' as 'RBS'
		  ,'' as 'РЕЗЕРВ'
		  ,'' as 'РЕЗЕРВ1'
		  ,[dbo].[person_card].[account_number] as 'Номер карты'
		  ,'stop' as 'Поле конца строки'
		  ,'ИСТИНА' as 'Исполнено'
		  ,'' as 'Источник'
	  FROM [dbo].[person]
	  JOIN [dbo].[person_card] on [dbo].[person].[passport_serial] = [dbo].[person_card].[passport_serial]
GO
/****** Object:  StoredProcedure [dbo].[pr_PersonIsOrphanChanged]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_PersonIsOrphanChanged]
	@document_serial_number						AS CHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @is_orphan BIT
	SELECT @is_orphan = is_orphan FROM person_orphan WHERE passport_serial = @document_serial_number

	IF @@ROWCOUNT = 0
	BEGIN
	   INSERT INTO person_orphan(passport_serial, is_orphan) VALUES (@document_serial_number, 'true')
	   INSERT INTO action_log(action_id, metadata) VALUES (14, FORMATMESSAGE('{"document_serial_number":"%s", "is_orphan":"%i"}', @document_serial_number, CAST(CAST('true' AS BIT) AS INT)))
	END
	ELSE
	BEGIN
		UPDATE person_orphan SET is_orphan = ~@is_orphan WHERE passport_serial = @document_serial_number
		INSERT INTO action_log(action_id, metadata) VALUES (14, FORMATMESSAGE('{"document_serial_number":"%s", "is_orphan":"%i"}', @document_serial_number, CAST(~@is_orphan AS INT)))
	END
END
GO
/****** Object:  StoredProcedure [dbo].[pr_PersonTrackChanged]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_PersonTrackChanged]
	@document_serial_number						AS CHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @track BIT
	SELECT @track = track FROM person_track WHERE passport_serial = @document_serial_number

	IF @@ROWCOUNT = 0
	BEGIN
	   INSERT INTO person_track(passport_serial, track) VALUES (@document_serial_number, 'true')
	   INSERT INTO action_log(action_id, metadata) VALUES (15, FORMATMESSAGE('{"document_serial_number":"%s", "track":"%i"}', @document_serial_number, CAST(CAST('true' AS BIT) AS INT)))
	END
	ELSE
	BEGIN
		UPDATE person_track SET track = ~@track WHERE passport_serial = @document_serial_number
		INSERT INTO action_log(action_id, metadata) VALUES (15, FORMATMESSAGE('{"document_serial_number":"%s", "person_track":"%i"}', @document_serial_number, CAST(~@track AS INT)))
	END
END
GO
/****** Object:  StoredProcedure [dbo].[pr_SearchPerson]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 231118
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_SearchPerson]
(	
	@last_name NVARCHAR(MAX),
	@first_name NVARCHAR(MAX),
	@patronymic NVARCHAR(MAX),
	@passport_serial VARCHAR(12),
	@account_number VARCHAR(16)
)
AS
	SELECT * 
	FROM ft_SearchPerson(@last_name, @first_name, @patronymic, @passport_serial, @account_number)
	ORDER BY
		last_name,
		first_name,
		patronymic
GO
/****** Object:  StoredProcedure [dbo].[pr_SearchPersonToAssignCard]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 231118
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[pr_SearchPersonToAssignCard]
(	
	@last_name NVARCHAR(MAX),
	@first_name NVARCHAR(MAX),
	@patronymic NVARCHAR(MAX),
	@passport_serial VARCHAR(12)
)
AS
	SELECT * 
	FROM ft_SearchPersonToAssignCard(@last_name, @first_name, @patronymic, @passport_serial)
	ORDER BY
		last_name,
		first_name,
		patronymic
GO
/****** Object:  StoredProcedure [dbo].[pr_TransferTeam]    Script Date: 30.05.2024 10:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aragas
-- Create date: 211118
-- Description:	Изменение исходящего команды и перемещение призывников из старой в новую
-- =============================================
CREATE PROCEDURE [dbo].[pr_TransferTeam]
	@old_outgoing	AS SMALLINT,
	@new_outgoing	AS SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE team SET outgoing = @new_outgoing WHERE outgoing = @old_outgoing
	UPDATE person_team SET outgoing = @new_outgoing WHERE outgoing = @old_outgoing

	INSERT INTO action_log(action_id, metadata) VALUES (5, FORMATMESSAGE('{"old_outgoing":"%i", "new_outgoing":"%i"}', @old_outgoing, @new_outgoing))
END

GO
USE [master]
GO
ALTER DATABASE [V_23] SET  READ_WRITE 
GO
