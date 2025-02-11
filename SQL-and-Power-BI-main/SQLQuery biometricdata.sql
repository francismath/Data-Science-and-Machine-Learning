-- Step 1: design a database schema to store data
-- Create the 'Users' table to store user information
Create table Users (
UserID int primary key,
Firstname Varchar(50),
Lastname Varchar(50),
Email Varchar(100),
birthdate date,
Gender Nvarchar(10)
);

--Create the 'BiometricData' table to store different types of biometric data
Create table BiometricData (
DataID int Primary Key,
UserID int,
DataType Nvarchar(50),
Timestamp Datetime,
Value Decimal(10, 2 ),
foreign key (UserID) References Users(UserID)
);

-- Indexes for faster querying
create index idx_BiometricData_UserID on BiometricData(UserID);
create index idx_BiometricData_DataType on BiometricData(DataType);
create index idx_BiometricData_Timestamp on BiometricData(Timestamp);

-- Step 2: data preprocessing





