-- Andmebaasi loomine
CREATE DATABASE IF NOT EXISTS doctor24 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE doctor24;

-- Users tabel
CREATE TABLE users (
                       id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                       email VARCHAR(191) NOT NULL UNIQUE,         -- Unikaalne e-posti aadress
                       password VARCHAR(255) NOT NULL,             -- Parooli salvestamiseks
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Lisamise aeg
) ENGINE=InnoDB;

-- Doctors tabel
CREATE TABLE doctors (
                         id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                         user_id INT UNSIGNED NOT NULL,              -- Viide kasutajale
                         name VARCHAR(191) NOT NULL,                 -- Arsti nimi
                         speciality VARCHAR(191) NOT NULL,           -- Eriala
                         age SMALLINT UNSIGNED NOT NULL,             -- Vanus
                         price_per_minute DECIMAL(10, 2) NOT NULL,   -- Hind minutis
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Lisamise aeg
                         FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- Võõrvõti kasutajale
) ENGINE=InnoDB;

-- Appointments tabel (videokõned)
CREATE TABLE appointments (
                              id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                              doctor_id INT UNSIGNED NOT NULL,            -- Viide arstile
                              user_id INT UNSIGNED NOT NULL,              -- Viide kasutajale
                              appointment_time DATETIME NOT NULL,         -- Kohtumise aeg
                              duration_minutes SMALLINT UNSIGNED NOT NULL, -- Kõne kestus minutites
                              total_cost DECIMAL(10, 2) NOT NULL,         -- Kokku makstud hind
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Lisamise aeg
                              FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE, -- Viide arstile
                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- Viide kasutajale
) ENGINE=InnoDB;

-- Languages tabel (suhtluskeeled)
CREATE TABLE languages (
                           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                           name VARCHAR(191) NOT NULL UNIQUE           -- Keele nimi (nt "Inglise", "Eesti")
) ENGINE=InnoDB;

-- Doctor_languages tabel (arsti ja keelte seosed)
CREATE TABLE doctor_languages (
                                  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                                  doctor_id INT UNSIGNED NOT NULL,            -- Viide arstile
                                  language_id INT UNSIGNED NOT NULL,          -- Viide keelele
                                  FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE, -- Viide arstile
                                  FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE -- Viide keelele
) ENGINE=InnoDB;

-- Reviews tabel (tagasiside arstide kohta)
CREATE TABLE reviews (
                         id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                         doctor_id INT UNSIGNED NOT NULL,            -- Viide arstile
                         user_id INT UNSIGNED NOT NULL,              -- Viide kasutajale
                         rating TINYINT UNSIGNED NOT NULL,           -- Hinnang (1-5)
                         comment TEXT,                               -- Kommentaar
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Lisamise aeg
                         FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE, -- Viide arstile
                         FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- Viide kasutajale
) ENGINE=InnoDB;

-- Locations tabel (asukohad)
CREATE TABLE locations (
                           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                           country VARCHAR(191) NOT NULL,              -- Riik
                           city VARCHAR(191) NOT NULL                  -- Linn
) ENGINE=InnoDB;

-- Doctors_locations tabel (arsti ja asukoha seosed)
CREATE TABLE doctor_locations (
                                  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Primaarvõti AUTO_INCREMENT ja UNSIGNED
                                  doctor_id INT UNSIGNED NOT NULL,            -- Viide arstile
                                  location_id INT UNSIGNED NOT NULL,          -- Viide asukohale
                                  FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE, -- Viide arstile
                                  FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE -- Viide asukohale
) ENGINE=InnoDB;
