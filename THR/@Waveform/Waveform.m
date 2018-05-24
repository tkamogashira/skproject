function S=Waveform(Fsam, DAchan, MaxMagSam, SPL, Param, Samples, Nrep);
% Waveform - construct waveform object
%    Waveform(Fsam, DAchan, MaxMagSam, SPL, Param, Samples, Nrep) returns a
%    Waveform object W. Inputs are
%        Fsam: sample frequency in Hz
%      DAchan: DAC channel 'L' or 'R'
%   MaxMagSam: maximum magnitude of the samples
%         SPL: intensity in dB SPL when played
%       Param: struct containing stimulus parameters. Fields may vary.
%     Samples: cell array whose element are column vectors of samples
%        Nrep: rep array. Nrep(k) is the # reps for Samples{k}.
%
%  Empty elements of Samples wil be removed, as will elements wit Nrep==0.
%  Single-sample elements of Samples will be merged with other, or
%  expanded. The total number of samples is a waveform must be at least 2.
%  When specifying NaN for MaxMagSam, Waveform will evaluate the maximum
%  sample magnitude automatically.

persistent INITIALIZED
if isempty(INITIALIZED), % create void object to initialize the class
    INITIALIZED = 1;
    qq=feval(mfilename);
end

% special cases: struct input or object input
if nargin==1 && isstruct(Fsam), % convert the struct by feeding fields to the constructor; ...
    if numel(Fsam)>1,  %... this way invalid fields will be intercepted.
        for ii=1:numel(Fsam),
            S(ii) = Waveform(Fsam(ii));
        end
        S = reshape(S, size(Fsam));
    else, % single element struct; pass its fields
        args = struct2cell(Fsam);
        S = Waveform(args{1:7});
    end
    S = setMaxMagSample(S);
    return;
elseif nargin==1 && isa(Fsam, mfilename), % tautological call: Waveform object as sole input arg
    S = Fsam;
    return;
elseif nargin<1, % void object with correct fields
    [Fsam, DAchan, MaxMagSam, SPL, Param, Samples, Nrep, Nwav, NsamStore, NsamPlay, UniqueID] = deal([]);
    S = collectInStruct(Fsam, DAchan, MaxMagSam, SPL, Param, Samples, Nrep, Nwav, NsamStore, NsamPlay, UniqueID);
    S = class(S, mfilename);
    return;
end

% ==========regular case============
if ~isscalar(Fsam) || ~isnumeric(Fsam),
    error('Fsam must be single scalar.');
end
if ~isequal('L', DAchan) && ~isequal('R', DAchan),
    error('DAchan must be character L or R');
end
if ~isscalar(MaxMagSam) || ~isnumeric(MaxMagSam),
    error('MaxMagSam must be single scalar.');
end
if ~isscalar(SPL) || ~isnumeric(SPL),
    error('SPL must be single scalar.');
end
if ~isstruct(Param)
    error('Param must be struct.');
end
if isempty(Samples) || ~iscell(Samples) || ~all(cellfun(@isnumeric, Samples)),
    error('Waveform must be nonempty cell array of numeric arrays.');
end
if ~isnumeric(Nrep)
    error('Nrep must be numerical array.');
end
if ~isequal(size(Samples),size(Nrep)),
    error('Waveform and Nrep must have equal sizes.');
end

[Samples, Nrep] = local_contractAdjacentSingleReppers(Samples, Nrep);
[Samples, Nrep] = local_contractSmallstuff(Samples, Nrep);
Nwav = numel(Samples);
NsamStore = sum(cellfun(@numel, Samples)); % total # samples stored
NsamPlay = sum(Nrep.*cellfun(@numel, Samples)); % total # samples played (including reps)
setRandState; % ensure "true" randomness
UniqueID = randomint(1e7);

S = collectInStruct(Fsam, DAchan, MaxMagSam, SPL, Param, Samples, Nrep, Nwav, NsamStore, NsamPlay, UniqueID);
S = class(S, mfilename);
S = setMaxMagSample(S);

%================================
function [Samples, Nrep] = local_contractAdjacentSingleReppers(Samples, Nrep);
[Samples, Nrep] = local_rmEmpty(Samples, Nrep);
for ii=2:numel(Nrep),
    if all(Nrep([ii-1 ii])==1),
        Samples{ii} = vertcat(Samples{ii-1:ii});
        Samples{ii-1} = {};
    end
end
[Samples, Nrep] = local_rmEmpty(Samples, Nrep);

function [Samples, Nrep] = local_contractSmallstuff(Samples, Nrep);
% Samples, Nrep, disp('------rm empty')
% remove empty entries
[Samples, Nrep] = local_rmEmpty(Samples, Nrep);
% Samples, Nrep, disp('------expand small repeated singles')
% make sure every buffer has at least 2 samples
Nsam = cellfun(@numel, Samples);
% single sample buffers having multiple reps but not too many: expand
iexpand = find((Nsam==1) & (Nrep>1) & (Nrep<=5000));
for ii=iexpand(:).',
    Samples{ii} = repmat(Samples{ii}, Nrep(ii), 1);
    Nrep(ii) = 1;
end
% Samples, Nrep, disp('------expand large repeated singles')
% single-sample buffers with many, many reps
Nsam = cellfun(@numel, Samples);
isort = [];
Nwav = numel(Samples);
for ii=1:Nwav,
    isort(end+1) = ii; % store index of current buffer, it will certainly survive
    if (Nsam(ii)==1) & (Nrep(ii)>5000),
        samval = Samples{ii}; % just one sample
        N = floor(Nrep(ii)/1000);
        M = rem(Nrep(ii),1000);
        % replace single-sample buffer by N-time-repeated 1000-sample buf
        Samples{ii} = repmat(samval, 1000, 1);     Nrep(ii) = N;
        if M>0,% append tail buffer to Samples & Nrep. Will inserted in the end
            Samples{end+1} = repmat(samval, M, 1);  Nrep(end+1) = 1;
            isort(end+1) = numel(Samples); % also store index of tail buffer
        end
    end
end
% Sort the pieces, inserting the new ones
%
% Final case: single-sample buffers with only one rep. They must be
% combined with neighbors
Samples = Samples(isort); Nrep = Nrep(isort);
% Samples, Nrep, disp('------merge single singles ')
Nsam = cellfun(@numel, Samples);
Nwav = numel(Samples);
irm = [];
for ii=1:Nwav,
    if (numel(Samples{ii})==1) && (Nrep(ii)==1),
        samval = Samples{ii}; % just one sample
        if ii<Nwav, % merge with next one
            if Nrep(ii+1)==1,
                Samples{ii+1} = [samval; Samples{ii+1}];
                irm(end+1) = ii;
            else, % merge with first rep of next one
                Samples{ii} = [samval; Samples{ii+1}]; Nrep(ii) = 1;
                Nrep(ii+1) = Nrep(ii+1)-1; 
            end
        elseif Nwav==1, % cannot be fixed
            error('Waveform has too few (<2) samples.');
        else, % last one: merge with previous one
            if Nrep(ii-1)==1,
                Samples{ii-1} = [Samples{ii-1}; samval];
                irm(end+1) = ii;
            else, % merge with last rep of previous one
                Samples{ii} = [Samples{ii-1}; samval];  Nrep(ii) = 1;
                Nrep(ii-1) = Nrep(ii-1)-1; 
            end
        end
    end
end
% Samples, Nrep, disp('-----removing')
Samples(irm) = []; Nrep(irm) = [];
%Samples, Nrep


function [Samples, Nrep] = local_rmEmpty(Samples, Nrep);
% remove empty entries
Nsam = cellfun(@numel, Samples); 
irm = find((Nsam==0) | (Nrep==0));
Samples(irm) = []; Nrep(irm) = [];


