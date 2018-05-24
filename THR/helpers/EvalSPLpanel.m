function okay=EvalSPLpanel(figh, P, MaxSPL, MaxSPLfreq, Prefix, Xquerynames)
% EvalSPLpanel - evaluate SPL parameters from stimulus GUI
%   okay=EvalSPLpanel(figh, P, MaxSPL, MaxSPLfreq, Prefix, SPLquerynames) 
%   evaluates the SPL parameters obtained from the paramqueries created by
%   SPLpanel and reports the Maximum SPL using the MaxSPL messenger. The
%   output argument okay is true unless SPL is out of range. Input
%   arguments are  
%      figh: handle to GUI, or Experiment definition for non-interactive calls.
%         P: struct returned by GUIval(figh) containing GUI parameters 
%    MaxSPL: maximum SPL that can be realized. This is computed by the 
%            calling function makeStimXX using the other stimulus parameters.
%            MaxSPL is reported to the user through the MaxSPL messenger.
%            EvalSPLpanel will report an error when SPL exceeds MaxSPL.
%            Pairs of numbers mean [Left Right]. Only the active DACs are
%            considered when checking the SPL.
%   MaxSPLfreq: for tonal stimuli, the respective frequencies that limit
%            the maximum SPL. This is displayed by the MaxSPL messenger. If
%            MaxSPLfreq is [], e.g., the second half of the MaxSPL 
%            messenger text ("@ [..] Hz") is not displayed. If MaxSPLfreq
%            is a char string, this second half is replaced by this string.
%            This can be used if frequency is not the varied parameter.
%    Prefix: prefix of SPL query names (see SPLpanel). Defaults to ''.
%   Xquerynames: cellstring containing names of any additional queries to
%           highlight in case of exceeding the maximum realizable SPL.
%           Defaults to {};
%
%   EvalSPLpanel is a helper function for stimulus generators like 
%   makestimFS.
%   
%   See StimGUI, SPLpanel, makestimFS.

[MaxSPLfreq, Prefix, Xquerynames] = arginDefaults('MaxSPLfreq, Prefix, Xquerynames', [],'', {});
okay = 0; % pessimistic default

if isa(figh, 'experiment'), % non-interactive call - no GUI
    EXP = figh; 
    Interactive=false;
else,
    EXP = getGUIdata(figh,'Experiment');
    Interactive=true;
end
% get SPL from P
P = dePrefix(P, Prefix);

% if max-SPL values of all conditions are passed, select the most critical
% one(s) per channel
if size(MaxSPL,1)>1,
    [MaxSPL, Icrit] = min(MaxSPL);
    if isnumeric(MaxSPLfreq) && ~isempty(MaxSPLfreq),
        MaxSPLfreq = [MaxSPLfreq(Icrit(1),1) MaxSPLfreq(Icrit(end),end)];
        MaxSPLfreq = uniquify(MaxSPLfreq);
    end
end

% report max SPL
if Interactive, 
    MaxSPL = uniquify(0.1*round(10*MaxSPL));
    Mess = ['Max ' vector2str(MaxSPL) ' dB SPL '];
    if isempty(MaxSPLfreq), % do nothing
    elseif isnumeric(MaxSPLfreq), % add freq info
        % get rid of insignificant digits
        MaxSPLfreq = uniquify(0.1*round(10*MaxSPLfreq)); 
        if any(MaxSPLfreq>=1e3), MaxSPLfreq=round(uniquify(MaxSPLfreq)); end
        Mess = [Mess '@ ' vector2str(MaxSPLfreq) ' Hz'];
    elseif ischar(MaxSPLfreq), % add info as is
        Mess = [Mess '@ ' MaxSPLfreq];
    else,
        error('MaxSPLfreq input arg must be numerical or string.');
    end
    % find MaxSPL messenger in GUI and let it speak out
    MM = GUImessenger(figh,[Prefix 'MaxSPL']);
    report(MM,Mess);
end

% check if SPL is is within range 
MaxSPL = sameSize(MaxSPL, P.SPL);
if any(P.SPL>MaxSPL),
    if Interactive, % report error and highlight SPL edit control
        GUImessage(figh,'SPL exceeds maximum attainable.', 'error', {[Prefix 'SPL'] Xquerynames{:}});
    end
    return;
end

okay=1;



