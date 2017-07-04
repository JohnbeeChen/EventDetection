function varargout = My_SWT(mySignals,n)
% a trous wavelet transform for 1D signals

h = [1 4 6 4 1]/16;
sz = size(mySignals);

hn = h;
y = mySignals;
dj = cell(1,n);
for ii = 1:n
    lf  = length(hn)/2; 
    e_y = VectorsExtend(y,ceil(lf));
    tem = conv2(e_y,hn,'same');
	tem = keepLOC(tem,sz);
    dj{ii} = y - tem;
    y = tem;
    hn = dyadup(hn,'m',0);
end
varargout{1} = y;
if nargout == 2
   varargout{2} = dj; 
end

function varargout = VectorsExtend(myVectors,len)

y = wextend('addcol','sym',myVectors,len);
varargout{1} = y;


%%---------------------------------------------------------
function y = keepLOC(z,siz)
sz = size(z);
first = round((sz - siz)/2) +1;
last = first+siz-1;
y = z(first(1):last(1),first(2):last(2),:);
