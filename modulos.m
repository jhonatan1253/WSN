function [mensaje]=modulos(P,e,n)  % Método para cifrar 
c = double(P);

cipher= power(c,e);                % Cálculo de mensaje cifrado 
cipher= mod(cipher,n);
mensaje = cipher; 
disp('Mensaje Cifrado: ')
disp(cipher)                       % Impresión de mensaje cifrado 
end