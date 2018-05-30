function varargout = MainGUI(varargin)
% MAINGUI MATLAB code for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 30-May-2018 19:37:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;
handles.image = hObject;
handles.net = hObject;
handles.boxes = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadImage.
function LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[baseName, folder] = uigetfile('*.png');
if (folder ~= 0)
    handles.file = fullfile(folder, baseName);
    axes(handles.ImageIn);
    image = imread(handles.file);
    imshow(image);
    handles.SVM = load(fullfile('170P600N300M3I8020.mat'),'SVM2');
end


guidata(hObject, handles);




% --- Executes on button press in DetectPedestriansFast.
function DetectPedestriansFast_Callback(hObject, eventdata, handles)
% hObject    handle to DetectPedestriansFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DetectionTime,'String','Running');
drawnow;
image = imread(handles.file);
handles.image = image;
time = ScaleAndSlide(0.001,0.3,28,image,handles.SVM.SVM2, 80, 20, 0.68, 1, 30, 80, 0);
set(handles.DetectionTime,'string',string(time));



function DetectionTime_Callback(hObject, eventdata, handles)
% hObject    handle to DetectionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DetectionTime as text
%        str2double(get(hObject,'String')) returns contents of DetectionTime as a double


% --- Executes during object creation, after setting all properties.
function DetectionTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DetectionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DetectPedestrianAccurate.
function DetectPedestrianAccurate_Callback(hObject, eventdata, handles)
% hObject    handle to DetectPedestrianAccurate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DetectionTime,'String','Running');
drawnow;
image = imread(handles.file);
time = ScaleAndSlide(0.001,0.3,28,image,handles.SVM.SVM2, 80, 20, 0.68, 1, 20, 80, 1,handles.net,handles.boxes);
set(handles.DetectionTime,'string',string(time));





% --- Executes on button press in LoadRCNN.
function LoadRCNN_Callback(hObject, eventdata, handles)
% hObject    handle to LoadRCNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Setup matconvnet
run(fullfile('helper-functions','matconvnet-1.0-beta25','matlab','vl_setupnn')) ;
opts.classes = {'person'} ;
opts.gpu = [] ;
opts.confThreshold = 0.5 ;
opts.nmsThreshold = 0.3 ;
%opts = vl_argparse(opts,varargin) ;

% Load the fast-rcnn-vgg16-pascal07-dagnn network and put it in test mode.
[baseName, folder] = uigetfile('*.mat');
if (folder ~= 0)
    net = load(fullfile(folder, baseName));
end

%net = load(fullfile('Fast-RCNN','fast-rcnn-vgg16-pascal07-dagnn.mat')) ;
net = dagnn.DagNN.loadobj(net);
net.mode = 'test' ;

% Mark class and bounding box predictions as `precious` so they are
% not optimized away during evaluation.
net.vars(net.getVarIndex('cls_prob')).precious = 1 ;
handles.net = net;
% Load boxes
boxes = load(fullfile('helper-functions','matconvnet-1.0-beta25','examples','fast_rcnn','000004_boxes.mat')) ;
boxes = single(boxes.boxes') + 1 ;
handles.boxes = boxes;
set(handles.LoadRCNN,'Enable','off');

guidata(hObject,handles);

