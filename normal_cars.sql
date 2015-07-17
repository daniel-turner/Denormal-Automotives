CREATE USER normal_user;

CREATE DATABASE normal_cars WITH OWNER normal_user ENCODING 'utf8';

CREATE TABLE IF NOT EXISTS make
(
  id serial,
  make_code character varying(125) NOT NULL,
  make_title character varying(125) NOT NULL,
  PRIMARY KEY (id)
);


--NB should specify cascading delete behavior due to foreign key
CREATE TABLE IF NOT EXISTS model
(
 id serial,
 model_code character varying(125) NOT NULL,
 model_title character varying(125) NOT NULL,
 year integer NOT NULL,
 make_id integer NOT NULL,
 CONSTRAINT make_id_fk FOREIGN KEY (make_id) REFERENCES make (id),
 PRIMARY KEY (id)
);

\i ./scripts/denormal_data.sql

INSERT INTO make (make_code,make_title)
  SELECT DISTINCT make_code,make_title
  FROM car_models;

INSERT INTO model (model_code,model_title,year,make_id)
  SELECT val.model_code,val.model_title,val.year,f.id
  FROM (SELECT * FROM car_models) val (make_code,make_title,model_code,model_title,year)
  LEFT JOIN make f USING(make_code);

SELECT DISTINCT make_title FROM make;

SELECT DISTINCT model_title
  FROM model
  INNER JOIN make
  ON model.make_id = make.id
  WHERE make.make_code = 'VOLKS';

SELECT make.make_code,model.model_code, model.model_title,model.year
  FROM model
  INNER JOIN make
  ON model.make_id = make.id
  WHERE make.make_code = 'LAM';

SELECT make.make_title,model.model_title,model.year
  FROM model
  INNER JOIN make
  ON model.make_id = make.id
  WHERE model.year BETWEEN 2010 AND 2015;