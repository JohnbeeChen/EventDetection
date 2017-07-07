function varargout = SIM_Handle(imgSIM,eventSIM,boxsSIM,parIn)
% handle the SIM's images
% result[event_num,start_fram,stop_fram,xc,yc,precise_x,precise_y]


% pixe_size = 32.5; %nanometer
% psf_hw = 1.5; % the half-high-half-width per pixel
% least_fram = 4; %the fram number that the particle exists at least 
pixe_size = parIn(1);
psf_hw = parIn(2);
least_fram = parIn(3);
parfor_falg = parIn(4);

region_num = length(eventSIM);
% box_mat = struct2cell(boxsSIM)';
box_mat = boxsSIM;

regoin_fit_result  = cell(region_num,1);
% regoin_fit_precise = cell(region_num,1);
% region_num = 3;
for ii = 1:region_num
    disp(['regoin:',num2str(ii),' event fiting is starting']);
    tem_event = eventSIM{ii};
    event_num = size(tem_event,1);
    tem_box = box_mat(ii,:);
    if parfor_falg
        parfor jj = 1:event_num
            disp(['event',num2str(jj),': fiting is starting']);
            event_duration = tem_event(jj,1):tem_event(jj,2);
            event_frams = imgSIM(:,:,event_duration);
            %set all pixels equal to 0 that beyond the region
            event_frams_roi = KeepROI(event_frams,tem_box);
            particles = FindParticles(event_frams_roi,3,3);
            DV = Point_Linking(particles, psf_hw,least_fram);
            tem_result = Point_Fitting(event_frams,DV,2);
            star_fram = tem_event(jj,1);
            % modifies the local fram_num to global fram_num
            tem_result = KeepStartFram(tem_result,star_fram);
            precise =  Localization_Precise(tem_result,pixe_size);
            tem_result(:,5:6) = precise;
            tem_result(:,7:8) = [];
            event_fit_result{jj} = tem_result;
            disp(['event',num2str(jj),': fiting is completed']);
        end      
    else
        event_fit_result = cell(1,event_num);
        for jj = 1:event_num
            disp(['event',num2str(jj),': fiting is starting']);
            event_duration = tem_event(jj,1):tem_event(jj,2);
            event_frams = imgSIM(:,:,event_duration);
            %set all pixels equal to 0 that beyond the region
            event_frams_roi = KeepROI(event_frams,tem_box);
            particles = FindParticles(event_frams_roi,3,3);
            DV = Point_Linking(particles, psf_hw,least_fram);
            tem_result = Point_Fitting(event_frams,DV,2);
            star_fram = tem_event(jj,1);
            % modifies the local fram_num to global fram_num
            tem_result = KeepStartFram(tem_result,star_fram);
            precise =  Localization_Precise(tem_result,pixe_size);
            tem_result(:,5:6) = precise;
            tem_result(:,7:8) = [];
            event_fit_result{jj} = tem_result;
            disp(['event',num2str(jj),': fiting is completed']);
        end
    end
    regoin_fit_result{ii} = MyCell2Mat(event_fit_result);
%     regoin_fit_precise{ii} = MyCell2Mat(precise);
    disp(['regoin:',num2str(ii),' event fiting is completed']);
end
disp('all done');
varargout{1} = regoin_fit_result;
% if nargout ==2
%     varargout{2} = regoin_fit_precise;
% end

function y = KeepStartFram(inX,starFram)

tem_y = inX(:,1:2) + starFram - 1;
y = inX;
y(:,1:2) = tem_y;


function y = MyCell2Mat(x)

null_loc = cellfun('isempty',x);
x(null_loc) = [];
num = length(x);
if num == 0
    y = [];
   return; 
end
infos = x{1};
tem_len = size(infos,1);
infos = [ones(tem_len,1),infos];
for ii = 2:num
    m = x{ii};
    len = size(m,1);
    t = [ii*ones(len,1),m];
    infos = [infos;t];
end
y = infos;