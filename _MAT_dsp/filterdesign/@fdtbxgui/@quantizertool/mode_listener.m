function mode_listener(this, varargin)
%   Copyright 1999-2010 The MathWorks, Inc.


% Varargin is just in case the callback tacks anything else onto this call.
% It is not used.

enabState = get(this, 'Enable');
h         = get(this, 'Handles');
% visState = get(this, 'Visible');

modelabels         = set(this, 'Mode');
roundmodelabels    = set(this, 'RoundMode');
overflowmodelabels = set(this, 'OverflowMode');

set(this.Handles.mode,'Value',strmatch(this.mode, modelabels));

if this.checkbox == false
    if ~isempty(h.label)
        setenableprop(h.label,'off');
    end
    if ~isempty(h.quantizerclass)
        setenableprop(h.quantizerclass, 'off');
    end
    
    set(h.checkbox, 'Value', 0);
    setenableprop([h.mode h.roundmode h.overflowmode h.format], 'off');
else
    % $$$     if ~isempty(h.label)
    % $$$       set(h.label,'visible',visState);
    % $$$     end
    % $$$     if ~isempty(h.quantizerclass)
    % $$$       setenableprop(h.quantizerclass, enabState);
    % $$$     end
    % $$$     set(h.checkbox,'visible',visState);
    % $$$     set(h.mode,'visible',visState);
    % $$$     if this.ShowQuantizerClass 
    % $$$       set(h.quantizerclass,'visible',visState);
    % $$$     end
    set(h.checkbox, 'Value', 1);
    if ~isempty(h.label)
        setenableprop(h.label,enabState);
    end
    setenableprop(h.mode, enabState);
    
    switch this.mode
    case 'double'
        set(h.roundmode,'Value',5);  % Round
        set(h.overflowmode,'Value',1); % Saturate
        set(h.format,'String','[64 11]');
        setenableprop([h.roundmode h.overflowmode h.format], 'off');
        
        % $$$       % It could be turning from 'none' to this format
        % $$$       set([h.roundmode,h.overflowmode,h.format], ...
        % $$$           'visible',visState);
    case 'single'
        set(h.roundmode,'Value',5);  % Round
        set(h.overflowmode,'Value',1); % Saturate
        set(h.format,'String','[32 8]');
        setenableprop([h.roundmode h.overflowmode h.format], 'off');
        
        % $$$       % It could be turning from 'none' to this format
        % $$$       set([h.roundmode,h.overflowmode,h.format], ...
        % $$$           'visible',visState);
        % $$$    case 'none'
        % $$$     set(h.roundmode,'visible','off');
        % $$$     set(h.overflowmode,'visible','off');
        % $$$     set(h.format,'visible','off');
    case 'float'
        set(h.roundmode,    'Value',  strmatch(this.roundmode, roundmodelabels));
        set(h.overflowmode, 'Value',  1); % Saturate
        set(h.format,       'String', ['[',num2str(getformat(this)),']']);
        
        setenableprop([h.roundmode,h.format], enabState);
        setenableprop(h.overflowmode, 'off');
        % $$$       % It could be turning from 'none' to this format
        % $$$       set([h.roundmode,h.overflowmode,h.format], ...
        % $$$           'visible',visState);
    case {'fixed','ufixed','float'}
        set(h.roundmode,    'Value',  strmatch(this.roundmode, roundmodelabels));
        set(h.overflowmode, 'Value',  strmatch(this.overflowmode, overflowmodelabels));
        set(h.format,       'String', ['[',num2str(getformat(this)),']']);
        setenableprop([h.roundmode,h.overflowmode,h.format], enabState);
    end
    % $$$       % It could be turning from 'none' to this format
    % $$$       set([h.roundmode,h.overflowmode,h.format], ...
    % $$$           'visible',visState);
end