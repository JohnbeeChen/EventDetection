% 
% 
close all
clc
clear
z0=[0	0	0	0	0	1	0	1	0	1	0	0	0
0	0	0	1	1	0	0	0	0	1	1	0	0
0	0	1	0	0	2	1	1	0	0	1	0	1
0	0	0	0	0	0	1	1	1	0	1	1	0
0	0	0	0	0	1	2	2	3	5	0	0	0
0	1	2	4	1	5	13	4	3	9	0	2	0
1	1	8	10	10	14	22	23	9	10	0	0	0
5	4	6	15	21	21	24	24	17	16	0	1	0
4	9	12	24	20	28	34	30	13	19	0	1	0
2	5	13	17	31	31	35	39	20	18	0	0	0
2	6	13	22	28	34	46	35	13	20	0	1	1
5	7	12	14	31	27	39	27	14	12	0	1	0
6	6	10	17	18	32	28	27	17	6	1	0	1
3	4	7	10	15	18	17	11	11	11	2	0	1
1	1	7	8	12	14	8	9	4	2	1	0	1
1	1	1	3	3	6	5	5	3	0	0	0	1
1	1	0	3	1	0	1	1	0	1	0	3	0
1	1	0	0	0	1	0	0	1	2	0	0	1
0	1	1	0	0	0	0	1	1	0	0	0	2];


sz = size(z0);
[X,Y] = meshgrid(1:sz(2),1:sz(1));
% X = double(X(:));Y = double(Y(:));Z = z0(:) + 1e-10;
% input_X = zeros(num,4);
% input_X(:,1) = X;
% input_X(:,2) = Y;
% input_X(:,3) = log(Z);
% input_X(:,4) = ones(size(Z));
% 
% real_Y = X.^ + Y.^2;
% 
% B = regress(real_Y,input_X);
[xc,yc,amp,width] = gauss2dcirc(z0,1);
rou = (X - xc).^2 + (Y - yc).^2;
P = amp*exp(-0.5*rou/(width.^2));
surf(z0);
figure
surf(P);
erro = P - z0;
error = erro.^2;
error = sum(error(:))
error = error/numel(erro)

