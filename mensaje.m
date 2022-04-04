function [descifrado] = mensaje(cipher,d,n)  % Desencripción
plain= power(cipher,d);
plain= mod(plain,n)+33;                      % Calculo para descifrar 
descifrado = plain; 
disp('Mensaje recibido');
disp( plain );                               % Texto plano 
end