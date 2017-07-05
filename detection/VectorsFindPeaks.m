function varargout = VectorsFindPeaks(inVectors,minProm)
% find m's 1D signal's peaks and other information where m is the number of
% the row of the inVectors
% ouput @pks_info[pks; locs; widths; proms]
%       @event_infos[event_start,event_stop,event_duration]

num = size(inVectors,1);

for ii = 1 : num
    [pck_infos{ii},event_infos{ii}] = My_FindPeaks(inVectors(ii,:),minProm);
end
varargout{1} = pck_infos{ii};
if nargout == 2
    varargout{2} = event_infos{ii};
end

function varargout = My_FindPeaks(inVector,minProm)
% find a 1D signal's peaks and other information

% max_v = max(inVector(:));
% min_v = min(inVector(:));
% thre = 0.2 * (max_v - min_v);
thre = minProm;
[pks,locs,widths,proms] = findpeaks(inVector,'MinPeakProminence',thre,'WidthReference','halfheight');
if isempty(pks)
    varargout{1} = [];
    if nargout == 2
        varargout{2} = [];
    end
    return;
end
pks_info = [pks; locs; widths; proms];

num = length(pks);
event_infos = zeros(num,3);
for ii = 1 : num
    % move the curve to half-high of the peak
    tem = inVector - pks(ii) + 0.5*proms(ii);
    tem(tem<0) = 0;
    zeros_locs = find(~tem);
    peak_loc =  locs(ii);
    % find the nearest zeors_locs in the left and right of the peak
    start_loc = find(zeros_locs < peak_loc,1,'last');
    end_loc = find(zeros_locs > peak_loc,1,'first');
    event_infos(ii,1:2) = [zeros_locs(start_loc),zeros_locs(end_loc)];
    event_infos(ii,3) =  event_infos(ii,2) -  event_infos(ii,1) + 1;
end

varargout{1} = pks_info;
if nargout == 2
    varargout{2} = event_infos;
end