create database imobiliaria3
go
use imobiliaria3
go
create table pessoa 
(
	pe_id		    int		    not null primary key identity,
	pe_nome			varchar(60) not null,
	pe_rg	        varchar(20)	not null unique,
	pe_cpf	        varchar(20)	not null unique,
	pe_endereco		varchar(100)not null,
	pe_cidade		varchar(60)not null,
	pe_cep          varchar(20) not null,
	pe_telefone		varchar(10)	not null,
	pe_email		varchar(30)	not null
)
go

insert into pessoa values ('lucas','123','123','asda','dasda','dasda','dasdasd','dasda')
insert into corretor values (@@IDENTITY,'1231', 'lucas', '123')
select * from corretor

create table proprietario (
	pro_id		int				not null	primary key,
	pro_profissao		varchar(100)	null,
	foreign key(pro_id) references pessoa(pe_id)
)
go


create table corretor (
	cor_id			int			not null primary key,
	cor_creci 			varchar(15)	not null,
	cor_login varchar (10) not null unique,
	cor_senha varchar (10) not null,
	foreign key(cor_id) references pessoa(pe_id)
	)
	go


create table cliente (
	cli_id			    int	      not null primary key,
	cli_profissao	varchar(15)	  not null,
	cli_renda       decimal(10,2) not null,
	foreign key(cli_id) references pessoa(pe_id)
	)
	go


create table imovel (
  imov_id int not null primary key,
   imov_tipo int not null, --1 para venda e 2 para aluguel
   imov_valor decimal(10,2),
   pro_id int not null,
   cor_id int not null,
   foreign key (pro_id) references proprietario (pro_id),
   foreign key (cor_id) references corretor (cor_id)
   )
   go


create table venda(
	vend_id		int				not null primary key identity,
	vend_valor			decimal(10,2)	not null,
	vend_entrada		decimal(10,2)   null,
	vend_qtde_parcela 	int				null,
	vend_valor_parcela decimal(10,2)   null,
	vend_dataVenda		datetime		null,
	cli_id  	int				not null,
	cor_id 	int				not null,
	imov_id			int				not null,
	foreign key(cli_id)references cliente(cli_id),
	foreign key(cor_id)references corretor(cor_id),
	foreign key(imov_id)references imovel
)
go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure addCliente
(
	@pe_nome varchar(60),
	@pe_rg varchar (20),
	@pe_cpf varchar (20),
	@pe_endereco varchar(100),
	@pe_cidade varchar(60),
	@pe_cep varchar(20),
	@pe_telefone varchar(10),
	@pe_email varchar (30),
	@cli_profissao varchar (15),
	@cli_renda decimal (10,2)
)
as
begin
insert into pessoa values (@pe_nome, @pe_rg, @pe_cpf, @pe_endereco, @pe_cidade,@pe_cep, @pe_telefone, @pe_email)
insert into cliente values (@@IDENTITY, @cli_profissao, @cli_renda)
end
------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure addCorretor
(
	@pe_nome varchar(60),
	@pe_rg varchar (20),
	@pe_cpf varchar (20),
	@pe_endereco varchar(100),
	@pe_cidade varchar(60),
	@pe_cep varchar(20),
	@pe_telefone varchar(10),
	@pe_email varchar (30),
	@cor_creci varchar(15),
	@cor_login varchar(10),
	@cor_senha varchar(10)
)
as
begin
insert into pessoa values (@pe_nome, @pe_rg, @pe_cpf, @pe_endereco, @pe_cidade,@pe_cep, @pe_telefone, @pe_email)
insert into corretor values (@@IDENTITY, @cor_creci, @cor_login, @cor_senha)
end

-----------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure addProprietario
(
	@pe_nome varchar(60),
	@pe_rg varchar (20),
	@pe_cpf varchar (20),
	@pe_endereco varchar(100),
	@pe_cidade varchar(60),
	@pe_cep varchar(20),
	@pe_telefone varchar(10),
	@pe_email varchar (30),
	@pro_profissao varchar (100)
)
as
begin
insert into pessoa values (@pe_nome, @pe_rg, @pe_cpf, @pe_endereco, @pe_cidade,@pe_cep, @pe_telefone, @pe_email)
insert into proprietario values (@@IDENTITY, @pro_profissao)
end



 alter PROCEDURE ADDBKP
    @DBORIGEM VARCHAR(500), /*Banco de dados de Origem*/
    @DBDESTINO VARCHAR(500) /*Banco de dados de destino*/
AS
BEGIN

DECLARE @DEVICE VARCHAR(500) /*RECEBE O NOME DO BACKUP*/
DECLARE @PATH VARCHAR(500) /*RECEBE O CAMINHO ONDE SERÁ SALVO O BACKUP*/

SET @DBDESTINO = 'BKPimobiliaria3'
SET @DBORIGEM = 'imobiliaria3'


/*CONCATENA NOME DO BANCO DESTINO + DATA + EXTENSÃO DE BACKUP .BAK */
SET @DEVICE =    @DBDESTINO + CAST(DATEPART (mi,GETDATE())AS CHAR(2)) + 
                CAST(DATEPART (ss,GETDATE())AS CHAR(2)) + 
                '.bak'

SET @PATH = 'C:\\Program Files\\Microsoft SQL Server\\MSSQL11.MSSQLSERVER\\MSSQL\\BACKUP\\' + @DEVICE

/*ADICIONA UM DISPOSITIVO DE BACKUP*/
EXEC sp_addumpdevice 'disk', @DEVICE ,@PATH 

/*CRIA BACKUP*/
BACKUP DATABASE @DBORIGEM TO DISK = @PATH

DECLARE @BASE VARCHAR(500) /*RECEBE CAMINHO DO BACKUP DE DADOS*/
DECLARE @LOG VARCHAR(500) /*RECEBE CAMINHO DO BACKUP DE LOG*/
DECLARE @DBORIGEMDATA VARCHAR(500) /*RETORNA BANCO DE ORIGEM + BACKUP DE DADOS*/
DECLARE @DBORIGEMLOG VARCHAR(500) /*RETORNA BANCO DE ORIGEM + BACKUP DE LOG*/

SET @BASE = 'C:\\Program Files\\Microsoft SQL Server\\MSSQL11.MSSQLSERVER\\MSSQL\\DATA\\imobiliaria3' + @DBDESTINO + '.MDF'
SET @LOG = 'C:\\Program Files\\Microsoft SQL Server\\MSSQL11.MSSQLSERVER\\MSSQL\\DATA' + @DBDESTINO + '_Log.LDF'

SET @DBORIGEMDATA = @DBORIGEM + '_Data'
SET @DBORIGEMLOG = @DBORIGEM + '_Log'
END

EXEC ADDBKP'DBORIGEM', 'DBDESTINO'