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

--DAY 04
INSERT INTO vets (name, age, date_of_graduation) 
VALUES
  ('William Tatcher', 45, '2000-04-23'),
  ('Maisy Smith', 26, '2019-01-17'),
  ('Stephanie Mendez', 64, '1981-05-04'),
  ('Jack Harkness', 38, '2008-06-08');

INSERT INTO specializations (vet_id, species_id) 
VALUES
  (1, 1),
  (3, 2),
  (3, 1),
  (4, 2);

INSERT INTO visits (animal_id, vet_id, visit_date) 
VALUES
  (1, 1, '2020-05-24'),
  (1, 3, '2020-07-22'),
  (2, 4, '2021-02-02'),
  (3, 2, '2020-01-05'),
  (3, 2, '2020-03-08'),
  (3, 2, '2020-05-14'),
  (4, 3, '2021-05-04'),
  (5, 4, '2021-02-24'),
  (6, 2, '2019-12-21'),
  (6, 1, '2020-08-10'),
  (6, 2, '2021-04-07'),
  (7, 3, '2019-09-29'),
  (8, 4, '2020-10-03'),
  (8, 4, '2020-11-04'),
  (9, 2, '2019-01-24'),
  (9, 2, '2019-05-15'),
  (9, 2, '2020-02-27'),
  (9, 2, '2020-08-03'),
  (10, 3, '2020-05-24'),
  (10, 1, '2021-01-11');

  --Performance Audit
-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, visit_date) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

--Create indexes to improve query time
CREATE INDEX idx_animal_id ON visits (animal_id);
CREATE INDEX idx_vet_id ON visits (vet_id);
CREATE INDEX idx_email_id ON owners (email);

-- create a temporary table to improve second query
CREATE TEMPORARY TABLE temp_visits AS SELECT * FROM visits WHERE vet_id = 2;
CREATE INDEX idx_vet_id_partial ON temp_visits (vet_id);