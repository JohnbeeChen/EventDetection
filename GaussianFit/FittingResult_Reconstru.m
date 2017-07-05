function varargout = FittingResult_Reconstru(fitting_result)

result_in = fitting_result;
fram_num = size(result_in,1);

reconstru_infos = cell(fram_num,1);

for ii = 1:fram_num
    tem = result_in{ii};
    points_num = size(tem,1);
    for jj = 1:points_num
        for  continue_frams = tem(jj,1):tem(jj,2)
            tem_in =  reconstru_infos{continue_frams};
            inde = size(tem_in,1);
            reconstru_infos{continue_frams}(inde+1,:) = tem(jj,3:4);            
        end
    end
    
end
varargout{1} = reconstru_infos;

end