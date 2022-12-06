create database ida_statement;
DROP DATABASE ida_statement;
use ida_statement;

-- TABLA AUXILIAR GENERAL

/*DROP TABLE ida_statement_credits_grants;
CREATE TABLE ida_statement_credits_grants (
	id_ida_statement_credits_grants int auto_increment not null,
	credit_number varchar(45) not null,
    region varchar(30) not null,
    country_code varchar(15) not null, 
	country varchar(50) not null, 
	borrower varchar (60) not null,
    credit_status varchar(45) not null, 
	currency_of_commitment varchar(15) not null, 
	project_id varchar(45) not null,
	project_name varchar (60) not null,
	original_principal_amount decimal(20,3) not null,
    cancelled_amount decimal(20,3) not null, 
	undisbursed_amount decimal(20,3) not null,
	disbursed_amount decimal(20,3) not null, 
	repaid_to_ida decimal(20,3) not null, 
	due_to_ida decimal(20,3) not null,
	exchange_adjustment decimal(20,3) not null, 
	borrower_s_obligation decimal(20,3) not null,
	sold_3rd_party decimal(20,3) not null,
	repaid_3rd_party decimal(20,3) not null, 
	due_3rd_party decimal(20,3) not null, 
	credits_held decimal(20,3) not null,
    first_repayment_date datetime not null, 
    last_repayment_date datetime not null,
    effective_date_most_recent_ datetime not null, 
	closed_date_most_recent_ datetime not null,
	last_disbursement_date datetime,
    primary key(id_ida_statement_credits_grants)
) engine = innoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

TRUNCATE TABLE ida_statement_credits_grants;*/

-- Normalización:

CREATE TABLE country (
idCountry int auto_increment not null,
country varchar(40) not null,
primary key (idCountry)
)engine = innoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;
DROP TABLE country;

DROP TABLE IF EXISTS region;
CREATE TABLE IF NOT EXISTS region( 
	idRegion int not null auto_increment,
	region varchar(40) not null,
    countryCode varchar(20) not null,
	country varchar(40) not null,
    primary key (idRegion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO region (idRegion, region, countryCode, country)
SELECT DISTINCT 0, region, country_code, country FROM ida_statement_credits_grants;

DROP TABLE IF EXISTS borrower;
CREATE TABLE IF NOT EXISTS borrower( 
	idBorrower int not null auto_increment,
	borrower varchar (60) not null,
    country varchar(40) not null,
	borrower_s_obligation decimal(20,3) not null,
    primary key (idBorrower)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO borrower (idBorrower, borrower, country, borrower_s_obligation)
SELECT DISTINCT 0, borrower, country, borrower_s_obligation FROM ida_statement_credits_grants;

CREATE TABLE project(
IdProject int auto_increment not null,
projectKey varchar(45) not null,
projectName varchar (60) not null,
country varchar(40) not null,
region varchar(40) not null,
originalPrincipalAmount decimal(20,3) not null,
primary key(IdProject)
)engine = innoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;

INSERT INTO project (IdProject, projectKey, projectName, country, region, originalPrincipalAmount)
SELECT DISTINCT 0, project_id, project_name, country, region, original_principal_amount FROM ida_statement_credits_grants;

CREATE TABLE credit(
idCredit int not null auto_increment,  
creditNumber varchar(45) not null,
idProject int,
projectKey varchar(45) not null,
projectName varchar (60) not null,
idCountry int,
country varchar(40) not null,
idRegion int,
region varchar(40) not null,
idBorrower int,
borrower varchar (60) not null,
creditStatus varchar(45) not null,
originalPrincipalAmount decimal(20,3) not null,
cancelledAmount decimal(20,3) not null, 
undisbursedAmount decimal(20,3) not null,
disbursedAmount decimal(20,3) not null, 
repaidtoIda decimal(20,3) not null, 
duetoIda decimal(20,3) not null,
sold3rdParty decimal(20,3) not null,
repaid3rdParty decimal(20,3) not null, 
creditsHeld decimal(20,3) not null,
firstRepaymentDate datetime not null, 
lastRepaymentDate datetime not null,
effectiveDateMostRecent datetime not null, 
closedDateMostRecent datetime not null,
lastDisbursementDate datetime,
primary key (idCredit)
)engine = innoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;
drop table credit;

INSERT INTO credit 
	(idCredit, creditNumber, idProject, projectKey, projectName, idCountry, country, idRegion, region, idBorrower, borrower, creditStatus, originalPrincipalAmount, cancelledAmount, undisbursedAmount, disbursedAmount, repaidtoIda, duetoIda, sold3rdParty, repaid3rdParty, creditsHeld, firstRepaymentDate, lastRepaymentDate, effectiveDateMostRecent,closedDateMostRecent,lastDisbursementDate)
SELECT DISTINCT 0, credit_number,null, project_id, project_name,null,country,null,region,
				null, borrower,credit_status, original_principal_amount, cancelled_amount, 
                undisbursed_amount, disbursed_amount, repaid_to_ida, due_to_ida, sold_3rd_party, 
                repaid_3rd_party, credits_held, first_repayment_date, last_repayment_date, 
                effective_date_most_recent_, closed_date_most_recent_, last_disbursement_date
FROM ida_statement_credits_grants ida;

UPDATE credit
	JOIN country
    ON credit.country = country.country
    SET credit.idCountry = country.idCountry;
    
UPDATE credit c 
	JOIN project p
    ON c.projectName = p.projectName
    SET c.idProject = p.idProject;
    
UPDATE credit c
	JOIN region r
    ON c.region = r.region
    SET c.idRegion = r.idRegion;
    
UPDATE credit c
	JOIN borrower b
    ON c.borrower = b.borrower
    SET c.idBorrower = b.idBorrower;
    
CREATE TABLE creditstatus (
idCreditStatus int auto_increment not null,
creditStatus varchar(40) not null,
primary key (idCreditStatus)
)engine = innoDB default charset=utf8mb4 collate=utf8mb4_spanish_ci;
DROP TABLE creditstatus;

ALTER TABLE credit ADD idCreditStatus int; -- after borrower;

UPDATE credit c
	JOIN creditstatus cs
    ON c.creditStatus = cs.creditStatus
    SET c.idCreditStatus = cs.idcreditStatus;

ALTER TABLE credit MODIFY COLUMN idCreditStatus int AFTER borrower;

ALTER TABLE borrower ADD idCountry int AFTER borrower;
UPDATE borrower b
	JOIN country c
    ON b.country = c.country
    SET b.idCountry = c.idCountry;
    
ALTER TABLE credit MODIFY COLUMN idCreditStatus int AFTER borrower;

ALTER TABLE project ADD idCountry int AFTER projectName;
UPDATE project p
	JOIN country c
    ON p.country = c.country
    SET p.idCountry = c.idCountry;

-- INDEX

ALTER TABLE credit ADD INDEX (idCountry);
ALTER TABLE credit ADD INDEX (country);
ALTER TABLE credit ADD INDEX (idProject);
ALTER TABLE credit ADD INDEX (projectKey);
ALTER TABLE credit ADD INDEX (idRegion);
ALTER TABLE credit ADD INDEX (idBorrower);

ALTER TABLE borrower ADD INDEX (idCountry);
ALTER TABLE borrower ADD INDEX (country);

ALTER TABLE project ADD INDEX (projectKey);
ALTER TABLE project ADD INDEX (idCountry);
ALTER TABLE project ADD INDEX (country);

/*

SELECT * FROM ida_statement.ida_statement_credits_grants;

select * 
from ida_statement_credits_grants 
where currency_of_commitment != "USD"; -- Todo fue en USD toncs esta columna se borra

select * 
from ida_statement_credits_grants 
where project_id = 'P006582' ; 

select exchange_adjustment
from ida_statement_credits_grants 
order by exchange_adjustment; -- se borra esta columna porque esta llena de 0.000

select sold_3rd_party
from ida_statement_credits_grants 
order by sold_3rd_party desc; 

select due_3rd_party
from ida_statement_credits_grants 
order by due_3rd_party; -- se borra porque tambien esta llena de 0.000

select credits_held
from ida_statement_credits_grants 
order by credits_held desc;


SELECT *, COUNT(*) FROM ida_statement_credits_grants
     GROUP BY project_id 
     HAVING COUNT(*)>1; -- cuenta los respetidos de project id que salen mas de 1 vez

*/

