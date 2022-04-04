function [publica,privada,ene,lon] = rsa(p,q) % Función para el algoritmo de encripcion 
disp('Generando Llaves de los Nodos');
disp('-----------------------------------------');
disp('Inicializando');

n=p*q;%Calculate value of n                   % Elementos del algoritmo RSA 
tf=(p-1)*(q-1);%Calculate value of totien function

%Calculate the value of e
x=100;e=111;
while x > 1
    e=e+1;
    x=gcd(tf,e);%Search greatest common division
end

%Calculate the value of d
i=1;
d=0;
while i > 0
    d = d+1;
    x = e*d;
    x = mod(x,20);
    if x == 1
       i = 0; 
    end
end
publica = e;
privada = d;
ene     = n;                                                 % Retornos de la función 
lon=length(num2str(publica))+length(num2str(privada))+1;


disp(['Llave pública {',num2str(publica),',',num2str(n),'},']); % Mensajes para usuario
disp(['Llave privada {',num2str(privada),',',num2str(n),'},']);
%msgbox(['Llave pública {',num2str(e),',',num2str(n),'},/n Llave privada {',num2str(d),',',num2str(n),'},'],'Llaves');
%list = {['Llave pública {',num2str(e),',',num2str(n),'},'],['Llave privada {',num2str(d),',',num2str(n),'},']};
%[indx,tf] = listdlg('ListString',list);}
disp('-----------------------------------------');
pause(0.1)
end
