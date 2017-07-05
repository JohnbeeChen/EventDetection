function varargout = Detect_Event(profiles)
% detect the event of each curve in profiles

display_flag = 0;
% [num,len] = size(profiles);

% swt_value = My_SWT(profiles,scale);
swt_value = profiles;
[pck_infos,event_infos] = VectorsFindPeaks(swt_value);

if display_flag % display the event
    for ii = 1:num
        if ~isempty(event_infos{ii})
            start_loc = event_infos{ii}{5}(:,1);
            end_loc = event_infos{ii}{5}(:,2);
            botom_value = event_infos{ii}{1}(:) - event_infos{ii}{4}(:);
            
            n = 3;
            figure
            subplot(n,1,1)
            plot(profiles(ii,:));
            
            subplot(n,1,2)
            plot(swt_value(ii,:));
            hold on
            plot(start_loc,botom_value,'r.');
            plot(end_loc,botom_value,'b.');
            hold off
            
            subplot(n,1,3)
            plot(profiles(ii,:));
            hold on
            plot(swt_value(ii,:));
            hold off
            %     subplot(n,1,4)
            %     plot(diffs(ii,:));
            nmb = 1;
        end
    end
end
varargout{1} = event_infos;


