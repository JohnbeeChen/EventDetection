close all;
clc;
addpath([cd '/data']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

roi_filename = strcat(cd,'/data/RoiSet.zip');
rois = ReadImageJROI(roi_filename);
roi_num = length(rois);
if roi_num == 1
   box(1,:) = rois.vnRectBounds; 
elseif roi_num > 1
    for ii = 1:roi_num
       tem = rois{ii};
       box(ii,:) = tem.vnRectBounds;   
    end    
end
box(:,3:4) = box(:,3:4) - box(:,1:2) + 1;

t = 1;
% run MainForm