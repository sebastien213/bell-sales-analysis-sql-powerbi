
-- Création de la base
CREATE DATABASE bell_ventes;
\c bell_ventes;

-- Clients
CREATE TABLE clients (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    province VARCHAR(50)
);

-- Produits et services
CREATE TABLE produits_services (
    id_produit SERIAL PRIMARY KEY,
    nom_produit VARCHAR(100),
    type VARCHAR(50),  -- Mobile, Internet, TV, Appareil
    prix DECIMAL(10,2)
);

-- Ventes
CREATE TABLE ventes (
    id_vente SERIAL PRIMARY KEY,
    id_client INT REFERENCES clients(id_client),
    id_produit INT REFERENCES produits_services(id_produit),
    quantite INT,
    date_vente DATE
);

-- Données clients
INSERT INTO clients (nom, province) VALUES
('Alice Tremblay', 'Québec'),
('Marc Dupuis', 'Ontario'),
('Léa Fortin', 'Québec'),
('John Smith', 'Alberta');

-- Produits/services
INSERT INTO produits_services (nom_produit, type, prix) VALUES
('Forfait Mobile 20 Go', 'Mobile', 65.00),
('Internet Fibe 500', 'Internet', 85.00),
('Télé Fibe Premium', 'TV', 60.00),
('iPhone 15', 'Appareil', 1200.00),
('Routeur Wi-Fi 6', 'Appareil', 200.00);

-- Ventes simulées
INSERT INTO ventes (id_client, id_produit, quantite, date_vente) VALUES
(1, 1, 1, '2025-06-01'),
(1, 4, 1, '2025-06-01'),
(2, 2, 1, '2025-06-10'),
(3, 3, 1, '2025-07-01'),
(4, 1, 1, '2025-07-05'),
(2, 5, 1, '2025-07-08'),
(3, 1, 1, '2025-07-15'),
(1, 2, 1, '2025-08-01');

-- ANALYSES

-- 1. Chiffre d’affaires total
SELECT SUM(ps.prix * v.quantite) AS chiffre_affaires_total
FROM ventes v
JOIN produits_services ps ON v.id_produit = ps.id_produit;

-- 2. Chiffre d’affaires par type de service
SELECT ps.type, SUM(ps.prix * v.quantite) AS chiffre_affaires
FROM ventes v
JOIN produits_services ps ON v.id_produit = ps.id_produit
GROUP BY ps.type
ORDER BY chiffre_affaires DESC;

-- 3. Revenus mensuels
SELECT TO_CHAR(date_vente, 'YYYY-MM') AS mois, SUM(ps.prix * v.quantite) AS chiffre_affaires
FROM ventes v
JOIN produits_services ps ON v.id_produit = ps.id_produit
GROUP BY mois
ORDER BY mois;

-- 4. Clients les plus rentables
SELECT c.nom, SUM(ps.prix * v.quantite) AS total_depense
FROM ventes v
JOIN produits_services ps ON v.id_produit = ps.id_produit
JOIN clients c ON v.id_client = c.id_client
GROUP BY c.nom
ORDER BY total_depense DESC;

-- 5. Produits les plus vendus
SELECT ps.nom_produit, COUNT(*) AS nb_ventes, SUM(ps.prix * v.quantite) AS total_revenu
FROM ventes v
JOIN produits_services ps ON v.id_produit = ps.id_produit
GROUP BY ps.nom_produit
ORDER BY total_revenu DESC;
