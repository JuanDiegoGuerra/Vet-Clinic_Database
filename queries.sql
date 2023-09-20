/*Queries that provide answers to the questions from all projects.*/

--DAY 01
/* Find all animals whose name ends in "mon" */
SELECT * FROM animals WHERE name LIKE '%mon';

/* List the name of all animals born between 2016 and 2019 */
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts */
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

/* List the date of birth of all animals named either "Agumon" or "Pikachu" */
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

/* List name and escape attempts of animals that weigh more than 10.5kg */
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/* Find all animals that are neutered */
SELECT * FROM animals WHERE neutered = true;

/* Find all animals not named Gabumon */
SELECT * FROM animals WHERE name NOT IN ('Gabumon');

/* Find all animals with a weight between 10.4kg and 17.3kg */
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

--DAY 02
/* Inside a transaction update the animals table by setting the species column to unspecified. 
Verify that change was made. 
Then roll back the change and verify that the species columns went back to the state before the transaction. */
BEGIN;
UPDATE animals
SET species = 'unspecified';
/*Check changes*/
SELECT * FROM animals; 
ROLLBACK;
/*Check that table is restored to the state before the transaction*/
SELECT * FROM animals; 

/*Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.*/
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

/*Update the animals table by setting the species column to pokemon for all animals that don't have species already set.*/
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
SELECT * FROM animals;

/* Delete all animals born after Jan 1st, 2022. */
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

/*Create a savepoint for the transaction.*/
SAVEPOINT sp01;

/*Update all animals' weight to be their weight multiplied by -1.*/
UPDATE animals
SET weight_kg = weight_kg * -1;

/*Rollback to the savepoint*/
ROLLBACK TO SAVEPOINT sp01;

/*Update all animals weights that are negative to be their weight multiplied by -1.*/
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

/* -- QUERIES -- */
/*How many animals are there?*/
SELECT COUNT(*) FROM animals;

/*How many animals have never tried to escape?*/
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;

/*Who escapes the most, neutered or not neutered animals?*/
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;

/*What is the minimum and maximum weight of each type of animal?*/
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-1-1' AND '1999-12-31' GROUP BY species;

--DAY 03
/* -- QUERIES with JOIN -- */
/*What animals belong to Melody Pond?*/
SELECT a.name 
FROM animals a
INNER JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

/*List of all animals that are pokemon (their type is Pokemon)*/
SELECT a.name 
FROM animals a
INNER JOIN species s
ON a.species_id = s.id
WHERE s.name = 'Pokemon';

/*List all owners and their animals, remember to include those that don't own any animal.*/
SELECT o.full_name, a.name 
FROM owners o
LEFT JOIN animals a
ON o.id = a.owner_id;

/*How many animals are there per species?*/
SELECT s.name, COUNT(a.name) AS total
FROM animals a
INNER JOIN species s
ON a.species_id = s.id
GROUP BY S.name

/*List all Digimon owned by Jennifer Orwell.*/
SELECT a.name 
FROM animals a
INNER JOIN owners o
ON a.owner_id = o.id
INNER JOIN species s
ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell'
AND s.name = 'Digimon';

/*List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT a.name 
FROM animals a
INNER JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester'
AND a.escape_attempts = 0;

/*Who owns the most animals?*/
SELECT o.full_name, COUNT(a.name) AS total
FROM owners o
LEFT JOIN animals a 
ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY total DESC
LIMIT 1;