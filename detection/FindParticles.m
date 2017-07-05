function varargout = FindParticles(img_in,siz,thk)


debug_display = 1;
threshold = thk;
A = img_in;
img_num = size(A,3);
s = siz;
if img_num == 0
    varargout{1} = -1;
    return;
end

for ii = 1 : img_num
    img = A(:,:,ii);
    [W2 W3]=waveletTransform(img,1,threshold);
    bw = im2bw(W2);
    bw = bwareaopen(bw,4);
    W = bw .* img;
    temp = weightedcentrid(W,s);
    mean_SIM = mean(temp(:,3));
    id = temp(:,3) < 1*mean_SIM;
    temp(id,:) = [];
    V{ii} = temp;
    % nmb = 1;
end
varargout{1} = V;

end