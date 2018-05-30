function varargout = ParamTuningGUI(varargin)
% PARAMTUNINGGUI MATLAB code for ParamTuningGUI.fig
%      PARAMTUNINGGUI, by itself, creates a new PARAMTUNINGGUI or raises the existing
%      singleton*.
%
%      H = PARAMTUNINGGUI returns the handle to a new PARAMTUNINGGUI or the handle to
%      the existing singleton*.
%
%      PARAMTUNINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMTUNINGGUI.M with the given input arguments.
%
%      PARAMTUNINGGUI('Property','Value',...) creates a new PARAMTUNINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParamTuningGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParamTuningGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParamTuningGUI

% Last Modified by GUIDE v2.5 30-May-2018 13:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParamTuningGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ParamTuningGUI_OutputFcn, ...
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


% --- Executes just before ParamTuningGUI is made visible.
function ParamTuningGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParamTuningGUI (see VARARGIN)

% Choose default command line output for ParamTuningGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ParamTuningGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParamTuningGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadmodel.
function loadmodel_Callback(hObject, eventdata, handles)
% hObject    handle to loadmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[model,modelpath]=uigetfile('*.mat');
if (modelpath ~= 0)
    modelp = fullfile(modelpath, model);
    handles.SVM = load(modelp,'SVM2');
end
guidata(hObject, handles);



% --- Executes on button press in loadimage.
function loadimage_Callback(hObject, eventdata, handles)
% hObject    handle to loadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.jpg;*.png;*.tiff;','Select file');
handles = guidata(hObject); 
if (ischar(pathname))
    handles.file = fullfile(pathname, filename);
    axes(handles.axis1);
    image = imread(handles.file);
    imshow(image);
end
guidata(hObject, handles);

% --- Executes on button press in generatemodel.
function generatemodel_Callback(hObject, eventdata, handles)
% hObject    handle to generatemodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Enter name of output model', 'Enter number of positive samples:', 'Enter number of negative samples:', 'Enter number of negative mining samples:', 'Enter number of negative mining iterations', 'rows for hog-transform', 'cols for hog-transform' };
title = 'Input';
dims = [1 35];
definput = {'badboySVM', '100','100','50', '1', '80', '30' };
out = inputdlg(prompt,title,dims,definput);
SVM2 = generateModel( str2double(out{2}), str2double(out{3}), str2double(out{4}), str2double(out{5}), str2double(out{6}), str2double(out{7}) );
save(strcat(out{1}, out{2},out{3},out{4},out{5},out{6}, out{7}), 'SVM2');
handles.SVM = SVM2;

guidata(hObject, handles);




% --- Executes on button press in detectpeople.
function detectpeople_Callback(hObject, eventdata, handles)
% hObject    handle to detectpeople (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawnow;
image = imread(handles.file);
time = ScaleAndSlide(handles.minSize,handles.maxSize,handles.samples,image, handles.SVM.SVM2, handles.hogrows, handles.hogcols, handles.prob, handles.sup, handles.xbox, handles.ybox, 0, 0, 0 );
set(handles.timestext,'string',  string(time));
guidata(hObject, handles);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.hogrows = str2double(get(hObject,'String'));
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hogrows = 30;
guidata(hObject, handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.hogcols = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hogcols = 80;
guidata(hObject, handles);



function mintext_Callback(hObject, eventdata, handles)
% hObject    handle to mintext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mintext as text
%        str2double(get(hObject,'String')) returns contents of mintext as a double
handles.minSize = str2double(get(hObject,'String'));
guidata(hObject, handles);


function maxtext_Callback(hObject, eventdata, handles)
% hObject    handle to maxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxtext as text
%        str2double(get(hObject,'String')) returns contents of maxtext as a double
handles.maxSize = str2double(get(hObject,'String'));
guidata(hObject, handles);


function sampletext_Callback(hObject, eventdata, handles)
% hObject    handle to sampletext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampletext as text
%        str2double(get(hObject,'String')) returns contents of sampletext as a double
handles.samples = str2double(get(hObject,'String'));
guidata(hObject, handles);


function xboxtext_Callback(hObject, eventdata, handles)
% hObject    handle to xboxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xboxtext as text
%        str2double(get(hObject,'String')) returns contents of xboxtext as a double
handles.xbox = str2double(get(hObject,'String'));
guidata(hObject, handles);


function yboxtext_Callback(hObject, eventdata, handles)
% hObject    handle to yboxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yboxtext as text
%        str2double(get(hObject,'String')) returns contents of yboxtext as a double
handles.ybox = str2double(get(hObject,'String'));
guidata(hObject, handles);


function probtext_Callback(hObject, eventdata, handles)
% hObject    handle to probtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of probtext as text
%        str2double(get(hObject,'String')) returns contents of probtext as a double

handles.prob = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '0.3');
handles.maxSize = 0.3;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mintext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '0.005');
handles.minSize = 0.005;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sampletext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampletext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '30');
handles.samples = 30;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function xboxtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xboxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '30');
handles.xbox = 30;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yboxtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yboxtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '80');

handles.ybox = 80;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function probtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'string', '0.6');

handles.prob = 0.6;
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.sup = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function checkbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.sup = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function axis1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on mouse press over axes background.
function axis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function axis1_Callack(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
