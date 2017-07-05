function varargout = Localization_Precise(fit_result,pixe_size)

points_num = size(fit_result,1);
uncer = zeros(points_num,2);
tem_points = fit_result;
for jj = 1 : points_num
    std = tem_points(jj,5:6);% standard deviation
    ponton = tem_points(jj,7);
    bg_noise = tem_points(jj,8);
    uncer(jj,:) = calculate_uncertain(std,pixe_size,bg_noise,ponton);
end
% Result_Infos = cell(frams_num,1);
% for ii = 1 : frams_num
%     tem_points = fit_result{ii};
%     point_num = size(tem_points,1);
%     uncer = zeros(point_num,2);
%     for jj = 1 : point_num
%         std = tem_points(jj,5:6);% standard deviation
%         ponton = tem_points(jj,7);
%         bg_noise = tem_points(jj,8);
%         uncer(jj,:) = calculate_uncertain(std,pixe_size,bg_noise,ponton);
%     end
%     Result_Infos{ii} = uncer;
% end
varargout{1} = uncer;
end

function y = calculate_uncertain(sd,a,b,N)
term = zeros(3,2);
term(1,:) = a*sd.^2/N;
term(2,:) = a.^2/12/N;
term(3,:) = 8*pi*b.^2.*a^2*sd.^4/(N.^2);
uncertain = sqrt(sum(term));

y = uncertain;
end