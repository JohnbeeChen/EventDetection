function varargout = TIRF_Z_Profile(tirf_in,bound_box)
% return the z_profiles of each box region at @bound_box

gpu_tirf = tirf_in;
boxs = bound_box;
imgs_num = size(tirf_in,3);
regoin_num = size(boxs,1);
boxs(:,3:4) = boxs(:,1:2) + boxs(:,3:4);
for ii = 1: regoin_num
    com = (boxs(ii,1):boxs(ii,3)) + 1;
    row = (boxs(ii,2):boxs(ii,4)) + 1;
    tem_regoin = gpu_tirf(row,com,:);
    for jj = 1:imgs_num
        tem = tem_regoin(:,:,jj);
        profile(ii,jj) = sum(tem(:))/numel(tem);
    end    
end
varargout{1} = profile;
end