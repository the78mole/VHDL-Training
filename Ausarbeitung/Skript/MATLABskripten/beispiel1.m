% Einfaches Beispiel Matlab-Skript

x = -3:0.1:3;
y = x.^2;

figure(1)

subplot(211)
plot(x,y), axis([-4, 4, 0, 10])
title('Normalparabel'), xlabel('x'), ylabel('y = f(x)')

subplot(212)
stem(x,y), axis(-4, 4, 0, 10)
title('Normalparabel - diskrete Darstellung')