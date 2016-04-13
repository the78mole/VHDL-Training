function [y]=parabel(n, s)
%% Syntax:   [y]=parabel(n, s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Berechnung einer Normalparabel mittels der Parameter
%% n:      Bereich +/-n
%% s:      Schrittweite der Stützstellen


x = -n:s:n;
y = x.^2;

figure(1)

subplot(211)
plot(x,y), axis([-n, n, 0, n^2])
title('Normalparabel'), xlabel('x'), ylabel('y = f(x)')

subplot(212)
stem(x,y), axis([-n, n, 0, n^2])
title('Normalparabel - diskrete Darstellung')