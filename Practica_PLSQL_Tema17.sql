--Creamos la base de datos

CREATE TABLE Trabajadores (
dni varchar2(9) PRIMARY KEY,
nombre varchar2(50),
dni_jefe varchar2(9),
num_departamento integer,
salario number(9,2) DEFAULT 1000,
usuario varchar2(50),
fecha date,
FOREIGN KEY (dni_jefe) REFERENCES Trabajadores (dni)
);
INSERT INTO Trabajadores (dni, nombre, dni_jefe, num_departamento, salario, usuario, fecha)
VALUES ('11111111A', 'Juan Pérez', null, 1, 1500, 'jperez', TO_DATE('2023-04-10', 'YYYY-MM-
DD')); 
INSERT INTO Trabajadores (dni, nombre, dni_jefe, num_departamento, salario, usuario, fecha)
VALUES ('22222222B', 'María López', '11111111A', 1, 1200, 'mlopez', TO_DATE('2023-04-10',
'YYYY-MM-DD')); 
INSERT INTO Trabajadores (dni, nombre, dni_jefe, num_departamento, salario, usuario, fecha)
VALUES ('33333333C', 'Pedro García', '11111111A', 1, 1000, 'pgarcia', TO_DATE('2023-04-10',
'YYYY-MM-DD')); 
INSERT INTO Trabajadores (dni, nombre, dni_jefe, num_departamento, salario, usuario, fecha)
VALUES ('44444444D', 'Ana Martínez', '11111111A', 1, 1100, 'amartinez', TO_DATE('2023-04-
10', 'YYYY-MM-DD'));

SELECT * FROM Trabajadores;

CREATE TABLE SalariosLog (
dni varchar2(9),
salario_anterior number(9,2),
salario_nuevo number(9,2),
usuario varchar2(50) DEFAULT USER,
fecha_modificacion date,
FOREIGN KEY (dni) REFERENCES Trabajadores (dni)
);

CREATE TABLE trabajadores_log(
    id_log NUMBER GENERATED ALWAYS AS IDENTITY,
    usuario_que_modifica VARCHAR2(50),
    usuario_modificado VARCHAR2(50),
    fecha_modificacion DATE,
    tipo_dml CHAR(1),
    antiguo_valor VARCHAR2(100),
    nuevo_valor VARCHAR2(100)
);


--Ejercicio 1

create or replace  TRIGGER tr_error_jefe_supervisa_mas_3_trabajadores
BEFORE INSERT OR UPDATE ON Trabajadores
FOR EACH ROW
DECLARE
    v_cont INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_cont 
    FROM trabajadores WHERE dni_jefe = :new.dni_jefe;
    IF v_cont >= 3 THEN
        raise_application_error(-20600, 'Un jefe no puede supervisar más de 3 empleados.');
    END IF;
END;

--Ejercicio 2

create or replace  TRIGGER tr_impedir_aumento_salario
BEFORE UPDATE OF salario ON trabajadores
FOR EACH ROW
DECLARE
  salario_viejo NUMBER;
BEGIN
  salario_viejo := :OLD.salario;
  IF :NEW.salario > salario_viejo * 1.095 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El aumento de salario no puede ser mayor al 9.5%.');
  END IF;
END;

-- Ejercicio 3

CREATE OR REPLACE TRIGGER tr_aumento_salario
BEFORE UPDATE ON Trabajadores
FOR EACH ROW
BEGIN
if
   IF (:old.salario != :new.salario)  THEN INSERT INTO SalariosLog(dni, salario_anterior, salario_nuevo, usuario, fecha_modificacion)
        VALUES(:OLD.dni, :OLD.salario, :NEW.salario, user, sysdate);
    END IF;
END;

UPDATE Trabajadores 
SET salario = 1400 WHERE dni LIKE '22222222B';

UPDATE Trabajadores 
SET nombre = 'María Isabel' WHERE dni LIKE '22222222B';

SELECT *
FROM SalariosLog;

-- Ejercicio 4

CREATE OR REPLACE TRIGGER tr_trabajadores_log
BEFORE INSERT OR UPDATE OR DELETE ON Trabajadores
FOR EACH ROW
DECLARE
    
    v_antiguo_valor VARCHAR2(50);
    v_dml_type VARCHAR2(1);  --Sería mejor utilizar un char(1)
    v_nuevo_valor VARCHAR2(50);
BEGIN
    IF DELETING THEN
        v_dml_type := 'D';
    ELSIF INSERTING THEN
        v_dml_type := 'I';
    ELSE
        v_dml_type := 'U';
    END IF;
    v_antiguo_valor := :old.dni || ',' || :old.nombre || ',' || :old.dni_jefe || ',' || :old.num_departamento || ',' || :old.salario || ',' || :old.usuario || ',' || :old.fecha;
    v_nuevo_valor := :new.dni || ',' || :new.nombre || ',' || :new.dni_jefe || ',' || :new.num_departamento || ',' || :new.salario || ',' || :new.usuario || ',' || :new.fecha;
    INSERT INTO trabajadores_log (usuario_que_modifica, usuario_modificado, fecha_modificacion, tipo_dml, antiguo_valor, nuevo_valor)
        VALUES (user, :old.usuario, sysdate, v_dml_type, v_antiguo_valor, v_nuevo_valor);
END;

UPDATE Trabajadores SET nombre = 'Javier' WHERE dni LIKE '22222222B';
SELECT * FROM trabajadores_log;



