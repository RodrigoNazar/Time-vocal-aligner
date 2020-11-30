%% Parte 1 - RAP
%% Read Audio
clear all
clc
[y, Fs] = audioread('rap.wav');

%% Play
sound(y,Fs);

%% Graficar
plot(y)
title('Rap Original')

%% Compás
% Por inspección, se escogió este bloque para encontrar el compás
y1 = y(13950:26441);

%% Correlación y detección de Compás
% Calcula la correlación y despeja los 0's y residuos 
% de correlación incompleta
cx = xcorr(y,y1);
sobran = size(cx,1)-(size(y1,1)+size(y,1)-1);
cx = cx(sobran+1:end);
cx = cx(size(y1,1):end-size(y1,1)+1);

% Detecta peaks de correlación (repeticiones)
[pls, locs] = findpeaks(cx,'NPeaks',4,'MinPeakDistance',22000);

%% Grafica la correlación y sus máximos
figure,plot(cx),
findpeaks(cx,'NPeaks',4,'MinPeakDistance',22000);
title('Máximos del vector correlación (repeticiones)')

%% Grafica la señal de audio con Downbeats marcados
figure,plot(y)
for i = 1:size(locs,1)
    xline(locs(i),'Color','red','LineWidth',2);
end
title('Rap con Downbeats marcados')

%% Añade 'Clicks' en los Downbeat
pat = 1:601;
click = mod(pat,2);

y_click = y;
y_click(locs(1)-300:locs(1)+300) = click;
y_click(locs(2)-300:locs(2)+300) = click;
y_click(locs(3)-300:locs(3)+300) = click;
y_click(locs(4)-300:locs(4)+300) = click;

%% Play Rap con Clicks
sound(y_click,Fs)

%% Write Audio
audiowrite('rap_click_yair.wav',y_click,Fs)

%% EXTRA: Cálculo de BPM

% muestras por compás
m1 = locs(2)-locs(1);
m2 = locs(3)-locs(2);
m3 = locs(4)-locs(3);

% promedio
mm = (m1+m2+m3)/3;

% mm = muestras/compás
% 4 beats/compás
% 60 seg/min
% Fs = 44.1k muestras/seg

BPM = 4*60*Fs/mm

% Rap a 188.20 BPM !!!