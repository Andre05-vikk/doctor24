-- Logitabel muudatuste salvestamiseks
CREATE TABLE users_log (
                           id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                           user_id INT UNSIGNED NOT NULL,
                           old_email VARCHAR(191),
                           new_email VARCHAR(191),
                           old_password VARCHAR(255),
                           new_password VARCHAR(255),
                           changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           changed_by VARCHAR(191)
);

-- AFTER UPDATE trigger
CREATE TRIGGER after_users_update
    AFTER UPDATE ON users
    FOR EACH ROW
BEGIN
    INSERT INTO users_log (user_id, old_email, new_email, old_password, new_password, changed_at, changed_by)
    VALUES (
               OLD.id,
               OLD.email,
               NEW.email,
               OLD.password,
               NEW.password,
               NOW(),
               USER() -- Kasutaja nimi, kes muudatuse teeb
           );
END;

CREATE TRIGGER before_appointment_insert
    BEFORE INSERT ON appointments
    FOR EACH ROW
BEGIN
    DECLARE doctor_busy BOOLEAN;

    -- Kontrolli, kas arst on juba hõivatud mõne teise broneeringuga
    SELECT COUNT(*) > 0 INTO doctor_busy
    FROM appointments
    WHERE doctor_id = NEW.doctor_id
      AND (
        -- Overlap conditions
        (NEW.appointment_time >= appointment_time
            AND NEW.appointment_time < DATE_ADD(appointment_time, INTERVAL duration_minutes MINUTE))
            OR
        (DATE_ADD(NEW.appointment_time, INTERVAL NEW.duration_minutes MINUTE) > appointment_time
            AND DATE_ADD(NEW.appointment_time, INTERVAL NEW.duration_minutes MINUTE) <= DATE_ADD(appointment_time, INTERVAL duration_minutes MINUTE))
            OR
        (NEW.appointment_time <= appointment_time
            AND DATE_ADD(NEW.appointment_time, INTERVAL NEW.duration_minutes MINUTE) >= DATE_ADD(appointment_time, INTERVAL duration_minutes MINUTE))
        );

    -- Kui arst on hõivatud, tõsta veateade
    IF doctor_busy THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Doctor is currently in a call and cannot accept a new appointment.';
    END IF;
END;;


-- BEFORE INSERT trigger arsti hinna kontrollimiseks
CREATE TRIGGER before_doctor_insert
    BEFORE INSERT ON doctors
    FOR EACH ROW
BEGIN
    IF NEW.price_per_minute < 0.1 OR NEW.price_per_minute > 100 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Price per minute must be between $0.1 and $100.';
    END IF;
END;


