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

--DAY 04
/* -- QUERIES with ORDER BY and GROUP BY -- */
/*Who was the last animal seen by William Tatcher?*/
SELECT a.name FROM animals a RIGHT JOIN visits v 
  ON a.id = v.animal_id 
  WHERE v.vet_id = 1
  ORDER BY v.visit_date DESC
  LIMIT 1;
/*How many different animals did Stephanie Mendez see?*/
SELECT COUNT(DISTINCT a.id) AS num_animals
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';
/*List all vets and their specialties, including vets with no specialties.*/
SELECT v.name, z.name
FROM vets v
LEFT JOIN specializations s ON v.id = s.vet_id
LEFT JOIN species z ON s.species_id = z.id;
/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.*/
SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez' AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';
/*What animal has the most visits to vets?*/
SELECT a.name, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY v.animal_id, a.name
ORDER BY visit_count DESC
LIMIT 1;
/*Who was Maisy Smith's first visit?*/
SELECT a.name
FROM visits v
JOIN vets b ON v.vet_id = b.id
JOIN animals a ON v.animal_id = a.id
WHERE b.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;
/*Details for most recent visit: animal information, vet information, and date of visit.*/
SELECT a.name AS animal_name, b.name AS vet_name, v.visit_date AS date
FROM visits v
JOIN vets b ON v.vet_id = b.id
JOIN animals a ON v.animal_id = a.id
ORDER BY v.visit_date DESC
LIMIT 1;
/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT COUNT(*)
FROM visits v
JOIN vets b ON v.vet_id = b.id
JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations s ON b.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;
/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT species.name AS specialty
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
LEFT JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) DESC
LIMIT 1;