%date initiale
clear all
clc
A = 332.5; % [cm^2] suprafata bazinului
Rm = 3; %Rm=rezistența înfașurării rotorice a motorului
C = 9; % Coeficientul de curgere
% Coeficienti model pompa
k = 0.035; % pentru presiunea pe consumator: Pc = Pv + k * qi^ 2
% Pp = k1 * (km*n)^2 + k2*(km*n)*qi + k3 * qi^2
%qi=k2*n+sqrt(k2^2+4*(u-k3)*k1 - 8*(u-k3)*h/k13 pentru perturbatie intrare la pompa
k1 = 0.624; %valori constante pentru pompa dată
k2 = -0.015;
k3 = -0.0006;
k11 = k2^2 + 4*(k-k3)*k1;
k12 = 8 * (k-k3);
k13 = 2 * (k-k3);
keta = 8 * 10^-5; %eta=𝑘eta*𝑢𝑚*𝑞 um=tensiune alimentare q=debit pompa
%initial q0=0 si h0=0
q0=29.2;
h0=10.5;
%Identificare parte fixata de la comanda la senzor
u0 = 5;
uss = 5.5;
% iesire senzor
y0 = 3.5;
yss = 4.3;
K = (yss - y0) / (uss - u0);
y0632 = y0 + 0.632*(yss-y0);
t0 = 0;
t0632 = 154;
T = t0632 - t0;
H = tf(K, [T 1]);
%Parametrii regulator
kp=(4.33-3.5)/0.5;
Tp=154;
T0=Tp/4;
KR=Tp/T0/kp; % HR=Tp/T0/kp*(1+1/Tp*1/s)
Ti=Tp;
% STRUCTURA DE REGLARE FEEDFORWARD
%kcomp=kpff(variația înălțimii din rezervor)/amplificarea de la intrarea uc la variația înălțimii din rezervor (kp)
Kcomp = 0.1;
% CASCADARE
%treapta de intrare de la 5V-5.5V asa ar trebui dar nu a iesit a iesit pe grafic asa ca am scris din curs valorile
u0 = 5;
uss = 5.5;
y0 = q0;
yss = 34.3;

K = (yss - y0) / (uss - u0);

y0632 = y0 + 0.632*(yss-y0);

t0 = 0;
t0632 = 0.7;
T = t0632 - t0; % T=t1-t0; t0632 unde iesirea urca la 0.632 din diferenta

H = tf(K, [T 1]);


%modelul
Kf1 = 10.2;
Tp1 =  0.73;

Hp1 = tf(Kf1, [Tp1 1]);

%acordare regulator bucla interna
%T01 = 1; % daca vreau pot impune 0.1, 0.5 pentru o rejectare mai rapida a perturbatiilor
T01 = 1/4; %sa am tr=1s
Kr1 = Tp1 / Kf1 / T01;
Ti1 = Tp1;


%simulare bucla externa
q0 = 29.2;
uss = yss;
y0 = h0;
yss2 = 14.4;
K = (yss2 - y0) / (uss - u0);
y0632 = y0 + 0.632*(yss2-y0);
t0 = 0;
t0632 = 261;
T = t0632 - t0;
H = tf(K, [T 1]);

%modelul Hf2
Kf2 =  0.26;
Tf2 =  260;

%acordare regulator bucla externa
tr2=100;
T02 = tr2/4;
Kr2 = Tf2 / Kf2 / T02;
Ti2 = Tf2;

%
u0=5;




