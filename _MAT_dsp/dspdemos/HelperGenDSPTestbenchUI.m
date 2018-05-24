function varargout = HelperGenDSPTestbenchUI(varargin)
% HELPERGENDSPTESTBENCHUI MATLAB code for HelperGenDSPTestbenchUI.fig
%      HELPERGENDSPTESTBENCHUI, by itself, creates a new
%      HELPERGENDSPTESTBENCHUI or raises the existing singleton*.
%
%      H = HELPERGENDSPTESTBENCHUI returns the handle to a new
%      HELPERGENDSPTESTBENCHUI or the handle to the existing singleton*.
%
%      HELPERGENDSPTESTBENCHUI('CALLBACK',hObject,eventData,handles,...)
%      calls the local function named CALLBACK in HELPERGENDSPTESTBENCHUI.M
%      with the given input arguments.
%
%      HELPERGENDSPTESTBENCHUI('Property','Value',...) creates a new
%      HELPERGENDSPTESTBENCHUI or raises the existing singleton*.  Starting
%      from the left, property value pairs are applied to the GUI before
%      HelperGenDSPTestbenchUI_OpeningFcn gets called.  An unrecognized
%      property name or invalid value makes property application stop.  All
%      inputs are passed to HelperGenDSPTestbenchUI_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help
% HelperGenDSPTestbenchUI

% Last Modified by GUIDE v2.5 14-Oct-2013 12:15:02

% Copyright 2013 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HelperGenDSPTestbenchUI_OpeningFcn, ...
                   'gui_OutputFcn',  @HelperGenDSPTestbenchUI_OutputFcn, ...
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


function HelperGenDSPTestbenchUI_OpeningFcn(hObject, eventdata, handles, varargin)
% --- Executes just before HelperGenDSPTestbenchUI is made visible.
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HelperGenDSPTestbenchUI (see VARARGIN)

% Choose default command line output for HelperGenDSPTestbenchUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initialize GUI - Set default values for various UI Components
initialize_gui(hObject, handles, false);

% UIWAIT makes HelperGenDSPTestbenchUI wait for user response (see UIRESUME)
% uiwait(handles.figure_main);


function varargout = HelperGenDSPTestbenchUI_OutputFcn(hObject, eventdata, handles) 
% --- Outputs from this function are returned to the command line.
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% ----------------------- Sources Panel ----------------------------------
function checkbox_AudioFileReader_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_AudioFileReader.
% hObject    handle to checkbox_AudioFileReader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AudioFileReader


function checkbox_AudioRecorder_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_AudioRecorder.
% hObject    handle to checkbox_AudioRecorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AudioRecorder


function checkbox_SineWave_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_SineWave.
% hObject    handle to checkbox_SineWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SineWave


function checkbox_ColoredNoise_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_ColoredNoise.
% hObject    handle to checkbox_ColoredNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ColoredNoise


function checkbox_MatFileReader_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_MatFileReader.
% hObject    handle to checkbox_MatFileReader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_MatFileReader

function checkbox_randn_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_randn.
% hObject    handle to checkbox_randn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_randn


% ----------------------- Algorithm Panel --------------------------------
function edit_CustomAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CustomAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CustomAlgorithm as text
%        str2double(get(hObject,'String')) returns contents of edit_CustomAlgorithm as a double

if get(hObject, 'String')
    set(handles.checkbox_ParameterTuningGUI, 'Enable', 'On');
    if get(handles.checkbox_ParameterTuningGUI, 'Value')
        set(handles.pushbutton_ToggleParametersTable, 'Enable', 'On');
    end
else
    set(handles.checkbox_ParameterTuningGUI, 'Enable', 'Off');
    set(handles.pushbutton_ToggleParametersTable, 'Enable', 'Off');
    show_hide_ParametersTable(hObject, handles, true);
end


function edit_CustomAlgorithm_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% hObject    handle to edit_CustomAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox_ParameterTuningGUI_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_ParameterTuningGUI.
% hObject    handle to checkbox_ParameterTuningGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ParameterTuningGUI
if get(hObject, 'Value')
    set(handles.pushbutton_ToggleParametersTable, 'Enable', 'On');
else
    show_hide_ParametersTable(hObject, handles, true);
    set(handles.pushbutton_ToggleParametersTable, 'Enable', 'Off');
end


function pushbutton_ToggleParametersTable_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_ToggleParametersTable.
% hObject    handle to pushbutton_ToggleParametersTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject, 'String'), 'Show Parameters Table')
    show_hide_ParametersTable(hObject, handles, false);
else
    show_hide_ParametersTable(hObject, handles, true);
end



% ----------------------- Pushback Buttons -------------------------------
function pushbutton_GenerateCode_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_GenerateCode.
% hObject    handle to pushbutton_GenerateCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Sources 
sources = [];
if get(handles.checkbox_AudioFileReader, 'Value')
    sources = horzcat(sources, {'dsp.AudioFileReader'});
end

if get(handles.checkbox_AudioRecorder, 'Value')
    sources = horzcat(sources, {'dsp.AudioRecorder'});
end

if get(handles.checkbox_SineWave, 'Value')
    sources = horzcat(sources, {'dsp.SineWave'});
end

if get(handles.checkbox_ColoredNoise, 'Value')
    sources = horzcat(sources, {'dsp.ColoredNoise'});
end

if get(handles.checkbox_MatFileReader, 'Value')
    sources = horzcat(sources, {'dsp.MatFileReader'});
end

if get(handles.checkbox_randn, 'Value')
    sources = horzcat(sources, {'randn'});
end
    

% Sinks
sinks = [];
if get(handles.checkbox_AudioFileWriter, 'Value')
    sinks = horzcat(sinks, {'dsp.AudioFileWriter'});
end

if get(handles.checkbox_AudioPlayer, 'Value')
    sinks = horzcat(sinks, {'dsp.AudioPlayer'});
end

if get(handles.checkbox_TimeScope, 'Value')
    sinks = horzcat(sinks, {'dsp.TimeScope'});
end

if get(handles.checkbox_SpectrumAnalyzer, 'Value')
    sinks = horzcat(sinks, {'dsp.SpectrumAnalyzer'});
end

if get(handles.checkbox_MatFileWriter, 'Value')
    sinks = horzcat(sinks, {'dsp.MatFileWriter'});
end

if get(handles.checkbox_TransferFunctionEstimator, 'Value')
    sinks = horzcat(sinks, {'dsp.TransferFunctionEstimator'});
end

% Algorithm
alg = get(handles.edit_CustomAlgorithm, 'String');

% Call HelperGenDSPTestbench function based on the selected options
if alg
    if get(handles.checkbox_ParameterTuningGUI, 'Value')
        data = validateParametersTable(hObject, handles.uitable_ParametersTable);
        if ~isempty(data)
            numRows = size(data,1);
            for k = 1:numRows
                param(k).Name = data{k,1};
                param(k).InitialValue = str2num(data{k,2});
                param(k).Limits = [str2num(data{k,3}), str2num(data{k,4})];
            end
            HelperGenDSPTestbench(sources, sinks, alg, param);
        else
            HelperGenDSPTestbench(sources, sinks, alg);
        end 
    else
        HelperGenDSPTestbench(sources, sinks, alg);
    end
else
    HelperGenDSPTestbench(sources, sinks);
end



function pushbutton_ClearAll_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_ClearAll.
% hObject    handle to pushbutton_ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize / Reset GUI - set default values for various UI Components
initialize_gui(hObject, handles, true);


function pushbutton_Reset_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_Reset.
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize_gui(hObject, handles, false);



% --------------------------- Sinks --------------------------------------
function checkbox_AudioFileWriter_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_AudioFileWriter.
% hObject    handle to checkbox_AudioFileWriter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AudioFileWriter


function checkbox_AudioPlayer_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_AudioPlayer.
% hObject    handle to checkbox_AudioPlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AudioPlayer


function checkbox_TimeScope_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_TimeScope.
% hObject    handle to checkbox_TimeScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_TimeScope


function checkbox_SpectrumAnalyzer_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_SpectrumAnalyzer.
% hObject    handle to checkbox_SpectrumAnalyzer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SpectrumAnalyzer


function checkbox_MatFileWriter_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_MatFileWriter.
% hObject    handle to checkbox_MatFileWriter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_MatFileWriter


function checkbox_TransferFunctionEstimator_Callback(hObject, eventdata, handles)
% --- Executes on button press in checkbox_TransferFunctionEstimator.
% hObject    handle to checkbox_TransferFunctionEstimator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_TransferFunctionEstimator



% ------------------------ Parameters Table ------------------------------
function pushbutton_ClearTable_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_ClearTable.
% hObject    handle to pushbutton_ClearTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize_ParametersTable(hObject, handles, true);


function pushbutton_AddRow_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_AddRow.
% hObject    handle to pushbutton_AddRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles.uitable_ParametersTable;
data = get(h, 'Data');

% Resize the table to accommodate scroll bars (>8 rows need scroll bars).
[numRows, numCols] = size(data);
tablePos = get(h, 'Position');
if numRows < 9
    % Increase only the height of the table
    rowHeight = 1.38;
    tablePos(2) = tablePos(2) - rowHeight;
    tablePos(4) = tablePos(4) + rowHeight;
elseif numRows == 9
    % Increase the width of the table to accommodate the vertical scroll
    % bar
    scrollBarWidth = 4;
    tablePos(3) = tablePos(3) + scrollBarWidth;
%Else do nothing. Scroll bars will take care of more rows
end
set(h, 'Position', tablePos);

data = [data; repmat({''}, 1, numCols)];
set(h, 'Data', data);


function pushbutton_DeleteRow_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_DeleteRow.
% hObject    handle to pushbutton_DeleteRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles.uitable_ParametersTable;
data = get(h, 'Data');

numRows = size(data,1);

% Don't delete if there is only one row in the table
if numRows <= 1
    return;
end

% Adjust table positions (size)
tablePos = get(h, 'Position');
if numRows < 10 
    % Decrease only the height of the table
    rowHeight = 1.38;
    tablePos(2) = tablePos(2) + rowHeight;
    tablePos(4) = tablePos(4) - rowHeight;
elseif numRows == 10
    % Decrease the width of the table considering the automatic removal of
    % the vertical scroll bar
    scrollBarWidth = 4;
    tablePos(3) = tablePos(3) - scrollBarWidth;
%Else, do nothing with respect to size.
end
set(h, 'Position', tablePos);
set(h, 'Data', data(1:end-1,:));

% ---------------------- Helper Functions --------------------------------
function initialize_gui(hObject, handles, isclearall)
% Initialize / reset / clear various UI components in the GUI

% By default, the enabled sources are dsp.SineWave and Random Signal, and
% the enabled sinks are dsp.SpectrumAnalyzer and dsp.AudioPlayer. The
% custom function is empty.

if ~isclearall
    % Enabled sources
    set(handles.checkbox_AudioFileReader, 'Value', 1);
    % Enabled Sinks
    set(handles.checkbox_SpectrumAnalyzer, 'Value', 1);
    set(handles.checkbox_AudioPlayer, 'Value', 1);
    % Custom Algorithm
    set(handles.edit_CustomAlgorithm, 'String', 'HelperTestbenchAlgorithm');
    set(handles.checkbox_ParameterTuningGUI, 'Enable', 'On');
    set(handles.checkbox_ParameterTuningGUI, 'Value', 1);
    set(handles.pushbutton_ToggleParametersTable, 'Enable', 'On');
else
    set(handles.checkbox_AudioFileReader, 'Value', 0);
    set(handles.checkbox_SpectrumAnalyzer, 'Value', 0);
    set(handles.checkbox_AudioPlayer, 'Value', 0);
    set(handles.edit_CustomAlgorithm, 'String', '');
    set(handles.checkbox_ParameterTuningGUI, 'Enable', 'Off');
    set(handles.checkbox_ParameterTuningGUI, 'Value', 0);
    set(handles.pushbutton_ToggleParametersTable, 'Enable', 'Off');
end

% Uncheck Sources
set(handles.checkbox_AudioRecorder, 'Value', 0);
set(handles.checkbox_randn, 'Value', 0);
set(handles.checkbox_SineWave, 'Value', 0);
set(handles.checkbox_ColoredNoise, 'Value', 0);
set(handles.checkbox_MatFileReader, 'Value', 0);

% Uncheck Sinks
set(handles.checkbox_AudioFileWriter, 'Value', 0);
set(handles.checkbox_TimeScope, 'Value', 0);
set(handles.checkbox_MatFileWriter, 'Value', 0);
set(handles.checkbox_TransferFunctionEstimator, 'Value', 0);

% Parameters Table
initialize_ParametersTable(hObject, handles, isclearall);
show_hide_ParametersTable(hObject, handles, isclearall);


function show_hide_ParametersTable(hObject, handles, ishide)
% To show / hide the parametersTable

hFig = handles.figure_main;
hPanel = handles.uipanel_MainPanel;

% Get figure and main panel positions in 'Points'
% figUnits = get(hFig, 'Units');
% panelUnits = get(hPanel, 'Units');
% set(hFig, 'Units', 'Points');
% set(hPanel, 'Units', 'Points');
figPos = get(hFig, 'Position');
panelPos = get(hPanel, 'Position');

% Show / hide the parameters table. Resize the figure and move the main
% panel accordingly.
if ishide
    set(handles.uipanel_ParametersTable, 'Visible', 'Off');
    
    % Set Position.y = 0 with respect to the figure.
    panelPos(2) = 0; 
    set(hPanel, 'Position', panelPos);
    
    % Now resize the figure. New height of figure = height of main panel.
    figPos(2) = figPos(2) + figPos(4) - panelPos(4);
    figPos(4) = panelPos(4);  
    set(hFig, 'Position', figPos);
    
    % When the parameters table is hidden, the push button should read
    % "Show Parameters Table"
    set(handles.pushbutton_ToggleParametersTable, 'String', 'Show Parameters Table');
else
    % Resize the figure. New height of figure = current height + height of
    % table panel.
    tablePanelHeight = 17.948;
    figPos(2) = figPos(2) + figPos(4) - panelPos(4) - tablePanelHeight;
    figPos(4) = panelPos(4) + tablePanelHeight;
    set(hFig, 'Position', figPos);
    
    % Set MainPanel Position.y = height of Table Panel
    panelPos(2) = tablePanelHeight;
    set(hPanel, 'Position', panelPos);
    
    % When the parameters table is shown, the push button should read
    % "Hide Parameters Table"
    set(handles.uipanel_ParametersTable, 'Visible', 'On');
    set(handles.pushbutton_ToggleParametersTable, 'String', 'Hide Parameters Table');
end

% % Set figure and main panel Units back to its original settings.
% set(hFig, 'Units', figUnits);
% set(hPanel, 'Units', panelUnits);


function initialize_ParametersTable(hObject, handles, isclearall)
% Initialize / Clear ParametersTable

% By default, the enabled source is dsp.AudioFileReader and the enabled
% sinks are dsp.SpectrumAnalyzer and dsp.AudioPlayer. The custom function
% is HelperTestbenchAlgorithm, which uses three parameters.

h = handles.uitable_ParametersTable;
if isclearall
    data = get(h, 'Data');
    newData = repmat({''},4,size(data,2));
else
    % Provide sample data to the ParametersTable to be used by the default
    % HelperTestbenchAlgorithm
    data = get(h, 'Data');
    row1 = {'CF', '2000', '0', '10000'};
    row2 = {'BW', '1000', '0', '5000'};
    row3 = {'Gain', '10', '-20', '20'};
    row4 = repmat({''},1,size(data,2));
    newData = [row1; row2; row3; row4];
end
set(h, 'Data', newData);

% uitable supports manual ColumnWidth only in pixels. So, manually set the
% width of the table for Windows, Mac and Unix architecture.
if ispc
    set(h, 'Position', [2.4, 8, 79.1, 7.2]);
elseif ismac
    set(h, 'Position', [2.4, 8, 65.87, 7.7]);
else
    set(h, 'Position', [2.4, 8, 70.2, 7.2]);
end


function validData = validateParametersTable(hObject, hTable)
data = get(hTable, 'Data');
nRows = size(data,1);
validRowIndices = zeros(nRows,1);
invalidRowStr = '';

for k = 1:nRows
    
    % Ignore empty rows
    if isempty(data{k,1}) && isempty(data{k,2}) && isempty(data{k,3}) ...
            && isempty(data{k,4})
        continue;
    end
    
    % Check if first column data is a valid character array
    if isempty(data{k,1}) || ~isempty(str2num(data{k,1})) || ~ischar(data{k,1}) %#ok<*ST2NM>
        if invalidRowStr 
            invalidRowStr = [invalidRowStr, ', ', num2str(k)]; %#ok<AGROW>
        else
            invalidRowStr = num2str(k);
        end
        continue;
    end
    
    % Check the data in columns 2,3 and 4 are numeric
    if isempty(str2num(data{k,2})) || isempty(str2num(data{k,3})) || ...
            isempty(str2num(data{k,4}))
        if invalidRowStr
            invalidRowStr = [invalidRowStr, ', ', num2str(k)]; %#ok<AGROW>
        else
            invalidRowStr = num2str(k);
        end
        continue;
    end
    
    % Check if default value (column 2) lies between minVal (column 3) and
    % maxVal (column 4)
    if (str2num(data{k,2}) < str2num(data{k,3})) || (str2num(data{k,2}) > str2num(data{k,4}))
        if invalidRowStr
            invalidRowStr = [invalidRowStr, ', ', num2str(k)]; %#ok<AGROW>
        else
            invalidRowStr = num2str(k);
        end
        continue;
    end
    
    % At this point, mark the row index as valid.
    validRowIndices(k) = 1;
end

if invalidRowStr
    str = sprintf('The following row entries are invalid in the Parameters Table:\n');
    str = [str, invalidRowStr];
    str = [str, sprintf('\n\nThey are ignored while generating the testbench MATLAB code.')];
    errordlg(str, 'Invalid Rows in Parameters table');
end

if any(validRowIndices)
    validData = data(logical(validRowIndices),:);
else
    validData = {};
end
