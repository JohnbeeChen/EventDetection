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

% Last Modified by GUIDE v2.5 07-Jul-2017 16:34:09

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

% Update handles structure
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
