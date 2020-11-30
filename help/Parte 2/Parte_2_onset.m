%% Parte 2 - Onset
%% Read Audio
clear all
clc
[y, Fs] = audioread('audio_taller_onset.wav');

%% Segmentación por frases
y1 = y(1:110000);
y2 = y(110001:260000);
y3 = y(260001:400000);
y4 = y(400001:520000);
y5 = y(520001:650000);
y6 = y(650001:end);

%% "Adiós chimuelo"
sound(y1,Fs)

%% "Siempre te amamos"
sound(y2,Fs)

%% "Más que mascota"
sound(y3,Fs)

%% "Fuiste un hermano"
sound(y4,Fs)

%% "Chimuelo"
sound(y5,Fs)

%% "Descansa en paz"
sound(y6,Fs)

%% Graficar cada segmento de la canción
figure,plot(y)
xline(110000,'Color','green','LineWidth',2);
xline(260000,'Color','green','LineWidth',2);
xline(400000,'Color','green','LineWidth',2);
xline(520000,'Color','green','LineWidth',2);
xline(650000,'Color','green','LineWidth',2);
title('Segmentos a Peak-Pickear por Separado')

%% formula traslape

z = 7500;               % tamaño ventana
t = size(y,1);          % total de datos
p = 3/4;                % 50% traslape
n = 1+(t-z)/(z*(1-p));  % número de ventanas
n = round(n)-1;
% t = z+(n-1)*z*(1-p);  % fórmula demostrada en taller 2

% matriz de ventanas traslapadas
l = zeros(n,z);
for i = 1:1:n
    bloqueL = y(z*(1-p)*(i-1)+1:z+z*(1-p)*(i-1));
    l(i,:) = bloqueL;
end

% Vector HFC calculado por cada ventana
L = zeros(n,1);

% for cada ventana: calcular el HFC

N = size(l,2);
w = -round(N/2):round(N/2)-1;
wa = abs(w);

for k = 1:1:size(l,1)
    A = l(k,:);
    F = fft(A);
    F = abs(F);
    F = fftshift(F);
    F = F.^2;
    F = F.*wa;
    F = sum(F);
    F = F/N;
    L(k,1) = F;
end

plot(L)

%% Segmentar por cada sección de audio
L1 = zeros(391,1);
L2 = zeros(391,1);
L3 = zeros(391,1);
L4 = zeros(391,1);
L5 = zeros(391,1);
L6 = zeros(391,1);

L1(1:55)=L(1:55);
L2(56:132)=L(56:132);
L3(133:209)=L(133:209);
L4(210:276)=L(210:276);
L5(277:344)=L(277:344);
L6(345:end)=L(345:end);

%% PEAKS 
% PEAKS L1
figure,plot(L1)
ylim([0 60000])
hold on
findpeaks(L1,'NPeaks',2,'MinPeakDistance',8,'MinPeakHeight',4000 ...
,'MinPeakProminence',100)
[pks, locs1] = findpeaks(L1,'NPeaks',2,'MinPeakDistance',8,'MinPeakHeight',4000 ...
,'MinPeakProminence',100);

% PEAKS L2
plot(L2)
ylim([0 60000])
findpeaks(L2,'NPeaks',4,'MinPeakDistance',5,'MinPeakHeight',5000 ...
,'MinPeakProminence',1)
[pks, locs2] = findpeaks(L2,'NPeaks',4,'MinPeakDistance',5,'MinPeakHeight',5000 ...
,'MinPeakProminence',1);

% PEAKS L3
plot(L3)
ylim([0 60000])
findpeaks(L3,'NPeaks',5,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1)
[pks, locs3] = findpeaks(L3,'NPeaks',5,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1);

% PEAKS L4
plot(L4)
ylim([0 60000])
findpeaks(L4,'NPeaks',2,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1,'MaxPeakWidth',5)
[pks, locs4] = findpeaks(L4,'NPeaks',2,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1,'MaxPeakWidth',5);

% PEAKS L5
plot(L5)
ylim([0 60000])
findpeaks(L5,'NPeaks',1,'MinPeakDistance',7,'MinPeakHeight',15000 ...
,'MinPeakProminence',3500)
[pks, locs5] = findpeaks(L5,'NPeaks',1,'MinPeakDistance',7,'MinPeakHeight',15000 ...
,'MinPeakProminence',3500); locs5(1)=locs5(1)-2;

% PEAKS L6
plot(L6)
ylim([0 60000])
findpeaks(L6,'NPeaks',4,'MinPeakDistance',5,'MinPeakHeight',4150 ...
,'MinPeakProminence',1)
[pks, locs6] = findpeaks(L6,'NPeaks',4,'MinPeakDistance',5,'MinPeakHeight',4150 ...
,'MinPeakProminence',1);
hold off

%% Graficar detecciones

locs = [locs1;locs2;locs3;locs4;locs5;locs6];

pat = 1:401;
click = mod(pat,2);
y_click = y;

plot(y)
for i=1:size(locs,1)
    val = locs(i);
    desde = z*(1-p)*(val-1)+1;
    %hasta = z+z*(1-p)*(val-1);
    %aqui = (desde+hasta)/2;
    xline(desde,'Color','red','LineWidth',1.5);
    y_click(desde-200:desde+200) = click;
    %xline(aqui,'Color','red','LineWidth',1.5);
    %xline(desde,'Color','red','LineWidth',1.5);
    %xline(hasta,'Color','red','LineWidth',1.5);
end

title('Segmentación de Onsets Simple')

%% Segmentación por CLICKS

y1 = y_click(1:110000);
y2 = y_click(110001:260000);
y3 = y_click(260001:400000);
y4 = y_click(400001:520000);
y5 = y_click(520001:650000);
y6 = y_click(650001:end);

%% Play segmento 1
sound(y1,Fs)
%% Play segmento 2
sound(y2,Fs)
%% Play segmento 3
sound(y3,Fs)
%% Play segmento 4
sound(y4,Fs)
%% Play segmento 5
sound(y5,Fs)
%% Play segmento 6
sound(y6,Fs)
%% Play ALL
sound(y_click,Fs)
%% Write Audio
audiowrite('onsets_detectados_2.wav',y_click,Fs);