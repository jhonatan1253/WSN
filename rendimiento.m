function [renidmienton]=rendimiento(bateria,CPU,consumo,participaciones)
aux = bateria;
cont = 0; 
while 1
    rand = randi([1 10],1,1);   % Consumo aleatorio por situaciones externas 
    ranu = [10,1,2,6,70,16,45,50,56,79];
     if bateria > 0
        bateria = bateria - consumo*CPU-ranu(rand);
        
    else 
        break;
    end 
    if bateria >= aux /2
          r=0;
          g=1;
          b=0; 
    else 
          r=1;
          g=0; 
          b=0; 
    end
    figure(2)
     fig = stem(cont,bateria);
            fig.Color=[r,g,b];  
     cont =cont +1; 
     grid on; 
     hold on;
     xlim([0,cont]);
     ylim([0,aux]);
     title('Consumo de energía estimado por nodo')
     xlabel('Número de apariciones del nodo')
     ylabel('Energía restante mA')
    renidmienton= cont; 
end 

hold off; 
end 

