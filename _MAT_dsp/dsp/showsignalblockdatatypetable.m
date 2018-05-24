function [list, lib] = showsignalblockdatatypetable(Action)
%SHOWSIGNALBLOCKDATATYPETABLE Launch DSP System Toolbox Data-type Support Table  
%   Launches html page in help browser to show data type support and 
%   production intent information for DSP System Toolbox.

% Copyright 1995-2011 The MathWorks, Inc.

if nargin == 0
    Action = 'LaunchHTML';
end

switch Action
    case 'LaunchHTML'
        % DSPLIB must be loaded for this function to work.
        if isempty(find_system('SearchDepth', 0, 'CaseSensitive', 'off', 'Name', 'dsplibv4'))
            disp(DAStudio.message('SignalBlockset:bcst:LoadingSPLib'));
            load_system('dsplibv4');
        end
        sl('bcstMakeSlSupportTable', 'dspliblist.m', false, 'dsplibv4');
        
    case 'GetListandLib'
        list = 'dspliblist';
        lib = 'dsplibv4';
        
    otherwise
        warning(message('dsp:showsignalblockdatatypetable:BCSTUnknownAct', Action));
end

