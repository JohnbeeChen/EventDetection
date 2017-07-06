function varargout = FormPlot(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 06-Jul-2017 16:43:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @untitled_OpeningFcn, ...
    'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;
if ~isempty(varargin)
    inputdata = varargin{1};
    num = size(inputdata,1);
    if num
        PlotAxes(handles.axes1,inputdata(1,:));
        s = num2str(num);
        s = ['1/',s];
        SetText(handles.text_index,s);
        handles.index = 1;
        handles.linenum = num;
        handles.inputdata = inputdata;
        handles.plotdata = inputdata;
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function PlotAxes(myAxes,myCurve)
set(myAxes,'visible','on');
axes(myAxes);
cla reset;
plot(myCurve);
grid on

function SetText(myText, myString)
set(myText,'String',myString);


% --- Executes on button press in btn_previous.
function btn_previous_Callback(hObject, eventdata, handles)
% hObject    handle to btn_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = handles.index;
if index > 1
    index = index - 1;
    linedata = handles.plotdata(index,:);
    PlotAxes(handles.axes1,linedata);
    s = [num2str(index),'/',num2str(handles.linenum)];
    SetText(handles.text_index,s);
    handles.index = index;
    guidata(hObject, handles);
end

% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = handles.index;
if index < handles.linenum
    index = index + 1;
    linedata = handles.plotdata(index,:);
    PlotAxes(handles.axes1,linedata);
    s = [num2str(index),'/',num2str(handles.linenum)];
    SetText(handles.text_index,s);
    handles.index = index;
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function MenuSmooth_Callback(hObject, eventdata, handles)
% hObject    handle to MenuSmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.inputdata;
prompt={'Enter level:'};
defaults={num2str(3)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    level = str2double(info(1));
    smoothdata = My_SWT(data,level);
    PlotAxes(handles.axes1,smoothdata(1,:));
    num = handles.linenum;
    s = num2str(num);
    s = ['1/',s];
    SetText(handles.text_index,s);
    handles.index = 1;
    handles.swtdata = smoothdata;
    %@plotdata will be ploted on @axes1
    handles.plotdata = smoothdata;
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function MenuDetect_Callback(hObject, eventdata, handles)
% hObject    handle to MenuDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = handles.index;
linedata =  handles.plotdata(index,:);
max_v = max(linedata(:));
min_v = min(linedata(:));
thre = 0.2 * (max_v - min_v);
prompt={'Enter Min Peak Prominence :'};
defaults={num2str(thre)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
PlotAxes(handles.axes1,linedata);
if ~isempty(info)
    level = str2double(info(1));
    [pck_infos,event_infos] = VectorsFindPeaks(linedata,level);
    if ~isempty(pck_infos)
        AxesAddPeaksLocation(handles.axes1,pck_infos(2,:),pck_infos(1,:));
        AxesAddPeaksWidth(handles.axes1,linedata,event_infos(:,1));
        AxesAddPeaksWidth(handles.axes1,linedata,event_infos(:,2));
    end
    handles.eventinfos{index} = event_infos;
end
guidata(hObject, handles);


function AxesAddPeaksLocation(myAxes,xVal,yVal)
set(myAxes,'visible','on');
axes(myAxes);
hold on
plot(xVal,yVal,'o');
hold off

function AxesAddPeaksWidth(myAxes, lineData,widthLoc)
yVal = lineData(widthLoc);
set(myAxes,'visible','on');
axes(myAxes);
hold on
plot(widthLoc,yVal,'r.');
hold off


% --- Executes on button press in btn_correction.
function btn_correction_Callback(hObject, eventdata, handles)
% hObject    handle to btn_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = handles.index;
linedata =  handles.plotdata(index,:);
handles.plotdata(index,:) = BleachCorrection(linedata);
PlotAxes(handles.axes1,handles.plotdata(index,:));
guidata(hObject, handles);
