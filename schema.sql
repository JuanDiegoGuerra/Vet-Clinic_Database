/* Database schema to keep the structure of entire database. */
--DAY 01
CREATE TABLE animals(
   id 			   INT PRIMARY KEY 	 NOT NULL,
   name            VARCHAR(150) 	 NOT NULL,
   date_of_birth   DATE,
   escape_attempts INT,
   neutered        BOOLEAN,
   weight_kg	   DECIMAL(10, 2)
);

--DAY 02
ALTER TABLE animals
ADD species VARCHAR(150);
