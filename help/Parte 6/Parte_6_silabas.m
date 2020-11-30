%% Parte 6 - S�labas
%% Read Audio
clear all
clc
[y, Fs] = audioread('audio_taller_onset.wav');

%% Segmentaci�n por frases
y1 = y(1:110000);
y2 = y(110001:260000);
y3 = y(260001:400000);
y4 = y(400001:520000);
y5 = y(520001:650000);
y6 = y(650001:end);

%% "Adi�s chimuelo"
sound(y1,Fs)

%% "Siempre te amamos"
sound(y2,Fs)

%% "M�s que mascota"
sound(y3,Fs)

%% "Fuiste un hermano"
sound(y4,Fs)

%% "Chimuelo"
sound(y5,Fs)

%% "Descansa en paz"
sound(y6,Fs)

%% Graficar cada segmento de la canci�n
figure,plot(y)
xline(110000,'Color','green','LineWidth',2);
xline(260000,'Color','green','LineWidth',2);
xline(400000,'Color','green','LineWidth',2);
xline(520000,'Color','green','LineWidth',2);
xline(650000,'Color','green','LineWidth',2);
title('Segmentos a Peak-Pickear por Separado')

%% formula traslape

z = 7500;               % tama�o ventana
t = size(y,1);          % total de datos
p = 3/4;                % 50% traslape
n = 1+(t-z)/(z*(1-p));  % n�mero de ventanas
n = round(n)-1;
% t = z+(n-1)*z*(1-p);  % f�rmula demostrada en taller 2

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

%% Segmentar por cada secci�n de audio
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
findpeaks(L1,'NPeaks',5,'MinPeakDistance',5,'MinPeakHeight',4150 ...
,'MinPeakProminence',1)
[pks, locs1] = findpeaks(L1,'NPeaks',5,'MinPeakDistance',5,'MinPeakHeight',4150 ...
,'MinPeakProminence',1);
text(locs1(1),pks(1)+1000+2000,'A-')
text(locs1(2),pks(2)+1000+2000,'-dios')
text(locs1(3),pks(3)-1000-2000,'Chi-')
text(locs1(4),pks(4)+1000+2000,'-mue-')
text(locs1(5),pks(5)+1000+2000,'-lo')

% PEAKS L2
plot(L2)
ylim([0 60000])
findpeaks(L2,'NPeaks',6,'MinPeakDistance',1,'MinPeakHeight',13300 ...
,'MinPeakProminence',100)
[pks, locs2] = findpeaks(L2,'NPeaks',6,'MinPeakDistance',1,'MinPeakHeight',13300 ...
,'MinPeakProminence',100);
text(locs2(1)-15,pks(1)+2500+2000,'Siem-')
text(locs2(2)-5,pks(2)+2500+2000,'-pre')
text(locs2(3)-5,pks(3)+2500+2000,'Te')
text(locs2(4)-5,pks(4)+4000+2000,'A-')
text(locs2(5)+2,pks(5)+3000+2000,'-ma-')
text(locs2(6),pks(6)+3000+2000,'-mos')

% PEAKS L3
plot(L3)
ylim([0 60000])
findpeaks(L3,'NPeaks',5,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1)
[pks, locs3] = findpeaks(L3,'NPeaks',5,'MinPeakDistance',6,'MinPeakHeight',4150 ...
,'MinPeakProminence',1);
text(locs3(1)-20,pks(1)+5000,'M�s')
text(locs3(2)-10,pks(2)+5000,'Que')
text(locs3(3)-20,pks(3)+5000,'Mas-')
text(locs3(4)-5,pks(4)+5000,'-co-')
text(locs3(5)+2,pks(5)+4000,'-ta-')

% PEAKS L4
plot(L4)
ylim([0 60000])
findpeaks(L4,'NPeaks',6,'MinPeakDistance',1,'MinPeakHeight',4150 ...
,'MinPeakProminence',1,'MaxPeakWidth',inf)
[pks, locs4] = findpeaks(L4,'NPeaks',6,'MinPeakDistance',1,'MinPeakHeight',4150 ...
,'MinPeakProminence',1,'MaxPeakWidth',inf);
text(locs4(1)-15,pks(1)+2500+2000,'Fuis-')
text(locs4(2)-5,pks(2)+2500+2000,'-te')
text(locs4(3)-5,pks(3)+2500+2000,'Un')
text(locs4(4)-5,pks(4)+4500+2000,'Her-')
text(locs4(5)-10,pks(5)+2500+2000,'-ma-')
text(locs4(6),pks(6)+2500+2000,'-no')

% PEAKS L5
plot(L5)
ylim([0 60000])
findpeaks(L5,'NPeaks',3,'MinPeakDistance',7,'MinPeakHeight',15000 ...
,'MinPeakProminence',3500)
[pks, locs5] = findpeaks(L5,'NPeaks',3,'MinPeakDistance',7,'MinPeakHeight',15000 ...
,'MinPeakProminence',3500);
text(locs5(1)-15,pks(1)+2500+2000,'Chi-')
text(locs5(2)-5,pks(2)+2500+2000,'-mue-')
text(locs5(3),pks(3)+2500+2000,'-lo')

% PEAKS L6
plot(L6)
ylim([0 60000])
findpeaks(L6,'NPeaks',10,'MinPeakHeight',100)
[pks, locs6] = findpeaks(L6,'NPeaks',10,'MinPeakHeight',100);
text(locs6(1)-20,pks(1)+1000+2000,'Des-')
text(locs6(2)-7,pks(2)+4000+2000,'-can-')
text(locs6(3)-7,pks(3)+3000+2000,'-sa')
text(locs6(4)-5,pks(4)+3500+2000,'En');locs6=[locs6;387];pks=[pks;2749.898];
text(locs6(5)-5,pks(5)+4500+2000,'Paz');
hold off

%% Graficar detecciones

locs = [locs1;locs2;locs3;locs4;locs5;locs6];

pat = 1:401;
click = mod(pat,2);
y_click = y;

figure,plot(y)
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

title('Segmentaci�n de Silabas')

%% Segmentaci�n por CLICKS

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
audiowrite('silabas_detectadas_6.wav',y_click,Fs);