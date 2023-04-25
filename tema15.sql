-- ACTIVIDAD 1
DECLARE
	num_entero NUMBER(2) := 33;
	caracter CHAR := "J";
	conj_carac VARCHAR2(50) := "Hola";
	fecha DATE := SYSDATE;
	bool BOOLEAN := TRUE;
BEGIN
	DBMS_OUTPUT.PUT_LINE(num_entero);
	DBMS_OUTPUT.PUT_LINE(caracter);
	DBMS_OUTPUT.PUT_LINE(conj_carac);
	DBMS_OUTPUT.PUT_LINE(fecha);
	IF bool
        THEN
			DBMS_OUTPUT.PUT_LINE("true");
	ELSE 
		DBMS_OUTPUT.PUT_LINE("false");
	END IF;
END;


-- ACTIVIDAD 2
CREATE OR REPLACE PROCEDURE p_saludo AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(" ¡Hello World!");
END;

BEGIN
    p_saludo;
END;


-- ACTIVIDAD 3
CREATE OR REPLACE PROCEDURE p_Imprimir(p_impresion IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(p_impresion);
END;

BEGIN
    p_Imprimir("Imprime por pantalla lo que se encuentra aquí");
END;


-- ACTIVIDAD 4
CREATE OR REPLACE FUNCTION f_area_circulo(p_radio NUMBER) 
	RETURN NUMBER 
IS
    v_area_circulo NUMBER;
BEGIN
    v_area_circulo := p_radio * 2 * 3.14; 
	RETURN v_area_circulo;
END;

DECLARE
    A NUMBER := f_area_circulo(5);
BEGIN
	DBMS_OUTPUT.PUT_LINE(A);
END;


-- ACTIVIDAD 5
CREATE OR REPLACE FUNCTION f_calcular_salario(p_salario_mensual NUMBER) 
	RETURN NUMBER 
IS
    v_salario_anual NUMBER;
BEGIN
    v_salario_anual := p_salario_mensual * 12; 
	RETURN v_salario_anual;
END;

DECLARE
    B NUMBER := f_calcular_salario(1000);
BEGIN
	DBMS_OUTPUT.PUT_LINE(B);
END;


-- ACTIVIDAD 6
CREATE OR REPLACE FUNCTION f_calcular_factorial(p_num IN NUMBER)
	RETURN NUMBER IS
    v_num_fac NUMBER := 1;
	i NUMBER := 1;
BEGIN
	FOR i IN reverse 1..p_num LOOP
		v_num_fac := v_num_fac * i;
	END LOOP;
	IF v_num_fac < 1000
    	THEN
    		DBMS_OUTPUT.PUT_LINE("Rango 1");
	ELSIF v_num_fac BETWEEN 1000 AND 100000
        THEN
        	DBMS_OUTPUT.PUT_LINE("Rango 2");
	ELSIF v_num_fac > 100000
        THEN
        	DBMS_OUTPUT.PUT_LINE("Rango 3");
	END IF;
	RETURN v_num_fac;
END;

DECLARE
    C NUMBER := f_calcular_factorial(10);
BEGIN
	DBMS_OUTPUT.PUT_LINE(C);
END;


-- ACTIVIDAD 7
CREATE OR REPLACE FUNCTION f_valor_pos(p_valor IN NUMBER)
	RETURN VARCHAR2 
IS
    v_valor_pos VARCHAR2(50);
BEGIN
    IF p_valor > 0
    	THEN
    		v_valor_pos := "Positivo";
	ELSIF p_valor < 0
        THEN
        	v_valor_pos := "Negativo";
	ELSE
        v_valor_pos := "Cero";
	END IF;
	RETURN v_valor_pos;
END;

DECLARE
    C VARCHAR2(50) := f_valor_pos(0);
BEGIN
	DBMS_OUTPUT.PUT_LINE(C);
END;


-- ACTIVIDAD 8
CREATE OR REPLACE FUNCTION f_suma_pares(p_num IN NUMBER)
	RETURN VARCHAR2 IS
    v_num_par NUMBER := 0;
	i NUMBER := 1;
BEGIN
	FOR i IN 1..p_num LOOP
    	CASE MOD(i, 2)
    		WHEN 0
        		THEN DBMS_OUTPUT.PUT_LINE("Número par : " || i);
    				v_num_par := v_num_par + i;
			ELSE DBMS_OUTPUT.PUT_LINE("Número impar : " || i);
    	END CASE;       
	END LOOP;
	RETURN "La suma de números pares hasta " || p_num || " es : " || v_num_par;
END;

DECLARE
    C VARCHAR2(1000) := f_suma_pares(10);
BEGIN
	DBMS_OUTPUT.PUT_LINE(C);
END;
