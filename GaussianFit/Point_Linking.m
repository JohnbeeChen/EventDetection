function varargout = Point_Linking(point_cell,radius,duration)
% ponits linking in the points' set of @point_cell
% @point_cell: the result of FindParticles.
% @radius: if the distance between the point in one fram and the point in
%          the next fram is less than @radius, the two points will be
%          considered as the same point.
% @duration: if the frams that the point existed less than @duration, the
%            point will no be considerd as a signal and it will not be
%            involved in the output parameter @varargout
%
% @varargout:[start_fram,stop_fram,x_center,y_center,peak_intensity]
%
% Author : Johnbee
% Date   : 2017/04/25


least_frame = duration;
uncertainty = radius^2;
img_num = size(point_cell,2);

trackInfos = cell(img_num,1);
point_set = point_cell;
track_info = zeros(1,5);
for ii = 1:img_num
    point_num = length(point_set{ii}(:,1));
    if point_num > 0
        for jj = 1: point_num
            track_info(1) = ii; %start frame
            track_info(3:5) = point_set{ii}(jj,1:3);
            xx = point_set{ii}(jj,1);
            yy = point_set{ii}(jj,2);
            next_fram = ii + 1;
            while 1
                if next_fram <= img_num
                    next_points = point_set{next_fram};
                    
                    points_xx = next_points(:,1);
                    points_yy = next_points(:,2);
                    distance = (points_xx - xx).^2 + (points_yy - yy).^2;
                    min_dis = min(distance(:));
                    
                    if(min_dis < uncertainty)
                        index = find(distance == min_dis,1);
                        if next_points(index,3) > track_info(5)
                            %update the intensity and location of the peak
                            track_info(3:5) = next_points(index,1:3);
                        end
                        track_info(2) = next_fram;%update the stop_fram
                        point_set{next_fram}(index,:) = [];
                        next_fram = next_fram + 1;
                    else
                        break;
                    end
                else
                    break;
                end
            end
            trackInfos{ii}(jj,:) = track_info;
        end
        %% clean those points that's duration less than least_frame
        star_fram = track_info(1);
        stop_fram = least_frame + star_fram - 1;
        id = trackInfos{ii}(:,2) < stop_fram;
        trackInfos{ii}(id,:) = [];
    end
end
% varargout{1} = cell2struct(trackInfos,'trackInfo',2);
varargout{1} = MyCell2Mat(trackInfos);
end

function y = MyCell2Mat(x)

null_loc = cellfun('isempty',x);
x(null_loc) = [];
num = length(x);
if num == 0
    y = [];
   return; 
end
track_info = x{1};
for ii = 2:num
    m = x{ii};
    track_info = [track_info;m];
end
y = track_info;
end
