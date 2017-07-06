load fitdata.mat;


fitresult = BleachCorrection(y);
% num_y = length(y);
% 
% 
% myfunc=inline('beta(1) + beta(2)*exp(-beta(3)*x)','beta','x'); 
% 
% %beta=nlinfit(x,y,myfunc,[0.5 0.5 0.5 0.5]); 
% beta=nlinfit(x,y,myfunc,[0.5 0.5 0]); 
% 
% %a=beta(1);k1=beta(2);m=beta(3);k2=beta(4);
% a=beta(1);k1=beta(2);m=beta(3);
% test_x = [1:num_y];
% test_y = a+k1*exp(-m*x);
% 
% jz_trace = y-test_y;
plot(y);
hold on
plot(fitresult);
