x = linspace(0,1,1000);
pos = [1 2 3 5 7 8]/10;
hgt = [4 4 2 2 2 3];
wdt = [3 8 4 3 4 6]/100;

for n = 1:length(pos)
   Gauss(n,:) = hgt(n)*exp(-((x - pos(n))/wdt(n)).^2); 
end
peaksig = sum(Gauss);
plot(x,Gauss,'--',x,peaksig);
grid on