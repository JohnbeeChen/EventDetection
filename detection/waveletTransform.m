function [varargout]=waveletTransform(A,Tflag,coef)
%% Perform an atrous wavelet transform 
% ****************************************************************
% [W1,W2,W3,A3]=wavelet(A);
% [W1,W2,W3,A3]=wavelet(A,Tflag);
% [W1,W2,W3,A3]=wavelet(A,Tflag,coef);
% ****************************************************************
% Author:ZYD,IBP,CAS 11/30/2009

if nargin==2
    flag=Tflag;
else
    flag=1;
end

kernel{1}=[1/16,1/4,3/8,1/4,1/16];
kernel{2}=[1/16,0,1/4,0,3/8,0,1/4,0,1/16];
kernel{3}=[1/16,0,0,0,1/4,0,0,0,3/8,0,0,0,1/4,0,0,0,1/16];
[row column]=size(A);
A0=single(A);
A=cell(1,3);
T=cell(1,3);
W=cell(1,3);

for i=1:3
    if i==1
        A{1}=wavelet(A0,kernel{1});
        if flag==1
           T0=IUWT(A0);
           T{1}=IUWT(A{1}); 
           W{1}=T0-T{1};
        else
           W{1}=A0-A{1}; 
        end
    else
        A{i}=wavelet(A{i-1},kernel{i});
        if flag==1
           T{i}=IUWT(A{i}); 
           W{i}=T{i-1}-T{i};
        else
           W{i}=A{i-1}-A{i}; 
        end
    end
end    

for i=1:3
    deta=median(median(abs(W{i}-median(median(W{i})).*ones(row,column))));
    t=coef*deta/0.67;
    W{i}=(W{i}>=t).*W{i};
end
          
if nargout==1
    varargout{1}=W{3};
elseif nargout==2
    varargout{1}=W{2};
    varargout{2}=W{3};
elseif nargout==3
    varargout{1}=W{2};
    varargout{2}=W{3};
    varargout{3}=A{3};
else
    varargout{1}=W{1};
    varargout{2}=W{2};
    varargout{3}=W{3};
    varargout{4}=A{3};
end   


function A=wavelet(I,kernel)
%% wavelet transform    
[row column]=size(I);
extend=(length(kernel)-1)/2;
I=padarray(I,[extend extend],'symmetric');
I1=conv2(kernel,kernel',I,'same');
A=I1(extend+1:extend+row,extend+1:extend+column);


function T=IUWT(A)
%% Perform a T-transform
h=[1/16 1/4 3/8 1/4 1/16];
t1=sum(h);
t2=sum(h.^2);
t3=sum(h.^3);
c=(7*t2)/(8*t1)-t3/(2*t2);
b=2*sqrt(t1/t2);
T=b*sign(A+c).*sqrt(abs(A+c));
