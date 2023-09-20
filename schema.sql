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

--DAY 03
CREATE TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name VARCHAR(150),
  age INT
);

CREATE TABLE species (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150)
);

ALTER TABLE animals
  DROP COLUMN species,
  ADD COLUMN species_id INT,
  ADD COLUMN owner_id INT,
  ADD FOREIGN KEY (species_id) REFERENCES species(id),
  ADD FOREIGN KEY (owner_id) REFERENCES owners(id);