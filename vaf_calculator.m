function varargout = vaf_calculator(varargin)
% VAF_CALCULATOR MATLAB code for vaf_calculator.fig
%      VAF_CALCULATOR, by itself, creates a new VAF_CALCULATOR or raises the existing
%      singleton*.
%
%      H = VAF_CALCULATOR returns the handle to a new VAF_CALCULATOR or the handle to
%      the existing singleton*.
%
%      VAF_CALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VAF_CALCULATOR.M with the given input arguments.
%
%      VAF_CALCULATOR('Property','Value',...) creates a new VAF_CALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vaf_calculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vaf_calculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vaf_calculator

% Last Modified by GUIDE v2.5 09-Jul-2019 01:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vaf_calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @vaf_calculator_OutputFcn, ...
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


% --- Executes just before vaf_calculator is made visible.
function vaf_calculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vaf_calculator (see VARARGIN)

% Choose default command line output for vaf_calculator
handles.output = hObject;

handles.loaded_data = [];
handles.binnedData = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vaf_calculator wait for user response (see UIRESUME)
% uiwait(handles.vaf_table);


% --- Outputs from this function are returned to the command line.
function varargout = vaf_calculator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file_path_Callback(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_path as text
%        str2double(get(hObject,'String')) returns contents of file_path as a double


%% Upload file
% --- Executes on button press in upload_file_button.
function upload_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to upload_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if ~isempty(handles.file_path)
%     handles.loaded_data = load(get(handles.file_path,'string'))
% else
%     return
% end

[filename, pathname] = uigetfile(fullfile('*.mat'),'Upload file');

if filename == 0
    return
end

filelocation = fullfile(pathname,filename);

handles.loaded_data = load(filelocation);

% Fills file location
set(handles.file_path, 'string', filelocation);

if ~isfield(handles.loaded_data,'data2')
    msgbox({'This file did not contain data2.'; 'Upload was unsuccessful.'},'Error');
else
    msgbox('Upload successful!', 'Success')
end

% Update handles structure
guidata(hObject, handles);



%% Process data
% --- Executes on button press in run_extraire_bins_button.
function run_extraire_bins_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_extraire_bins_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check and convert analog data to force if necessary
message = [];

if isempty(handles.loaded_data)
   message = msgbox('There was nothing to process!','Error');
   return
end

% If data2 has not been converted...
if max(handles.loaded_data.data2.trial1{4,1}) < 5
    message = msgbox('Converting analogue forces to grams...','Loading');
    handles.loaded_data.data2 = force_analog2grams(handles.loaded_data.data2,handles.loaded_data.fs);    
end

% Create binnedData
bin_size=.05; %s
params.binsize=bin_size;
handles.binnedData = extraire_bins_pour_force_et_clusters(handles.loaded_data.data2,handles.loaded_data.fs,'tout','initiation',params);

delete(message);

if ~isempty(handles.binnedData)
    msgbox('Processing complete!', 'Success')
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in mu.
function mu_Callback(hObject, eventdata, handles)
% hObject    handle to mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mu


% --- Executes on button press in su.
function su_Callback(hObject, eventdata, handles)
% hObject    handle to su (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of su


function folds_custom_Callback(hObject, eventdata, handles)
% hObject    handle to folds_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folds_custom as text
%        str2double(get(hObject,'String')) returns contents of folds_custom as a double


% --- Executes during object creation, after setting all properties.
function folds_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folds_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function numlags_custom_Callback(hObject, eventdata, handles)
% hObject    handle to numlags_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numlags_custom as text
%        str2double(get(hObject,'String')) returns contents of numlags_custom as a double


% --- Executes during object creation, after setting all properties.
function numlags_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numlags_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function numlags_slider_Callback(hObject, eventdata, handles)
% hObject    handle to numlags_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function numlags_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numlags_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in folds_default.
function folds_default_Callback(hObject, eventdata, handles)
% hObject    handle to folds_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of folds_default


% --- Executes on slider movement.
function zero_slider_Callback(hObject, eventdata, handles)
% hObject    handle to zero_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function zero_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zero_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function zero_custom_Callback(hObject, eventdata, handles)
% hObject    handle to zero_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zero_custom as text
%        str2double(get(hObject,'String')) returns contents of zero_custom as a double


% --- Executes during object creation, after setting all properties.
function zero_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zero_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lags_default.
function lags_default_Callback(hObject, eventdata, handles)
% hObject    handle to lags_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lags_default


% --- Executes on button press in zero_default.
function zero_default_Callback(hObject, eventdata, handles)
% hObject    handle to zero_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zero_default


%% Calculate VAF
% --- Executes on button press in calculate_vaf_button.
function calculate_vaf_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_vaf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

message = [];

if isempty(handles.binnedData)
    message = msgbox('There was nothing to calculate!','Error');
    return
else
    message = msgbox('Calculating VAF...', 'Loading');
end

% Parameters to customize
numlags = 5;
numfolds = 10;
zero_wind = 10;
extra = 4;

%% Mean VAF vs Number of lags
numlags_vaf = nan(numfolds,numlags + extra);

    for i = numlags - extra:numlags + extra
        numlags_vaf(:,i) = force_pred_mototrak(handles.binnedData,'numlags',i);
    end

handles.numlags_vaf = mean(numlags_vaf); 

axes(handles.numlags_figure);
% Plot VAF vs numlags
plot(handles.numlags_vaf,'-k');
% xticks(1:(numlags + extra));
hold on

[y1,x1] = find(handles.numlags_vaf == max(handles.numlags_vaf));

grid on
% Plot max VAF
plot(x1,max(handles.numlags_vaf),'-rx');
xlabel('Number of lags')
ylabel('Mean VAF')
hold off

delete(message);
message = msgbox('Still calculating... (1/3)','Loading');

%% Mean VAF vs size of zero window
zero_wind_vaf = nan(numfolds,zero_wind + extra);

    for i = zero_wind - extra:zero_wind + extra
        zero_wind_vaf(:,i) = force_pred_mototrak(handles.binnedData,'zero_wind',i);
    end

handles.zero_wind_vaf = mean(zero_wind_vaf); 

axes(handles.zero_wind_figure);
% Plot VAF vs zero-window
plot(handles.zero_wind_vaf,'-k');
% xticks(1:(zero_wind + extra));
hold on

[y2,x2] = find(handles.zero_wind_vaf == max(handles.zero_wind_vaf));

grid on
% Plot max VAF 
plot(x2,max(handles.zero_wind_vaf),'-rx');
xlabel('Zero-force bin size')
ylabel('Mean VAF')
hold off

delete(message);
message = msgbox('Almost ready... (2/3)','Loading');

%% Predicted vs actual force
pred_force = []; 
num_trials = size(handles.binnedData,1);
all_trials = 1:num_trials;

processed_spikes = cell(num_trials,1);
processed_force  = cell(num_trials,1);

for t = 1:num_trials
    spikes   = cell2mat(handles.binnedData.spike_bin(t,:)); 
    spikes = DuplicateAndShift(spikes,numlags); 
    spikes = spikes(numlags:end,:); 
    force    = handles.binnedData.force_bin{t}(numlags:end);
    
  % remove data where moving average of force is zero.
    valid_idx = movmean(force,zero_wind)>2; 
    processed_force{t}     = force(valid_idx); 
    processed_spikes{t}    = spikes(valid_idx,:);
end

num_test_trials  = (num_trials - mod(num_trials,numfolds))/numfolds;

for f = 1:numfolds
    
    test_trials = (1:num_test_trials)+(f-1)*num_test_trials; 
    train_trials = all_trials(~ismember(all_trials,test_trials)); 
    
    inputs  = vertcat(processed_spikes{train_trials}); 
    outputs = vertcat(processed_force {train_trials});
    
    % train decoder
    W = filMIMO4(inputs,outputs,1,1,1); 
    
    % test decoder
    test_spikes = vertcat(processed_spikes{test_trials}); 
    test_force  = vertcat(processed_force {test_trials});
    
    pred_force_temp = predMIMO4(test_spikes,W,test_force);
    
    % calc vaf
    vaf(f,1) = f;
    vaf(f,2) = calc_vaf(pred_force_temp,test_force);
    
    pred_force = [pred_force; pred_force_temp];
    
end

act_force = vertcat(processed_force{:});

% Fill table with fold # vs VAF
set(handles.mean_vaf_table, 'data', vaf);

% Mean VAF
set(handles.mean_vaf, 'string', mean(vaf(:,2)));

% SD VAF
set(handles.sd_vaf, 'string', std(vaf(:,2)));

axes(handles.force_figure);
% Plot actual force
plot(act_force(1:200),'-k');
xlabel('Bins')
ylabel('Force (g)')

hold on
% Plot predicted force
plot(pred_force(1:200),'-r'); 
legend('Actual force','Predicted force')

hold off

delete(message);
message = msgbox('Calculations complete!','Success');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes during object creation, after setting all properties.
function numlags_figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numlags_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate numlags_figure


% --- Executes during object creation, after setting all properties.
function force_figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to force_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate force_figure



function mean_vaf_Callback(hObject, eventdata, handles)
% hObject    handle to mean_vaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mean_vaf as text
%        str2double(get(hObject,'String')) returns contents of mean_vaf as a double



% --- Executes during object creation, after setting all properties.
function mean_vaf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean_vaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd_vaf_Callback(hObject, eventdata, handles)
% hObject    handle to sd_vaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd_vaf as text
%        str2double(get(hObject,'String')) returns contents of sd_vaf as a double


% --- Executes during object creation, after setting all properties.
function sd_vaf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd_vaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
