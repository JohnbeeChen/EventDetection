function V=weightedcentrid(I,w)

ImgMax=locmax2d(I,[w w]);
[V(:,2) V(:,1) V(:,3)]=find(ImgMax);
[row column]=size(I);
t=(w-1)/2;
[yy xx] = meshgrid(1:w,1:w);
for i=1:length(V(:,1))
    x=V(i,1);
    y=V(i,2);
    if x>t && y>t && x<=column-t && y<=row-t
        ROI=single(I(y-t:y+t,x-t:x+t));
        [wy wx]=weight_centrid(ROI,w,xx,yy);
         if abs(wy-t-1)<1 && abs(wx-t-1)<1
            V(i,1)=x+wx-t-1;
            V(i,2)=y+wy-t-1;
         end       
    end
end

function [y,x]=weight_centrid(ROI,w,xx,yy)
% sumx=0;
% sumy=0;
% for i=1:w
%     for j=1:w
%         sumx=sumx+ROI(i,j)*j;
%         sumy=sumy+ROI(i,j)*i;
%     end
% end
sumx = sum(ROI(:).*yy(:));
sumy = sum(ROI(:).*xx(:));
y=sumy/sum(ROI(:));
x=sumx/sum(ROI(:));

