-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.1
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

-- object: role_admin | type: ROLE --
-- DROP ROLE IF EXISTS role_admin;
CREATE ROLE role_admin WITH ;
-- ddl-end --

-- object: usr_gas | type: ROLE --
-- DROP ROLE IF EXISTS usr_gas;
CREATE ROLE usr_gas WITH 
	LOGIN
	ENCRYPTED PASSWORD '123456'
	ROLE role_admin;
-- ddl-end --

-- object: role_companies | type: ROLE --
-- DROP ROLE IF EXISTS role_companies;
CREATE ROLE role_companies WITH ;
-- ddl-end --

-- object: role_users | type: ROLE --
-- DROP ROLE IF EXISTS role_users;
CREATE ROLE role_users WITH ;
-- ddl-end --

-- object: role_drivers | type: ROLE --
-- DROP ROLE IF EXISTS role_drivers;
CREATE ROLE role_drivers WITH ;
-- ddl-end --

-- object: admin | type: ROLE --
-- DROP ROLE IF EXISTS admin;
CREATE ROLE admin WITH 
	LOGIN
	ENCRYPTED PASSWORD '123456'
	ROLE role_admin;
-- ddl-end --

-- object: company | type: ROLE --
-- DROP ROLE IF EXISTS company;
CREATE ROLE company WITH 
	LOGIN
	ENCRYPTED PASSWORD '123456'
	ROLE role_companies;
-- ddl-end --

-- object: driver | type: ROLE --
-- DROP ROLE IF EXISTS driver;
CREATE ROLE driver WITH 
	LOGIN
	ENCRYPTED PASSWORD '123456'
	ROLE role_drivers;
-- ddl-end --

-- object: app | type: ROLE --
-- DROP ROLE IF EXISTS app;
CREATE ROLE app WITH 
	LOGIN
	ENCRYPTED PASSWORD '123456'
	ROLE role_users;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: olha_gas | type: DATABASE --
-- -- DROP DATABASE IF EXISTS olha_gas;
-- CREATE DATABASE olha_gas
-- 	ENCODING = 'UTF8'
-- 	OWNER = usr_gas
-- ;
-- -- ddl-end --
-- 

-- object: public.tb_usr_user | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_usr_user CASCADE;
CREATE TABLE public.tb_usr_user(
	usr_id bigint NOT NULL,
	usr_name varchar(255) NOT NULL,
	usr_create_at timestamp NOT NULL DEFAULT now(),
	CONSTRAINT pk_usr_id PRIMARY KEY (usr_id)

);
-- ddl-end --
COMMENT ON COLUMN public.tb_usr_user.usr_id IS 'numero telefone';
-- ddl-end --
ALTER TABLE public.tb_usr_user OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_cmp_company | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_cmp_company CASCADE;
CREATE TABLE public.tb_cmp_company(
	cmp_id bigint NOT NULL,
	cmp_fancy varchar(255) NOT NULL,
	cmp_create_at timestamp NOT NULL DEFAULT now(),
	CONSTRAINT pk_cmp_ids PRIMARY KEY (cmp_id)
	 WITH (FILLFACTOR = 95)

);
-- ddl-end --
COMMENT ON COLUMN public.tb_cmp_company.cmp_id IS 'cnpj';
-- ddl-end --
ALTER TABLE public.tb_cmp_company OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_pay_payment | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_pay_payment CASCADE;
CREATE TABLE public.tb_pay_payment(
	pay_id serial NOT NULL,
	pay_name varchar(50) NOT NULL,
	pay_return boolean NOT NULL DEFAULT false,
	CONSTRAINT pk_pay_id PRIMARY KEY (pay_id)

);
-- ddl-end --
ALTER TABLE public.tb_pay_payment OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_bus_business | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_bus_business CASCADE;
CREATE TABLE public.tb_bus_business(
	cmp_id integer NOT NULL,
	pay_id smallint NOT NULL,
	usr_id bigint NOT NULL,
	bus_id integer NOT NULL,
	bus_amount numeric(10,2) NOT NULL,
	bus_cancel boolean NOT NULL DEFAULT false,
	bus_create_at timestamp NOT NULL DEFAULT now(),
	bus_cancel_at timestamp,
	CONSTRAINT pk_bus_ids PRIMARY KEY (cmp_id,pay_id,usr_id,bus_id)
	 WITH (FILLFACTOR = 95)

);
-- ddl-end --
ALTER TABLE public.tb_bus_business OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_cmp_pay_company_payment | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_cmp_pay_company_payment CASCADE;
CREATE TABLE public.tb_cmp_pay_company_payment(
	cmp_id bigint NOT NULL,
	pay_id smallint NOT NULL,
	CONSTRAINT pk_cmp_pay_ids PRIMARY KEY (cmp_id,pay_id)

);
-- ddl-end --
ALTER TABLE public.tb_cmp_pay_company_payment OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_cmp_pro_company_product | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_cmp_pro_company_product CASCADE;
CREATE TABLE public.tb_cmp_pro_company_product(
	cmp_id bigint NOT NULL,
	pro_id integer NOT NULL,
	cmp_pro_name varchar(50),
	cmp_pro_price numeric(5,2) NOT NULL,
	cmp_pro_weight smallint NOT NULL,
	cmp_pro_type_weight char(2) NOT NULL,
	CONSTRAINT pk_cmp_pro_ids PRIMARY KEY (cmp_id,pro_id)
	 WITH (FILLFACTOR = 90)

);
-- ddl-end --
ALTER TABLE public.tb_cmp_pro_company_product OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_ord_order | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_ord_order CASCADE;
CREATE TABLE public.tb_ord_order(
	cmp_id integer NOT NULL,
	pay_id smallint NOT NULL,
	usr_id bigint NOT NULL,
	bus_id integer NOT NULL,
	pro_id integer NOT NULL,
	ord_qtde smallint NOT NULL,
	ord_price numeric(5,2) NOT NULL,
	CONSTRAINT pk_ord_ids PRIMARY KEY (cmp_id,pay_id,usr_id,bus_id,pro_id)

);
-- ddl-end --
ALTER TABLE public.tb_ord_order OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_del_delivery | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_del_delivery CASCADE;
CREATE TABLE public.tb_del_delivery(
	cmp_id integer NOT NULL,
	pay_id smallint NOT NULL,
	usr_id bigint NOT NULL,
	bus_id integer NOT NULL,
	dri_id bigint,
	veh_id char(7),
	del_status smallint NOT NULL DEFAULT 0,
	del_status_update_at timestamp NOT NULL DEFAULT now(),
	CONSTRAINT pk_del_ids PRIMARY KEY (cmp_id,pay_id,usr_id,bus_id)

);
-- ddl-end --
COMMENT ON COLUMN public.tb_del_delivery.del_status IS '0 - enviado, 1 - direcionado, 2 - entregue, 3 - voltou';
-- ddl-end --
ALTER TABLE public.tb_del_delivery OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_dri_driver | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_dri_driver CASCADE;
CREATE TABLE public.tb_dri_driver(
	cmp_id integer NOT NULL,
	dri_id bigint NOT NULL,
	dri_name varchar(100) NOT NULL,
	CONSTRAINT pk_dri_ids PRIMARY KEY (cmp_id,dri_id)

);
-- ddl-end --
COMMENT ON COLUMN public.tb_dri_driver.dri_id IS 'cpf';
-- ddl-end --
ALTER TABLE public.tb_dri_driver OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_veh_vehicle | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_veh_vehicle CASCADE;
CREATE TABLE public.tb_veh_vehicle(
	cmp_id integer NOT NULL,
	veh_id char(7) NOT NULL,
	CONSTRAINT pk_veh_ids PRIMARY KEY (cmp_id,veh_id)

);
-- ddl-end --
COMMENT ON COLUMN public.tb_veh_vehicle.veh_id IS 'Placa';
-- ddl-end --
ALTER TABLE public.tb_veh_vehicle OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_pro_product | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_pro_product CASCADE;
CREATE TABLE public.tb_pro_product(
	pro_id serial NOT NULL,
	pro_name varchar(50) NOT NULL,
	pro_icon varchar(255),
	CONSTRAINT pk_pro_ids PRIMARY KEY (pro_id)

);
-- ddl-end --
ALTER TABLE public.tb_pro_product OWNER TO usr_gas;
-- ddl-end --

-- object: public.tb_tkn_token | type: TABLE --
-- DROP TABLE IF EXISTS public.tb_tkn_token CASCADE;
CREATE TABLE public.tb_tkn_token(
	usr_id bigint NOT NULL,
	tkn_token varchar(32) NOT NULL,
	tkn_create_at timestamp NOT NULL DEFAULT now(),
	CONSTRAINT pk_tkn_id PRIMARY KEY (usr_id)

);
-- ddl-end --
ALTER TABLE public.tb_tkn_token OWNER TO usr_gas;
-- ddl-end --

-- object: public.f_insert_delivery | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.f_insert_delivery() CASCADE;
CREATE FUNCTION public.f_insert_delivery ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN

   INSERT INTO tb_del_delivery(cmp_id, pay_id, usr_id, bus_id) VALUES (new.cmp_id, new.pay_id, new.usr_id, new.bus_id);

   RETURN new;

END;
$$;
-- ddl-end --
ALTER FUNCTION public.f_insert_delivery() OWNER TO usr_gas;
-- ddl-end --

-- object: tr_insert_delivery | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_insert_delivery ON public.tb_bus_business  ON public.tb_bus_business CASCADE;
CREATE TRIGGER tr_insert_delivery
	AFTER INSERT 
	ON public.tb_bus_business
	FOR EACH ROW
	EXECUTE PROCEDURE public.f_insert_delivery();
-- ddl-end --

-- object: fk_bus_usr_usr_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_bus_business DROP CONSTRAINT IF EXISTS fk_bus_usr_usr_id CASCADE;
ALTER TABLE public.tb_bus_business ADD CONSTRAINT fk_bus_usr_usr_id FOREIGN KEY (usr_id)
REFERENCES public.tb_usr_user (usr_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_bus_cmp_cmp_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_bus_business DROP CONSTRAINT IF EXISTS fk_bus_cmp_cmp_id CASCADE;
ALTER TABLE public.tb_bus_business ADD CONSTRAINT fk_bus_cmp_cmp_id FOREIGN KEY (cmp_id,pay_id)
REFERENCES public.tb_cmp_pay_company_payment (cmp_id,pay_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_cmp_pay_cmp_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_cmp_pay_company_payment DROP CONSTRAINT IF EXISTS fk_cmp_pay_cmp_id CASCADE;
ALTER TABLE public.tb_cmp_pay_company_payment ADD CONSTRAINT fk_cmp_pay_cmp_id FOREIGN KEY (cmp_id)
REFERENCES public.tb_cmp_company (cmp_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_cmp_pay_pay_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_cmp_pay_company_payment DROP CONSTRAINT IF EXISTS fk_cmp_pay_pay_id CASCADE;
ALTER TABLE public.tb_cmp_pay_company_payment ADD CONSTRAINT fk_cmp_pay_pay_id FOREIGN KEY (pay_id)
REFERENCES public.tb_pay_payment (pay_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_cmp_pro_cmp_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_cmp_pro_company_product DROP CONSTRAINT IF EXISTS fk_cmp_pro_cmp_id CASCADE;
ALTER TABLE public.tb_cmp_pro_company_product ADD CONSTRAINT fk_cmp_pro_cmp_id FOREIGN KEY (cmp_id)
REFERENCES public.tb_cmp_company (cmp_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_cmp_pro_pro_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_cmp_pro_company_product DROP CONSTRAINT IF EXISTS fk_cmp_pro_pro_id CASCADE;
ALTER TABLE public.tb_cmp_pro_company_product ADD CONSTRAINT fk_cmp_pro_pro_id FOREIGN KEY (pro_id)
REFERENCES public.tb_pro_product (pro_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_ord_bus_ids | type: CONSTRAINT --
-- ALTER TABLE public.tb_ord_order DROP CONSTRAINT IF EXISTS fk_ord_bus_ids CASCADE;
ALTER TABLE public.tb_ord_order ADD CONSTRAINT fk_ord_bus_ids FOREIGN KEY (cmp_id,pay_id,usr_id,bus_id)
REFERENCES public.tb_bus_business (cmp_id,pay_id,usr_id,bus_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_ord_pro_ids | type: CONSTRAINT --
-- ALTER TABLE public.tb_ord_order DROP CONSTRAINT IF EXISTS fk_ord_pro_ids CASCADE;
ALTER TABLE public.tb_ord_order ADD CONSTRAINT fk_ord_pro_ids FOREIGN KEY (cmp_id,pro_id)
REFERENCES public.tb_cmp_pro_company_product (cmp_id,pro_id) MATCH FULL
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_del_dri_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_del_delivery DROP CONSTRAINT IF EXISTS fk_del_dri_id CASCADE;
ALTER TABLE public.tb_del_delivery ADD CONSTRAINT fk_del_dri_id FOREIGN KEY (cmp_id,dri_id)
REFERENCES public.tb_dri_driver (cmp_id,dri_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_del_bus_ids | type: CONSTRAINT --
-- ALTER TABLE public.tb_del_delivery DROP CONSTRAINT IF EXISTS fk_del_bus_ids CASCADE;
ALTER TABLE public.tb_del_delivery ADD CONSTRAINT fk_del_bus_ids FOREIGN KEY (cmp_id,pay_id,usr_id,bus_id)
REFERENCES public.tb_bus_business (cmp_id,pay_id,usr_id,bus_id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_del_veh_ids | type: CONSTRAINT --
-- ALTER TABLE public.tb_del_delivery DROP CONSTRAINT IF EXISTS fk_del_veh_ids CASCADE;
ALTER TABLE public.tb_del_delivery ADD CONSTRAINT fk_del_veh_ids FOREIGN KEY (cmp_id,veh_id)
REFERENCES public.tb_veh_vehicle (cmp_id,veh_id) MATCH SIMPLE
ON DELETE RESTRICT ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_dri_cmp_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_dri_driver DROP CONSTRAINT IF EXISTS fk_dri_cmp_id CASCADE;
ALTER TABLE public.tb_dri_driver ADD CONSTRAINT fk_dri_cmp_id FOREIGN KEY (cmp_id)
REFERENCES public.tb_cmp_company (cmp_id) MATCH FULL
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_veh_cmp_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_veh_vehicle DROP CONSTRAINT IF EXISTS fk_veh_cmp_id CASCADE;
ALTER TABLE public.tb_veh_vehicle ADD CONSTRAINT fk_veh_cmp_id FOREIGN KEY (cmp_id)
REFERENCES public.tb_cmp_company (cmp_id) MATCH FULL
ON DELETE CASCADE ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_usr_tkn_id | type: CONSTRAINT --
-- ALTER TABLE public.tb_tkn_token DROP CONSTRAINT IF EXISTS fk_usr_tkn_id CASCADE;
ALTER TABLE public.tb_tkn_token ADD CONSTRAINT fk_usr_tkn_id FOREIGN KEY (usr_id)
REFERENCES public.tb_usr_user (usr_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --


