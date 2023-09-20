/* Populate database with sample data. */
--DAY 01
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (1,'Agumon','2020-02-03',0,'t',10.23);
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (2,'Gabumon','2018-11-15',2,'t',8.0);
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (3,'Pikachu','2021-01-07',1,'f',15.04);
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (4,'Devimon','2017-05-12',5,'t',11.0);
--DAY 02
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES 
  (5,'Charmander','2020-02-08',0,'f', -11),
  (6,'Plantmon','2021-11-15',2,'t', -5.7),
  (7,'Squirtle','1993-04-02',3,'f', -12.13),
  (8,'Angemon','2005-06-12',1,'t', -45),
  (9,'Boarmon','2005-06-07',7,'t', 20.4),
  (10,'Blossom','1998-10-13',3,'t', 17),
  (11,'Ditto','2022-05-14',4,'t', 22);

--DAY 03
INSERT INTO owners (full_name, age) 
VALUES 
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

INSERT INTO species (name) VALUES ('Pokemon'), ('Digimon');

UPDATE animals
SET species_id = CASE
  WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
  ELSE (SELECT id FROM species WHERE name = 'Pokemon')
END;

--Modify your inserted animals to include owner information
UPDATE animals
SET owner_id = CASE
  WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
  WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
  WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
  WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
  WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END;