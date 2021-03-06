function varargout = FormTable(varargin)
% FORMTABLE MATLAB code for FormTable.fig
%      FORMTABLE, by itself, creates a new FORMTABLE or raises the existing
%      singleton*.
%
%      H = FORMTABLE returns the handle to a new FORMTABLE or the handle to
%      the existing singleton*.
%
%      FORMTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORMTABLE.M with the given input arguments.
%
%      FORMTABLE('Property','Value',...) creates a new FORMTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FormTable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FormTable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FormTable

% Last Modified by GUIDE v2.5 08-Jul-2017 15:03:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FormTable_OpeningFcn, ...
                   'gui_OutputFcn',  @FormTable_OutputFcn, ...
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


% --- Executes just before FormTable is made visible.
function FormTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FormTable (see VARARGIN)

% Choose default command line output for FormTable
handles.output = hObject;
fit_result = varargin{1};
col_name = varargin{2};
set(handles.uitable1,'ColumnName',col_name,'Data',real(fit_result{1}));
region_num = length(fit_result);
s = ['region 1/', num2str(region_num)];
SetText(handles.text_title,s);

% Update handles structure
handles.fit_result = fit_result;
handles.region_num = region_num;
handles.index = 1;
guidata(hObject, handles);

% UIWAIT makes FormTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FormTable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_plotdelta.
function btn_plotdelta_Callback(hObject, eventdata, handles)
% hObject    handle to btn_plotdelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = handles.index;
figure
subplot(2,1,1);
tem = handles.fit_result{idx}(:,6);
histogram(real(tem));
subplot(2,1,2);
tem = real(handles.fit_result{idx}(:,7));
histogram(real(tem));

function SetText(myText, myString)
set(myText,'String',myString);


% --- Executes on button press in btn_previous.
function btn_previous_Callback(hObject, eventdata, handles)
% hObject    handle to btn_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = handles.index;
if idx > 1
    idx = idx - 1;
    tem_data = handles.fit_result{idx};
    set(handles.uitable1,'Data',tem_data);
    s = ['region ',num2str(idx),'/', num2str(handles.region_num)];
    SetText(handles.text_title,s);
    handles.index = idx;
end
guidata(hObject, handles);

% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = handles.index;
if idx < handles.region_num
    idx = idx + 1;
    tem_data = handles.fit_result{idx};
    set(handles.uitable1,'Data',tem_data);
    s = ['region ',num2str(idx),'/', num2str(handles.region_num)];
    SetText(handles.text_title,s);
    handles.index = idx;
end
guidata(hObject, handles);
