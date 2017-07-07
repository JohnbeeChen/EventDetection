function varargout = MainForm(varargin)
% MAINFORM MATLAB code for MainForm.fig
%      MAINFORM, by itself, creates a new MAINFORM or raises the existing
%      singleton*.
%
%      H = MAINFORM returns the handle to a new MAINFORM or the handle to
%      the existing singleton*.
%
%      MAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORM.M with the given input arguments.
%
%      MAINFORM('Property','Value',...) creates a new MAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainForm

% Last Modified by GUIDE v2.5 06-Jul-2017 20:22:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainForm is made visible.
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainForm (see VARARGIN)

% Choose default command line output for MainForm
handles.output = hObject;
set(handles.axes1,'visible','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function MenuFile_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to MenuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.tif;*.tiff', 'All TIF-Files (*.tif,*.tiff)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select Image File',pathname);
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
    handles.File=File;
    if filename
        t=strfind(filename,'.tif');
        filebase=filename(1:t-1);
        handles.filebase = filebase;
        %         handles.pathname = pathname;
    end
end
[handles.images,handles.ImageNumber]=tiffread(File);
SetAxesImage(handles.axes1,handles.images(:,:,1));
guidata(hObject,handles);
save('lastfile.mat','pathname','filename');


function SetAxesImage(myAxes,myImages)
set(myAxes,'visible','on');
axes(myAxes);
cla reset;
imshow(myImages,[]);
% hold on
% rectangle('Position',[10,100,100,50],'Curvature',[0,0],'LineWidth',2,'LineStyle','--','EdgeColor','r');
% hold off
% AddRectagle(myAxes);


function AddRectagle(myAxes, myBoxs)
num = size(myBoxs,1);
axes(myAxes);
hold on
for ii = 1:num
    rectangle('Position',myBoxs(ii,:),'Curvature',[0,0],'LineWidth',1,'LineStyle','--','EdgeColor','r');
end
hold off


% --- Executes on button press in btn_readROI.
function btn_readROI_Callback(hObject, eventdata, handles)
% hObject    handle to btn_readROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.zip;*.roi', 'All zip-Files (*.zip,*.zip)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select ROI File',pathname);
roi_filename = fullfile(pathname,filename);
if filename
    rois = ReadImageJROI(roi_filename);
    roi_num = length(rois);
    box =zeros(roi_num,4);
    if roi_num == 1
        box(1,:) = rois.vnRectBounds;
    elseif roi_num > 1
        for ii = 1:roi_num
            tem = rois{ii};
            box(ii,:) = tem.vnRectBounds;
        end
    end
    % changes the format of @box to [x y w h]
    box(:,[4 3]) = box(:,3:4) - box(:,1:2) + 1;
    box(:,1:2) = box(:,[2 1]); 
    idx = box(:,[1 2]) == 0;
    box(idx) = 1;
    img_size = size(handles.images(:,:,1));
    idx = box(:,1) > img_size(2);
    box(idx) = img_size(2);
    idx = box(:,2) > img_size(1);
    box(idx) = img_size(1);    
    
    handles.roiboxs = box;
    AddRectagle(handles.axes1,box);
    guidata(hObject,handles);
else
    
end


% --- Executes on button press in btn_zprofile.
function btn_zprofile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
boxs = handles.roiboxs;
all_profile = TIRF_Z_Profile(handles.images,boxs);
handles.eventinfo = FormPlot(all_profile);
guidata(hObject,handles);


% --- Executes on button press in btn_findparticles.
function btn_findparticles_Callback(hObject, eventdata, handles)
% hObject    handle to btn_findparticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'Pixe size(/nm):','half-high-half-width of psf(/pixel):','least fram:','parallel flag:'};
defaults={num2str(32.5),num2str(1.5),num2str(4),num2str(0)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    parameters(1) = str2double(info(1));
    parameters(2) = str2double(info(2));  
    parameters(3) = str2double(info(3));
    parameters(4) = str2double(info(4));    
end
boxs = handles.roiboxs;
sim_event_info = handles.eventinfo;
fit_result = SIM_Handle(double(handles.images),sim_event_info,boxs,parameters);
t= 1;

