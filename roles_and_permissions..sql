-- 1. Loo admin roll ja määra täielikud õigused kogu andmebaasile
CREATE ROLE 'admin';
GRANT ALL PRIVILEGES ON doctor24.* TO 'admin';

-- 2. Loo kasutaja (user) roll ja määra ainult lugemisõigused
CREATE ROLE 'user';
GRANT SELECT ON doctor24.* TO 'user';

-- 3. Loo administraatori kasutaja ja anna talle admin roll
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY '1111';
GRANT 'admin' TO 'admin_user';

-- 4. Loo tavaline kasutaja ja anna talle user roll
CREATE USER 'regular_user'@'localhost' IDENTIFIED BY '2222';
GRANT 'user' TO 'regular_user';

-- 5. Rakenda õigused (flush privileges)
FLUSH PRIVILEGES;

-- 6. Kontrolli õigusi, kas need on õigesti määratud
-- Admini õiguste vaatamiseks:
SHOW GRANTS FOR 'admin_user'@'localhost';

-- Kasutaja õiguste vaatamiseks:
SHOW GRANTS FOR 'regular_user'@'localhost';
