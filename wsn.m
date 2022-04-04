tim = cputime;                          % Sentencia para medir el tiempo usado de CPU en general
llaves = zeros(1000,7);
bol =1;                                 % Arreglo para manejar una administración de las llaves generadas por cada uno de los nodos
vtx = 100 ; %kbps                       % velocidad de Tx
energia = 2200; %mA                     % Capacidad de bateria del sensor
format longEng                          % formato de numeros
umbral  = -55;                          % nivel mínimo de señal para operación
primos = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]; % números para generar la llaves para no generar números primos y consumir energía
long = length(primos);
grouplength = 10;
f = 433;                                %Frecuencia de operación para modelos de perdida y alcance
ptx = 13 ; %dBm                         %potencia de transmisión para calculo de alcace
Grx = 10;                               %Ganancia de trasmisión para calculo de perdida
Gtx = 10;                               %Ganancia de resepsión
n=1;
delim = 0;
paso = 0; 



y=input('Ingrese el número de nodos: ');% número de nodos a simular ingresados por teclado
nodosactivos = zeros(y^2,1);
nodosc = 0;
posiciones=zeros(y,3);                  % matriz para guardar valores y controlar nodos
%subplot(3,1,1)
for t=1:1:y                             % Ciclo para generar y graficar las posiciones de los nodos
    posx = randi([0 100],1,1)/10;
    posy = randi([0 100],1,1)/10;
    posiciones(t,1)=posx;               % almacenamiento de las posiciones y el estado del nodo
    posiciones(t,2)=posy;
    posiciones(t,3)= 1;
    plot(posx,posy,'g:o');              % Gráfica de los puntos y habilitación de rejilla
    hold on;
    grid on;                            % Límites de la gráfica
    xlim([0,10]);
    ylim([0,10]);
    [p,s] = title('Red de sensores inalámbricos - Jacome Jonathan','Red de Sensores Método de Flooding',... 
        'Color','blue');
    xlabel('Distancia Km')
    ylabel('Distancia Km')
end
msgbox('Distribución de sensores','MSG');
pause(n)
%subplot(3,1,2)
for n=1:1:y                             % ciclo para generar los clusters de acuerdo con el alcance de cada uno
    i=1;
    for k=1:1:y
        dist=(((posiciones(n,1)-posiciones(k,1))^2)+(posiciones(n,2)-posiciones(k,2))^2)^0.5; % Cálculo de distancia entre los nodos
        nivel = enlace(f,ptx,Grx,Gtx,dist);                                                   % Cálculo de pérdida y verificacion para el umbral
        if nivel > umbral                                                                     % Verificación de que los nodos se puedan comunicar
            aux = zeros(100,2);
            aux(i,1) = posiciones(k,1);
            aux(i,2) = posiciones(k,2);
            quiver3(aux(i,1),aux(i,2),0,posiciones(n,1)-aux(i,1),posiciones(n,2)-aux(i,2),0,'b'); % Gráfica de vector en 2 dimensiones
            tStart= cputime;                                                                      % Inicio de calculo de uso de CPU
            num = randi([1 long],1,1);
            num1 = randi([1 long],1,1);
            if (primos(num) == primos(num1))
                num = randi([1 long],1,1);
                if (primos(num) == primos(num1))                                                  % Métodos para cálculo de números primos que no se repitan
                    num1 = randi([1 long],1,1);
                end
            end
            tic
            [u,v,w,lon] = rsa(primos(num),primos(num1));                                          % Generación de llaves para encripción
            
            toc
            tEnd = cputime - tStart;                                                              % Fin de ciclo para cálculo de tiempo de CPU
            format longEng
            energia = energia - tEnd*46;                                                          % Cálculo de energía restante por nodo
            disp(['Tiempo de CPU encripción:',num2str(tEnd)]);
            disp(['Tiempo de Tx: ',num2str((lon*8)/(vtx*1000),'%.10f'),'s'])                      % Cálculo de tiempos y energía disponible
            disp(['Energía restante: ', num2str(energia,'%.10f'),'mA'])
            format longEng
            vx = ((lon*8)/(vtx*1000))+((dist*1000)/(3e8));                                        % Cálculo de tiempo en el aire
            disp(['Tiempo de Rx: ',num2str(vx,'%.10f'),'s'])
            
            llaves(n,1)= u;
            llaves(n,2)= v;
            llaves(n,3)= w;                                                                       % uso de arreglo para ordenar las llaves de vecinos de clúster
            llaves(n,4)= aux(i,1);
            llaves(n,5)= aux(i,2);
            llaves(n,6)= posiciones(n,1);
            llaves(n,7)= posiciones(n,2);
            
            i=i+1;
            
        end
        
    end
    i=1;
end
msgbox('Selección de clústers','MSG');
T=table(llaves);                                                                                % Guardado de las llaves de clúster en memoria no volatil
writetable(T,'llaves.txt');
%type llaves.txt
pause(n)
%subplot(3,1,3)
for n=1:1:y
    i=1;
    r = randi([0 1],1);
    g = randi([0 1],1);                                                                        % Ciclo para generar cluster de acuerdo a la perdida y el alcance de la potencia
    b = randi([0 1],1);
    for k=1:1:y
        dist=(((posiciones(n,1)-posiciones(k,1))^2)+(posiciones(n,2)-posiciones(k,2))^2)^0.5;
        nivel = enlace(f,ptx,Grx,Gtx,dist);
        if nivel > umbral
            aux = zeros(100,2);
            aux(i,1) = posiciones(k,1);
            aux(i,2) = posiciones(k,2);
            fig = quiver3(aux(i,1),aux(i,2),0,posiciones(n,1)-aux(i,1),posiciones(n,2)-aux(i,2),0);
            fig.Color=[r,g,b];                                                                 % Aplicación del metodo RGB para generar más colores para cluster
            hold on;
            i=i+1;
            
        end
        
    end
    
    
    i=1;
end
msgbox('Encripción y desencripción en el clúster','MSG');
cont=0;
msgbox('La operación tardará entre 10 y 20 minutos','MSG');                                 % Cuadro de dialogo para informar del proceso
contador = 1;
while 1
    for tr=1:1:y
        if posiciones(tr,3) == 1
            nodosc = nodosc + 1;
            cont = cont+1;
            plot(posiciones(tr,1),posiciones(tr,2),'g:o')
            pause(0.01)
            
        end
    end
    for in=1:1:y
        if posiciones(in,3) == 1
            delim = delim+1;
        end
    end
    if bol ==1
        if delim <= y/2
            
            msgbox('Muy pocos nodos activos desea continuar ','warn','warn'); % Mensajes para continuar o terminar simulación
            
            
            ele = input('Presione 1 para seguir. \nPresiones cualquier tecla para Terminar \n');
            switch ele
                case 1
                    disp('reanudando........')
                    paso = 1;
                    bol = 0;
                otherwise
                    rendimiento(energia,tEnd+0.1,46,y^2);
                    t=1:1:length(nodosactivos);
                    plot(t,nodosactivos)
                    grid on;
                    hold on;
                    title('Nodos activos a lo largo de la simulación')
                    xlabel('Participaciones de nodos')
                    ylabel('Número de nodos')
                    break;
            end
        else 
            delim = 0; 
        end
    end
    if cont == 0
        for tr=1:1:y
            plot(posiciones(tr,1),posiciones(tr,2),'w:o')
            plot(posiciones(tr,1),posiciones(tr,2),'r:o')                                                   % Asociacion de nodos a estado encendido o apagado
            text(posiciones(tr,1),posiciones(tr,2),'off')
        end
        msgbox('Simulación terminada','MSG');
        break;
    else
        down1 = randi([1 y],1,1);
        down = randi([1 y],1,1);
        down2 = randi([1 y],1,1);
        posiciones(down2,3)=0;
        posiciones(down1,3)=0;                                                                           % Apagado de nodos para variar el proceso de comunicacion
        posiciones(down,3)=0;
        plot(posiciones(down,1),posiciones(down,2),'w:o')
        plot(posiciones(down,1),posiciones(down,2),'r:x')
        text(posiciones(down,1),posiciones(down,2),'off')
        disp(['Nodo: {',num2str(posiciones(down,1)),',',num2str(posiciones(down,2)),'}',' energía insuficiente'])
        plot(posiciones(down1,1),posiciones(down1,2),'w:o')
        plot(posiciones(down1,1),posiciones(down1,2),'r:x')
        text(posiciones(down1,1),posiciones(down1,2),'off')
        disp(['Nodo: {',num2str(posiciones(down1,1)),',',num2str(posiciones(down1,2)),'}',' energía insuficiente'])
        plot(posiciones(down2,1),posiciones(down2,2),'w:o')
        plot(posiciones(down2,1),posiciones(down2,2),'r:x')
        text(posiciones(down2,1),posiciones(down2,2),'off')
        disp(['Nodo: {',num2str(posiciones(down2,1)),',',num2str(posiciones(down2,2)),'}',' energía insuficiente'])
        pause(0.01)
        cont =0;
    end
    
    for n=1:1:y
        i=1;
        
        for k=1:1:y
            if posiciones(n,3)== 1 && posiciones(k,3)== 1
                r = randi([0 1],1);
                g = randi([0 1],1);
                b = randi([0 1],1);
                
            else
                r=1;                                                                                                % Identificar nodos encendidos o apagados
                b=1;
                g=1;
            end
            dist=(((posiciones(n,1)-posiciones(k,1))^2)+(posiciones(n,2)-posiciones(k,2))^2)^0.5;
            nivel = enlace(f,ptx,Grx,Gtx,dist);
            if nivel > umbral
                aux = zeros(100,2);
                aux(i,1) = posiciones(k,1);
                aux(i,2) = posiciones(k,2);
                fig = quiver3(aux(i,1),aux(i,2),0,posiciones(n,1)-aux(i,1),posiciones(n,2)-aux(i,2),0);
                fig.Color=[r,g,b];
                if paso == 1
                    disp('Comunicación fallida.....')
                else
                    disp('Comunicación exitosa....')
                end
                pause(0.01)
                hold on;
                
                
                
                i=i+1;
            end
            
        end
        
        
        i=1;
    end
    
    nodo = randi([1 y],1,1);                                                                                        % envio de mensajes y calculo de tiempos de encripcion y desencripcion
    tStart = cputime;
    disp(['Se enviará un mensaje desde el nodo : {',num2str(posiciones(nodo,1)),',',num2str(posiciones(nodo,2)),'}']);
    for t=1:1:y
        if ((llaves(t,4)==posiciones(nodo,1) && llaves(t,5)==posiciones(nodo,2)) || (llaves(t,6)==posiciones(nodo,1) && llaves(t,7)==posiciones(nodo,2)))
            tic
            send = modulos('hola',llaves(t,1),llaves(t,3));                                                           % Generando destino aleatorio
            toc
            tic
            mensaje(send, llaves(t,2),llaves(t,3));
            toc
        end
        
    end
    tEnd1= cputime - tStart;
    disp(['Tiempo de CPU para enviar : ',num2str(tEnd1,'%.10f')]);
    disp(['Tiempo total de CPU usado: ',num2str(tim)])
    nodosactivos(contador,1)=nodosc;
    contador = contador + 1;
    nodosc=0;
end
y1=rendimiento(energia,tEnd1+0.1,46,y^2);
figure(3)
t=1:1:length(nodosactivos);
plot(t,nodosactivos)
xlim([0,y1]);
ylim([0,y]);
grid on;
hold on;
title('Nodos activos a lo largo de la simulación')
xlabel('Participaciones de nodos')
ylabel('Número de nodos')





