function y_out = BleachCorrection(y)
% corrects the influence of photo bleaching in input curve @y
% output @y_out is a curve  after correction

len = length(y);
x = 1:len;
% myfunc=inline('beta(1)*exp(-beta(2)*x) + beta(3)','beta','x');
myfunc = @(beta,x)(beta(1)*exp(-beta(2)*x) + beta(3));
beta = [0.5 0 0.5];
beta = nlinfit(x,y,myfunc,beta);
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a*exp(-b*x)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-100 -100 -100];
opts.Robust = 'Bisquare';
% @beta regard as the initial parameters of the fitting
opts.StartPoint = beta;
opts.Upper = [100 100 100];

% Fit model to data.
fitresult = fit( xData, yData, ft, opts );
y_fit1 = beta(1)*exp(-beta(2)*x)+beta(3);
y_fitted = fitresult.a*exp(-fitresult.b*x)+fitresult.c;
y_corre = y - y_fitted;
delta = min(y) - min(y_corre);
y_out = y_corre + delta;

% plot(y_fit1);
% hold on 
% plot(y_fitted)
% plot(y)