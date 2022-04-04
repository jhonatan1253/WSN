function [potencia]=enlace(f,ptx,Grx,Gtx,d)               % Función para calculo de alcance de nodo

perdida = (32.4 + 20*log10(d) + 20*log10(f) - Gtx - Grx); % pérdida por free Space 
potencia = ptx - perdida;                                 % Retorno de la función 
end 