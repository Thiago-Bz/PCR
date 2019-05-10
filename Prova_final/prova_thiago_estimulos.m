clc
clear all
close all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa
% valores de entrada entre 0 e 1.0
max_in = 20.0 % pesos com valores entre 0 e 10.0

floatxUL = fopen('floatxUL.txt','w');
floatxUR = fopen('floatxUR.txt','w');


binxUL = fopen('xUL.txt','w');
binxUR = fopen('xUR.txt','w');

rand('twister',150022638); % seed for random number generator
for i=1:N
    xUL=rand();
    xUR=rand();
    
    xULbin=float2bin(EW,FW,xUL);
    xURbin=float2bin(EW,FW,xUR);

    
    fprintf(floatxUL,'%f\n',xUR);
    fprintf(floatxUR,'%f\n',xUL);

    
    fprintf(binxUL,'%s,\n',xULbin);
    fprintf(binxUR,'%s,\n',xURbin);

end

fclose(floatxUL);
fclose(floatxUR);