function saveppt(filespec,varargin)
% SAVEPPT - save plots to PowerPoint.
%
% function SAVEPPT(save_file,<additional parameters>) saves the current Matlab figure
%  window or Simulink model window to a PowerPoint file designated by
%  filespec.  If save_file is omitted, the user is prompted to enter
%  one via UIPUTFILE.  If the path is omitted from filespec, the
%  PowerPoint file is created in the current Matlab working directory.
%
% SAVEPPT also accepts numerous additional optional parameters, they can
% be called from the matlab command line or in function form. All options
% can be preceded with a '-', but this is not required.
%
% 'columns' - number of columns to place multiple plots in, defaults to two
% 'fig[ure]' - Use the specified figure handle, defaults to gcf. Also
%           accepts an array of figures. More than 4 figures is not recommended.
% 'halign' - ['left','center','right'], horizontally align fig. Defaults to center
% 'notes' - Add notes to the powerpoint slide. \t & \n are passed as tab
% and new line respectively.
% 'padding' - Place a padding around the figure that is used for alignment and scaling.
%           Can be one number to be applied equally or an array in the format of
%           [left right top bottom]. Useful when plotting to template files
% 'render' - Choose print render mode: [painters,zbuffer,opengl]
% 'format' - Choose print format mode: [meta, bitmap]; default = bitmap
% 'Res' - Choose DPI Resolution, see print help dialog
% 'scale' - scale the figure to remaining space on the page while
%           maintaining aspect ratio, takes into account padding
%           and title spacing. Default: off
% 'stretch' - Used only with scale, stretch the figure to fill all
%           remaining space (taking into account padding and title). Default: off
% 'template' - Use template file specified. Is only used if the save file
% does not already exist.
% 'title' - Add a title or add a blank title so that one may be added later.
%           Title is placed at the top of the presentation unless a padding
%           is specified.
% 'valign' - ['top','center','bottom'] vertically align the graph
%
% scale, stretch & title do not require any additional arguments. If
% 'Title' is specified alone a blank title box will be added.
%
% Examples: (Identical calling methods are listed below commands in
% comments.)
% % Prompt for a save location
% plot(rand(1,100),rand(1,100),'*');
% saveppt2
%
% % Add a title "Hello World"
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','Title','Hello World');
% saveppt test.ppt -title 'Hello World'
% saveppt test.ppt -t 'Hello World'
%
% % Add a note "Hello again World"
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','notes','Hello again world');
%
% % scale the plot to fill the page, maintaining aspect ratio
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','scale');
% % saveppt('test.ppt','scale',true);
%
% % scale the plot to fill the page, ignoring aspect ratio
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','scale','stretch');
% saveppt('test.ppt','scale',true,'stretch',true);
% saveppt test.ppt -scale -stretch
%
% % scale the plot to fill the page, ignoring aspect ratio, with 150 pixels
% % of padding on all sides
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','scale','stretch','Padding',150);
% saveppt('test.ppt','scale',true,'stretch',true,'Padding',150);
%
% % scale the plot to fill the page, ignoring aspect ratio, with 150 pixels
% % of padding on left and right sides
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','scale','stretch','Padding',[150 150 0 0]);
% saveppt('test.ppt','scale',true,'stretch',true,'Padding',[150 150 0 0]);
%
% % scale the plot to fill the page, ignoring aspect ratio add blank title
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','scale','stretch','title');
% saveppt('test.ppt','scale',true,'stretch',true,'title',true);
%
% % Align the figure in the upper left corner
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','halign','left','valign','top');
%
% % Align the figure in the upper left corner
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','halign','right','valign','bottom');
%
% % Use the template 'Group Report.ppt'
% plot(rand(1,100),rand(1,100),'*');
% saveppt('test.ppt','template','Group Report.ppt');
%
% % Plot 4 figures horizontally aligned left with 2 columns
% a=figure('Visible','off');plot(1:10);
% b=figure('Visible','off');plot([1:10].^2);
% c=figure('Visible','off');plot([1:10].^3);
% d=figure('Visible','off');plot([1:10].^4);
% saveppt('test.ppt','figure',[a b c d],'columns',2,'title','Hello World!','halign','left')
%
% More flexibility is built in, but it is impossible to show all possible
% calling combinations, you may check out the source if you wish.
%
%
% See also print

%Ver 2.2, Copyright 2005, Mark W. Brown, mwbrown@ieee.org
%  changed slide type to include title.
%  added input parameter for title text.
%  added support for int32 and single data types for Matlab 6.0
%  added comments about changing bitmap resolution (for large images only)
%  swapped order of opening PPT and copying to clipboard (thanks to David Abraham)
%  made PPT invisible during save operations (thanks to Noah Siegel)
%
%Ver 3, Copyright 2008, Jed Frey, frey_jed@cat.com
%  Added template & notes features
%  Added multiple calling functions
%  Restructured calling sequence


% Establish valid save file name:
if nargin<1 || isempty(filespec);
    [fname, fpath] = uiputfile('*.ppt');
    if fpath == 0; return; end
    filespec = fullfile(fpath,fname);
else
    [fpath,fname,fext] = fileparts(filespec);
    if isempty(fpath); fpath = pwd; end
    if isempty(fext); fext = '.ppt'; end
    filespec = fullfile(fpath,[fname,fext]);
end
% Process additional parameters
if nargin>1
    % Set up valid parameters list
    validParameters={{'figure','fig','f'},... % Figure calls
        'template',{'notes','n'},{'scale','s'},... % Template, notes & scale call
        'stretch',{'title','t'},{'resolution','res'},{'render','r'},... 5 Stretch, Title, Resolution and Render Calls
        {'halign','h'},{'valign','v'},{'padding','pad','p'},{'columns','col','c'},... % Align, padding and column calls.
        {'format'}}; %Format of Figure copy
    % Validate additional input
    addlParms=validateInput(varargin,validParameters);
else
    % Just make addlParms an empty struct so that 'isfield' doesn't error
    % out.
    addlParms=struct;
end

% Additional Parameters Sanity Checks
% Validate that halign is a valid setting
if isfield(addlParms,'halign')&&sum(strcmpi(addlParms.halign,{'left','center','right'}))==0
    warning('saveppt:InvalidHalign','Invalid horizontal align specified, ignoring');
    addlParms=rmfield(addlParms,'halign');
end
% Validate that valign is a valid setting
if isfield(addlParms,'valign')&&sum(strcmpi(addlParms.valign,{'top','center','bottom'}))==0
    warning('saveppt:InvalidValign','Invalid vertical align specified, ignoring');
    addlParms=rmfield(addlParms,'valign');
end
% If there is more than 1 figure, scale must be enabled so that all of the
% figures will fit on a slide.
if ~isfield(addlParms,'scale')&&isfield(addlParms,'figure')&&length(addlParms.figure)>1
    addlParms.scale=true;
end
% Stretch only makes sense when used with scale. Ignore otherwise
if ~checkParm(addlParms,'scale')&&checkParm(addlParms,'stretch')
    addlParms.scale=true;
end
% Validate padding input
if isfield(addlParms,'padding')
    % Make sure that padding is a number
    if ~isnumeric(addlParms.padding)
        addlParms=rmfield(addlParms,'Padding');
        warning('saveppt:IncorrectPadding','Incorrect Padding Setting. Must be [l, r, t, b] or a single number, ignoring.')
        % Validate padding size
    elseif size(addlParms.padding,2)~=4&&size(addlParms.padding,2)~=1
        addlParms=rmfield(addlParms,'Padding');
        warning('saveppt:IncorrectPaddingSize','Incorrect Padding Size. Must be [l, r, t, b] or a single number, ignoring.')
        % If padding is just one number, fill in so that all of the numbers are
        % the same
    elseif size(addlParms.padding,2)==1
        addlParms.padding=repmat(addlParms.padding,1,4);
    end
end
% Set up defaults
% If title is specified empty, validateParameters will make it 'true', if
% that's the case just blank it out
if checkParm(addlParms,'title');
    addlParms.title='';
end
% If no note is specified, clear it and give a warning
if checkParm(addlParms,'notes');
    warning('saveppt:NoNoteGiven','No note was specified');
    addlParms=rmfield(addlParms,'notes');
end
% Default the number of columns to 2
if ~isfield(addlParms,'columns')||checkParm(addlParms,'columns')
    addlParms.columns=2;
end
% Configure Print Options
% Validate all of the figures
if isfield(addlParms,'figure')
    % Meaning they just put 'Figure', but didn't specify one, default
    % behavior for print, just remove the field
    if checkParm(addlParms,'figure')
        addlParms=rmfield(addlParms,'figure');
    else
        % More than 4 figures makes it hard to read
        if length(addlParms.figure)>4
            warning('saveppt:TooManyFigures','>4 figures is not recommended')
        end
    end
    % Check that the figures actually exist
    for i=1:length(addlParms.figure)
        try
            a=get(addlParms.figure(i));
        catch
            error('saveppt:FigureDoesNotExist',['Figure ' addlParms.figure(i) ' does not exist']);
        end
    end
else
    % If no figure is specified, use the current figure.
    addlParms.figure=gcf;
end
% Resolution options
if isfield(addlParms,'resolution')
    resOpt=['-r ' num2str(addlParms.resolution)];
else
    resOpt='';
end
% Render schema options
if isfield(addlParms,'render')
    if strcmpi(addlParms.render,'painters')
        rendOpt='-painters';
    elseif strcmpi(addlParms.render,'zbuffer')
        rendOpt='-zbuffer';
    elseif strcmpi(addlParms.render,'opengl')
        rendOpt='-opengl';
    elseif checkParm(addlParms,'render')
        rendOpt='';
    else
        error('saveppt:UnknownRenderer',['Unknown Renderer ' addlParms.render]);
    end
else
    rendOpt='';
end

%Print copy options
cpOpt = '-dbitmap';
if isfield(addlParms, 'format'),
    if strcmpi(addlParms.format,'meta'),
        cpOpt = '-dmeta';
    end
end
if length(addlParms.figure) > 1,
    %override bitmap option when more than one figure on slide
    %otherwise, multiple figures will not work
    cpOpt = '-dmeta';
end

% Start an ActiveX session with PowerPoint:
ppt = actxserver('PowerPoint.Application');
% Enable for testing
% ppt.visible=1;
if exist(filespec,'file')
    % If the save file already exists, the template cannot be applied.
    if isfield(addlParms,'template')
        addlParms=rmfield(addlParms,'template');
        warning('saveppt:fileexist','Save file exists, skipping opening template');
    end
    op = invoke(ppt.Presentations,'Open',filespec,[],[],0);
else
    % If a template is specified
    if isfield(addlParms,'template')
        % Check that the file exists
        if ~exist(addlParms.template,'file');
            warning('saveppt:notemplate','Template file does not exist');
            op = invoke(ppt.Presentations,'Add');
        else
            % Open the template file
            op = invoke(ppt.Presentations,'Open',addlParms.template,[],[],0);
        end
    else
        op = invoke(ppt.Presentations,'Add');
    end
end
% Slide functions
% Get height and width of slide:
slide_H = op.PageSetup.SlideHeight;
slide_W = op.PageSetup.SlideWidth;
% Get current number of slides:
slide_count = get(op.Slides,'Count');
% Add a new slide (with title object):
slide_count = int32(double(slide_count)+1);
% Create the appropriate slide (w or w/o title)
if isfield(addlParms,'title')
    % Slide with Title
    new_slide = invoke(op.Slides,'Add',slide_count,11);
    % Set the text in the title to the specified title
    set(new_slide.Shapes.Title.TextFrame.TextRange,'Text',addlParms.title);
    % Set the text frame to autosize
    new_slide.Shapes.Title.TextFrame.AutoSize=1;
    % If padding is specified, use that.
    if isfield(addlParms,'padding')
        set(new_slide.Shapes.Title,'Top',addlParms.padding(3));
    else
        % Otherwise move the title up towards the top of the scope
        set(new_slide.Shapes.Title,'Top',get(new_slide.Shapes.Title.TextFrame.TextRange.Font,'Size')/4);
    end
    % Resize the title so that it is the width of the slide
    set(new_slide.Shapes.Title,'Left',0);
    set(new_slide.Shapes.Title,'Width',slide_W);
    % Set the 'top' of where the bottom of the title is.
    top=get(new_slide.Shapes.Title,'Top')+get(new_slide.Shapes.Title,'Height');
else
    % Slide with No Title
    new_slide = invoke(op.Slides,'Add',slide_count,12);
    if isfield(addlParms,'padding')
        top=addlParms.padding(3);
    else
        top=0;
    end
end
% If padding is given, use that (top is specified above)
if isfield(addlParms,'padding')
    left=addlParms.padding(1);
    right=addlParms.padding(2);
    bottom=addlParms.padding(4);
else
    bottom=0;
    left=0;
    right=0;
end
% Figure Functions
% Calculate the number of rows and columns
fig.count=length(addlParms.figure);
fig.rows=(floor((fig.count-1)/addlParms.columns))+1;
fig.columns=min(fig.count,addlParms.columns);
% For each figure
for i=1:fig.count
    % Determine what row and column the current figure is on
    row=floor((i-1)/addlParms.columns);
    column=mod(i-1,addlParms.columns);
    % Copy the figure to the clipboard
    print(cpOpt,['-f' num2str(addlParms.figure(i))],rendOpt,resOpt);
    % Paste the contents of the Clipboard:
    pic1 = invoke(new_slide.Shapes,'Paste');
    % Get height and width of picture:
    pic_H = get(pic1,'Height');
    pic_W = get(pic1,'Width');
    % If scale is specified:
    if checkParm(addlParms,'scale')
        % If stretch is specified, scretch the figure to it's 'box' (full
        % page if there is only 1)
        if checkParm(addlParms,'stretch')
            set(pic1,'LockAspectRatio','msoFalse')
            set(pic1,'Width',(slide_W-(left+right))/fig.columns);
            set(pic1,'Height',(slide_H-(top+bottom))/fig.rows);
        else
            % Determine if the height or the width will be the constraint,
            % then set the picture height or width accordingly
            if ((slide_H)/fig.rows)/((slide_W)/fig.columns)>(pic_H+(top+bottom))/(pic_W+(left+right))
                set(pic1,'Width',(slide_W-(left+right))/fig.columns);
            else
                set(pic1,'Height',(slide_H-(top+bottom))/fig.rows);
            end
        end
    end
    % Get the figure height and widths
    fig.width=get(pic1,'Width');
    fig.height=get(pic1,'Height');
    % Do a vertical alignment based on input
    if isfield(addlParms,'valign')
        if strcmpi(addlParms.valign,'center')
            set(pic1,'Top',top+0.5*(slide_H-(fig.height*fig.rows+top+bottom))+fig.height*row);
        elseif strcmpi(addlParms.valign,'top')
            set(pic1,'Top',top+fig.height*row);
        elseif strcmpi(addlParms.valign,'bottom')
            set(pic1,'Top',slide_H-(fig.height*fig.rows+bottom)+fig.height*row);
        end
    else
        % Or default to center
        set(pic1,'Top',top+0.5*(slide_H-(fig.height*fig.rows+top+bottom))+fig.height*row);
    end
    % Do a horizontal alignment based on input
    if isfield(addlParms,'halign')
        if strcmpi(addlParms.halign,'center')
            set(pic1,'Left',left+0.5*(slide_W-(fig.width*min(fig.count-fig.columns*row,fig.columns)+left+right))+fig.width*column);
        elseif strcmpi(addlParms.halign,'left')
            set(pic1,'Left',left+fig.width*column);
        elseif strcmpi(addlParms.halign,'right')
            set(pic1,'Left',slide_W-(fig.width*min(fig.count-fig.columns*row,fig.columns)+left+right)+fig.width*column);
        end
    else
        % Or default
        set(pic1,'Left',left+0.5*(slide_W-(fig.width*min(fig.count-fig.columns*row,fig.columns)+left+right))+fig.width*column);
    end
end
% Add notes if they are specified
if isfield(addlParms,'notes')
    % If the notes are a number, convert it to text
    if isnumeric(addlParms.notes)
        addlParms.notes=num2str(addlParms.notes);
    else
        % Convert \n and \t into characters for powerpoint
        warning('off','MATLAB:strrep:InvalidInputType');
        addlParms.notes=strrep(addlParms.notes,'\n',13);
        addlParms.notes=strrep(addlParms.notes,'\t',9);
    end
    % Taken from this page: http://www.mahipalreddy.com/vba.htm
    if get(new_slide.notesPage.Shapes,'Count')==0
        % Still haven't figured this Matlab -> VBA out. AddRect returns an
        % error
        warning('saveppt:nonoteadded','No note box found, none added');
    else
        for i=1:get(new_slide.notesPage.Shapes,'Count')
            if strcmp(get(new_slide.notesPage.Shape.Item(i),'HasTextFrame'),'msoTrue')
                set(new_slide.notesPage.Shape.Item(i).TextFrame.TextRange,'Text',addlParms.notes);
                break;
            end
        end
    end
end
% Exit Functions
% Save the file
if ~exist(filespec,'file')
    % Save file as new:
    invoke(op,'SaveAs',filespec,1);
else
    % Save existing file:
    invoke(op,'Save');
end
% Close the presentation window:
invoke(op,'Close');
% Quit PowerPoint
invoke(ppt,'Quit');
return
end

% Supporting Functions. Here Be Dragons.
% Check to see if the parameters is 'set'
function result=checkParm(addlParms,parm)
result=0;
try
    if isfield(addlParms,parm)
        if islogical(addlParms.(parm))&&addlParms.(parm)==true
            result=1;
        end
    end
catch
end
return
end


% Validate Inputs, functionalized so that it can be reused
function addlParms=validateInput(argsIn,validParameters)
i=1;
while i<=numel(argsIn)
    [validParameter,parmName]=valid(argsIn{i},validParameters);
    if ~validParameter
        error('saveppt:UnknownParameter',['Unknown Parameter: ' argsIn{i}]);
    end
    if i+1>numel(argsIn)||valid(argsIn{i+1},validParameters)
        addlParms.(parmName)=true;
        i=i+1;
    else
        addlParms.(parmName)=argsIn{i+1};
        if islogical(addlParms.(parmName))&&addlParms.(parmName)==true
            addlParms.(parmName)=true;
        elseif strcmpi(addlParms.(parmName),'yes')||strcmpi(addlParms.(parmName),'on')
            addlParms.(parmName)=true;
        elseif ischar(addlParms.(parmName))&&~isempty(str2num(addlParms.(parmName)))
            addlParms.(parmName)=str2num(addlParms.(parmName));
        end
        i=i+2;
    end
end
end

function [validParameter,name] = valid(parameter,validParameters)
validParameter=false;
name='';
for j=1:numel(validParameters)
    if iscell(validParameters{j})
        for k=1:numel(validParameters{j})
            if strcmpi(validParameters{j}{k},parameter)||(strcmpi(parameter(1),'-')&&strcmpi(validParameters{j}{k},parameter(2:length(parameter))))
                validParameter=true;
                name=validParameters{j}{1};
                return;
            end
        end
    else
        if strcmpi(validParameters{j},parameter)||(strcmpi(parameter(1),'-')&&strcmpi(validParameters{j},parameter(2:length(parameter))))
            name=validParameters{j};
            validParameter=true;
            return;
        end
    end
end
end