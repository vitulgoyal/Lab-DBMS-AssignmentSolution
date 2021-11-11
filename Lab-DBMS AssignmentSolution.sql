create database ecommerce;  
use ecommerce;

CREATE TABLE IF NOT EXISTS Supplier (
    SUPP_ID INT PRIMARY KEY,
    SUPP_NAME VARCHAR(50),
    SUPP_CITY VARCHAR(50),
    SUPP_PHONE VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS Customer (
    CUS_ID INT NOT NULL,
    CUS_NAME VARCHAR(50) NULL DEFAULT NULL,
    CUS_PHONE VARCHAR(10),
    CUS_CITY VARCHAR(50),
    CUS_GENDER CHAR,
    PRIMARY KEY (CUS_ID)
);

CREATE TABLE IF NOT EXISTS Category (
    CAT_ID INT NOT NULL PRIMARY KEY,
    CAT_NAME VARCHAR(255) NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS Product (
    PRO_ID INT PRIMARY KEY,
    PRO_NAME VARCHAR(255) NULL DEFAULT NULL,
    PRO_DESC VARCHAR(255) NULL DEFAULT NULL,
    CAT_ID INT NOT NULL,
    FOREIGN KEY (CAT_ID)
        REFERENCES CATEGORY (CAT_ID)
);

CREATE TABLE IF NOT EXISTS ProductDetails (
    PROD_ID INT PRIMARY KEY,
    PRO_ID INT NOT NULL,
    SUPP_ID INT NOT NULL,
    PRICE INT NOT NULL,
    FOREIGN KEY (PRO_ID)
        REFERENCES PRODUCT (PRO_ID),
    FOREIGN KEY (SUPP_ID)
        REFERENCES SUPPLIER (SUPP_ID)
);

CREATE TABLE IF NOT EXISTS `Order` (
    ORD_ID INT PRIMARY KEY,
    ORD_AMOUNT INT NOT NULL,
    ORD_DATE DATE,
    CUS_ID INT NOT NULL,
    PROD_ID INT NOT NULL,
    FOREIGN KEY (PROD_ID)
        REFERENCES PRODUCTDETAILS (PROD_ID),
    FOREIGN KEY (CUS_ID)
        REFERENCES CUSTOMER (CUS_ID)
);

CREATE TABLE IF NOT EXISTS Rating (
    RAT_ID INT PRIMARY KEY,
    CUS_ID INT NOT NULL,
    SUPP_ID INT NOT NULL,
    RAT_RATSTARS INT NOT NULL,
    FOREIGN KEY (SUPP_ID)
        REFERENCES SUPPLIER (SUPP_ID),
    FOREIGN KEY (CUS_ID)
        REFERENCES CUSTOMER (CUS_ID)
);

INSERT INTO SUPPLIER values(1,"Rajesh Retails","Delhi", "1234567890");
INSERT INTO SUPPLIER values(2,"Appario Ltd.","Mumbai", "2589631470");
INSERT INTO SUPPLIER values(3,"Knome products","Banglore", "9785462315");
INSERT INTO SUPPLIER values(4,"Bansal Retails","Kochi", "8975463285");
INSERT INTO SUPPLIER values(5,"Mittal Ltd.","Lucknow", "7898456532");

INSERT INTO CUSTOMER values(1,"AAKASH","9999999999", "DELHI", 'M');
INSERT INTO CUSTOMER values(2,"AMAN","9785463215", "NOIDA", 'M');
INSERT INTO CUSTOMER values(3,"NEHA","9999999999", "MUMBAI", 'F');
INSERT INTO CUSTOMER values(4,"MEGHA","9994562399", "KOLKATA", 'F');
INSERT INTO CUSTOMER values(5,"PULKIT","7895999999", "LUCKNOW", 'M');

INSERT INTO CATEGORY values(1,"BOOKS");
INSERT INTO CATEGORY values(2,"GAMES");
INSERT INTO CATEGORY values(3,"GROCERIES");
INSERT INTO CATEGORY values(4,"ELECTRONICS");
INSERT INTO CATEGORY values(5,"CLOTHES");

INSERT INTO PRODUCT values(1,"GTA V","DFJDJFDJFDJFDJFJF", 2);
INSERT INTO PRODUCT values(2,"TSHIRT","DFDFJDFJDKFD", 5);
INSERT INTO PRODUCT values(3,"ROG LAPTOP","DFNTTNTNTERND", 4);
INSERT INTO PRODUCT values(4,"OATS","REURENTBTOTH", 3);
INSERT INTO PRODUCT values(5,"HARRY POTTER","NBEMCTHTJTH", 1);

INSERT INTO PRODUCTDETAILS values(1,1,2,1500);
INSERT INTO PRODUCTDETAILS values(2,3,5,30000);
INSERT INTO PRODUCTDETAILS values(3,5,1,3000);
INSERT INTO PRODUCTDETAILS values(4,2,3,2500);
INSERT INTO PRODUCTDETAILS values(5,4,1,1000);

INSERT INTO `Order` values(20,1500,"2021-10-12", 3,5);
INSERT INTO `Order` values(25,30500,"2021-09-16", 5,2);
INSERT INTO `Order` values(26,2000,"2021-10-05", 1,1);
INSERT INTO `Order` values(30,3500,"2021-08-16", 4,3);
INSERT INTO `Order` values(50,2000,"2021-10-06", 2,1);

INSERT INTO RATING values(1,2,2,4);
INSERT INTO RATING values(2,3,4,3);
INSERT INTO RATING values(3,5,1,5);
INSERT INTO RATING values(4,1,3,2);
INSERT INTO RATING values(5,4,5,4);

/* 
	3.Display the number of the customer group by their genders who have placed any order
of amount greater than or equal to Rs.3000.
*/

SELECT 
    CUS_GENDER, COUNT(CUS_GENDER)
FROM
    CUSTOMER
WHERE
    CUS_ID IN (SELECT 
            CUS_ID
        FROM
            `order`
        WHERE
            ORD_AMOUNT >= 3000)
GROUP BY CUS_GENDER;

/* 
	4. Display all the orders along with the product name ordered by a customer having
Customer_Id=2.
*/

SELECT 
    PRO_NAME, CUS_ID, ORD_ID, ORD_DATE, ORD_AMOUNT
FROM
    `order` O
        JOIN
    PRODUCTDETAILS PD ON O.PROD_ID = PD.PROD_ID
        JOIN
    PRODUCT P ON P.PRO_ID = PD.PRO_ID
WHERE
    O.CUS_ID = 2;

/* 
	5. Display the Supplier details who can supply more than one product.
*/

SELECT 
    COUNT(PD.SUPP_ID) AS Supplier_Count,
    S.SUPP_ID,
    S.SUPP_NAME,
    S.SUPP_CITY,
    S.SUPP_PHONE
FROM
    PRODUCTDETAILS PD
        JOIN
    SUPPLIER S ON S.SUPP_ID = PD.SUPP_ID
GROUP BY PD.SUPP_ID
HAVING COUNT(PD.SUPP_ID) > 1;

/* 
	6. Find the category of the product whose order amount is minimum.
*/

SELECT 
    C.CAT_ID, C.CAT_NAME, O.ORD_AMOUNT
FROM
    `ORDER` O
        JOIN
    PRODUCTDETAILS PD ON PD.PROD_ID = O.PROD_ID
        JOIN
    PRODUCT P ON P.PRO_ID = PD.PRO_ID
        JOIN
    CATEGORY C ON C.CAT_ID = P.CAT_ID
GROUP BY O.ORD_AMOUNT , C.CAT_ID , C.CAT_NAME
HAVING MIN(O.ORD_AMOUNT);

/* 
	7. Display the Id and Name of the Product ordered after “2021-10-05”.
*/

select P.PRO_ID,P.PRO_NAME from Product P
join PRODUCTDETAILS PD on PD.PRO_ID = P.PRO_ID
join `ORDER` O on O.PROD_ID = PD.PROD_ID
where O.ORD_DATE > "2021-10-05";

/* 
	8. Print the top 3 supplier name and id and their rating on the basis of their rating along
with the customer name who has given the rating
*/

select S.SUPP_ID,S.SUPP_NAME,C.CUS_NAME,R.RAT_RATSTARS from Rating R
join SUPPLIER S on S.SUPP_ID = R.SUPP_ID
join CUSTOMER C on C.CUS_ID = R.CUS_ID
ORDER BY R.RAT_RATSTARS DESC LIMIT 3;

/* 
	9. Display customer name and gender whose names start or end with character 'A'.
*/

select CUS_NAME,CUS_GENDER from CUSTOMER 
where CUS_NAME like "A%" OR CUS_NAME like "%A";

/* 
	10. Display the total order amount of the male customers.
*/

select SUM(O.ORD_AMOUNT) TOTAL_AMOUNT from CUSTOMER C, `ORDER` O
where C.CUS_ID = O.CUS_ID AND C.CUS_GENDER = 'M';

/* 
	11.  Display all the Customers left outer join with the orders.
*/

SELECT 
    *
FROM
    CUSTOMER C
        LEFT JOIN
    `ORDER` O ON O.CUS_ID = C.CUS_ID;

/* 
	12.  Display all the Customers left outer join with the orders.
*/

call RATE_SUPPLIERS;
