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

% Last Modified by GUIDE v2.5 28-May-2018 18:44:40

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
definput = {'badboySVM', '100','100','50', '1', '80', '20' };
out = inputdlg(prompt,title,dims,definput);
SVM2 = generateModel( str2double(out{2}), str2double(out{3}), str2double(out{4}), str2double(out{5}), str2double(out{6}), str2double(out{7}) );
save(out{1}, 'SVM2');
handles.SVM = SVM2;

guidata(hObject, handles);




% --- Executes on button press in detectpeople.
function detectpeople_Callback(hObject, eventdata, handles)
% hObject    handle to detectpeople (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawnow;
image = imread(handles.file);
handle.time = ScaleAndSlide(handles.minSize,handles.maxSize,handles.samples,image, handles.SVM.SVM2, handles.hogrows, handles.hogcols, handles.prob, handles.sup, handles.xbox, handles.ybox, handles.xvar, handles.yvar );

set(handles.timestext,'string',  string(handle.time));
guidata(hObject, handles);




% --- Executes on slider movement.
function xvarslider_Callback(hObject, eventdata, handles)
% hObject    handle to xvarslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newVal = floor(get(hObject,'Value'));
set(hObject,'Value',newVal);
set(handles.xvartext, 'string', get(hObject, 'value'));
handles.xvar = newVal;
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function xvarslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xvarslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(handles.xvartext, 'string', get(hObject, 'value'));


% --- Executes on slider movement.
function minslide_Callback(hObject, eventdata, handles)
% hObject    handle to minslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject, 'value').*1000)/1000;
set(handles.mintext, 'string', val);
handles.minSize = val;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minslide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxslider_Callback(hObject, eventdata, handles)
% hObject    handle to maxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject, 'value').*100)/100;
set(handles.maxtext, 'string', val);
handles.maxSize = val;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function sampleslider_Callback(hObject, eventdata, handles)
% hObject    handle to sampleslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newVal = floor(get(hObject,'Value'));
set(hObject,'Value',newVal);
set(handles.sampletext, 'string', get(hObject, 'value'));
handles.samples = newVal;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sampleslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function xboxslider_Callback(hObject, eventdata, handles)
% hObject    handle to xboxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newVal = floor(get(hObject,'Value'));
set(hObject,'Value',newVal);
set(handles.xboxtext, 'string', get(hObject, 'value'));
handles.xbox = newVal;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function xboxslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xboxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function yboxslider_Callback(hObject, eventdata, handles)
% hObject    handle to yboxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newVal = floor(get(hObject,'Value'));
set(hObject,'Value',newVal);
set(handles.yboxtext, 'string', get(hObject, 'value'));
handles.ybox = newVal;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function yboxslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yboxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function probslider_Callback(hObject, eventdata, handles)
% hObject    handle to probslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject, 'value').*100)/100;
set(handles.probtext, 'string', val);
handles.prob = val;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function probslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in supbox.
function supbox_Callback(hObject, eventdata, handles)
% hObject    handle to supbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of supbox
handles.sup = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axis1
guidata(hObject, handles);


% --- Executes on slider movement.
function yvarslide_Callback(hObject, eventdata, handles)
% hObject    handle to yvarslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newVal = floor(get(hObject,'Value'));
set(hObject,'Value',newVal);
set(handles.yvartext, 'string', get(hObject, 'value'));
handles.yvar = newVal;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function yvarslide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yvarslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



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
