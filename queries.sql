/*Queries that provide answers to the questions from all projects.*/
SELECT * from animals WHERE name Like '%mon';
SELECT name from animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name from animals WHERE neutered = true  AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered = true;
SELECT * from animals WHERE name <>'Gabumon';
SELECT * from animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;


BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

-- Delete all records & creates a savepoint for transaction
BEGIN;
DELETE FROM animals; 
ROLLBACK; 

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete_animals;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT delete_animals;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- Queries for a few questions
SELECT COUNT(*) FROM animals;

SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) 
FROM animals 
WHERE EXTRACT(YEAR FROM date_of_birth) 
BETWEEN 1990 AND 2000 
GROUP BY species;


-- Write queries (using JOIN) to answer the following questions:

-- What animals belong to Melody Pond?
SELECT o.full_name, a.name 
FROM owners o 
INNER JOIN animals a 
ON o.owner_id = a.owners_id
WHERE o.full_name LIKE 'Melody Pond';

-- List of all animals that are pokemon 
SELECT a.name 
FROM species s 
INNER JOIN animals a
ON s.specie_id = a.species_id
WHERE s.name LIKE 'Pokemon';

-- List all owners and their animals (remember to include those that don't own any animal)
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a
ON o.owner_id = a.owners_id;

-- How many animals are there per species?
SELECT s.name, COUNT(a.species_id) As num
FROM species s
FULL JOIN animals a
ON s.specie_id = a.species_id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell
SELECT o.full_name, a.name AS Digimon
FROM owners o
LEFT JOIN animals a
ON o.owner_id = a.owners_id
LEFT JOIN species S
ON S.specie_id = a.species_id
WHERE o.full_name LIKE 'Jennifer Orwell'
AND S.name LIKE 'Digimon'

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT o.full_name, a.name
FROM owners O 
INNER JOIN animals A
ON O.owner_id = A.owners_id
INNER JOIN species S
ON S.specie_id = A.species_id
WHERE full_name LIKE 'Dean Winchester'
AND A.escape_attempts = 0;

-- Who owns the most animals?
SELECT O.full_name, COUNT(*) 
FROM owners O
JOIN animals A
ON O.owner_id = A.owners_id
GROUP BY O.full_name
HAVING COUNT(*)> 2;
