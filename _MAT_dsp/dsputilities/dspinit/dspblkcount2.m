function [str] = dspblkcount2(varargin)
% DSPBLKCOUNT2 is the mask function for the DSP System Toolbox Counter Block


% Copyright 1995-2008 The MathWorks, Inc.

block = gcbh;

if nargin == 0  
   dynamic(block);
else
   % set up icon display
   [str] = icon(block);
end

%---------------------------------------------

function dynamic(block)
% check the value of the control
% modify the dialog accordingl

% Preset the mask enables to all 'on':
en_orig = get_param(block,'MaskEnables');
en = en_orig;

CounterSize = 4;
HitValue = 7;
SamplePerFrame = 9;
SampleTimeEdit = 10;
CountDataType = 11;
HitDataType = 12;

% If count event is not free-run the disable the sample time edit box
% and disable the SamplesPerOutput frame edit box.
freerun = strcmpi('free running',get_param(block,'CountEvent'));
if ~freerun,
   en{SamplePerFrame}='off'; % SamplesPerFrame edit
   en{SampleTimeEdit}='off'; % Sample time edit
else
   en{SamplePerFrame}='on';  % SamplesPerFrame edit   
   en{SampleTimeEdit}='on';  % Sample time edit
end


% If userdef is the not the counter size disable the Max count dialog
userdef = strcmpi('user defined',get_param(block,'CounterSize'));
if ~userdef,
   en{CounterSize}='off';
else
   en{CounterSize}='on';
end


% If the hit output is not selected, then disable the hitvalue edit box 
hit = ~isempty(findstr('hit',lower(get_param(block,'Output'))));
if ~hit,
   en{HitValue}='off';  % Disable last dialog
else
   en{HitValue}='on';
end


norst = strcmp('off', get_param(block, 'ResetInput')); % reset port
cnt =  ~isempty(findstr('Count',get_param(block,'Output')));
cntisdouble = 1;
if ~cnt
    en{CountDataType} = 'off';
else
    en{CountDataType} = 'on';
    cntisdouble = strcmpi('double',get_param(block,'CntDType'));
end
if ~cntisdouble || ~hit
    en{HitDataType} = 'off';
else
    en{HitDataType} = 'on';
end

if ~isequal(en, en_orig),
   set_param(block,'MaskEnables',en);
   % Only show enabled parameters
   set_param(block,'MaskVisibilities',en);
end

%---------------------------------------------
function [str] = icon(block)
% Check the parameter values that were passed in
%  -Direction     (icon)
%  -Reset         (input)
%  -Enable        (input)
%  -Count         (output)
%  -Hit           (output)
%
% Set up the port labels and icon

direction = get_param(block,'Direction');
reset     = strcmp(get_param(block,'ResetInput'),'on');
count     = ~isempty(findstr('count',lower(get_param(block,'Output'))));
hit       = ~isempty(findstr('hit',lower(get_param(block,'Output'))));
freerun   = strcmpi('free running',get_param(block,'CountEvent'));
maxCtPort = strcmp('Specify via input port', get_param(block, 'CounterSize'));

s = '';

if (~freerun) 
    if strcmp(direction,'Up')
        s{1} = 'Inc';
    else
        s{1} = 'Dec';
    end     
    if (reset)
        if (maxCtPort)            
            s{2} = 'Rst'; s{3} = 'Max';
        else                    
            s{2} = 'Rst';
        end
    else
        if (maxCtPort)                       
            s{2} = 'Max';       
        end
    end
else
    if (reset)        
        if (maxCtPort)           
            s{1} = 'Rst'; s{2} = 'Max';
        else           
            s{1} = 'Rst';
        end
    else
        if (maxCtPort)           
            s{1} = 'Max';       
        end
    end
end

% Setup Outport label.  At least one exists
so = '';

if(count && hit) 
   so{1} = 'Cnt';     
   so{2} = 'Hit';  
elseif(count && ~hit)
   so{1} = 'Cnt';      
elseif(~count && hit)
   so{1} = 'Hit'; 
end

str = '';

if(strcmp(direction,'Up'))
    str = ['disp(''Count\nUp'');'];
else
    str = ['disp(''Count\nDown'');'];
end

for i=1:length(s)
str = [str 'port_label(''input'',' num2str(i) ',''' s{i} ''');'];
end
for i=1:length(so)
str = [str 'port_label(''output'',' num2str(i) ',''' so{i} ''');'];
end

% [EOF] dspblkcount.m
