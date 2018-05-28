function [wv,recside,isflipped] = mapchannel2side(ds,wv)

% MAPCHANNEL2SIDE  Map stimulus channels to left and right using dataset parameters
%   MWV = MAPCHANNEL2SIDE(DS,WV) using the paramters in dataset DS map
%   channels 1 and 2 (colums 1 and 2) in WV to left  and right (columns 1 and 2)
%   ear in MWV. If mapping cannot be determined MWV is empty.
%
%   [MWV,RECSIDE] = MAPCHANNEL2SIDE(DS,WV) if possible RECSIDE gives the
%   recording side. If recording side cannot be determined RECSIDE is empty.
%
%   [MWV,RECSIDE,ISFLIPPED] = MAPCHANNEL2SIDE(DS,WV) ISLFIPPED returns 1 if
%   the columns of WV have been flipped and 0 if WV has not been flipped.


% MMCL 21/08/2009

%------------------------------------ Main --------------------------------

%Sort sides ...
if isa(ds, 'EDFdataset') 
    % ... for Madison data
    [wv,isflipped] = SortSidesEDF(ds, wv); 
    recside = [];
else
    % ... for Leuven data
    [wv,recside,isflipped] = SortSidesSGSR(ds, wv); 
end

%------------------------------------ Locals ------------------------------
function [wv,isflipped] = SortSidesEDF(ds, wv); 

% keep track of flipping
isflipped = 0;

%-- ds.DDS.nr - maps channel (column) to master or slave --
if ds.DSS(1).Nr == 2 
    % master is channel 2 - switch
    disp('master is channel 2 - switch')
    wv(:,:) = wv(:,[2 1]);
    isflipped = 1;
else
    % master is channel 1 - do nothing
end
% Now master is definitely channel 1 and slave channel 2

%--Use calibration data to map master/slave to left/right--
D = log2lut(ds.id.FileName);

% parse D and look for calibration data. Looks something like - 're-ds1-f1'
% and 'le-ds2-f2'
LR = [];
for n = 1:length(D)
    Ltemp = regexpi(D(n).IDstr ,'le.ds..f.');
    Rtemp = regexpi(D(n).IDstr ,'re.ds..f.');
    if Ltemp == 1
        L1 = regexpi(D(n).IDstr ,'1');
        L2 = regexpi(D(n).IDstr ,'2');
        if ~isempty(L1)
            LR(1) = 1;
        elseif ~isempty(L2)
            LR(1) = 2;
        end
    end
    if Rtemp == 1
        R1 = regexpi(D(n).IDstr ,'1');
        R2 = regexpi(D(n).IDstr ,'2');
        if ~isempty(R1)
            LR(2) = 1;
        elseif ~isempty(R2)
            LR(2) = 2;
        end
    end
end

if LR(1) == 1
    % left is channel 2 - switch
    disp('left is channel 2 - switch')
    wv(:,:) = wv(:,[2 1]);
    % keep track of flipping
    if isflipped == 0
        isflipped = 1;
    else
        isflipped = 0;
    end
elseif LR(1) == 2
    % left is channel 1 - do nothing
else
    % could not determine ear mapping from calibration data
    disp('Could not determine ear mapping from calibration data');
    wv = [];
end
% Now left ear is definitely channel 1 and right channel 2

%--------------------------------------------------------------------------
function [wv,recside,isflipped] = SortSidesSGSR(ds, wv); 

% keep track of flipping
isflipped = 0;

if isempty(ds.Settings.SessionInfo)
    % Parse look up table and get ds which contains SessionInfo (recside and channel mapping)
    D = log2lut(ds.id.FileName);
    for n = 1:length(D)
        temp = regexpi(D(n).IDstr ,'NRHO|ARMIN');
        if ~isempty(temp)
            ds = dataset(ds.id.FileName,D(n).IDstr);
            break
        end
    end
end

if ~isempty(ds.Settings.SessionInfo)
    if isfield(ds.Settings.SessionInfo,'leftDACear')
    if strcmpi(ds.Settings.SessionInfo.leftDACear, 'R')
        % left is channel 2 - switch
        wv(:,:) = wv(:,[2 1]);
        
        % keep track of flipping
        isflipped = 1;
    else
        % left is channel 1 - do nothing
    end
    % Now left ear is definitely channel 1 and right channel 2
    
    recside = ds.Settings.SessionInfo.RecordingSide;
    else
        % No ds with ear mapping or rec side found
        disp('No dataset with ear mapping or recording side could be found');
        wv = [];
        recside = [];
    end
else
    % No ds with ear mapping or rec side found
    disp('No dataset with ear mapping or recording side could be found');
    wv = [];
    recside = [];
end