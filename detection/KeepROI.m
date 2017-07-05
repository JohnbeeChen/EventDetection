function varargout = KeepROI(imgStack,boxROI)
% set the value over the @boxROI in the @imgStack to 0

tem_imgs = zeros(size(imgStack(:,:,1)));
box_mat = boxROI;
start_p = box_mat(:,1:2) - 0.5;
stop_p = start_p + box_mat(:,3:4);
id_x = start_p(1):stop_p(1);
id_y = start_p(2):stop_p(2);
tem_imgs(id_y,id_x) = 1;
imag_num = size(imgStack,3);
for ii = 1:imag_num
    imgStack(:,:,ii) = imgStack(:,:,ii).*tem_imgs;   
end
varargout{1} = imgStack;