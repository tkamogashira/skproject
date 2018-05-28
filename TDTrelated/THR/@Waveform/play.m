function play(dum, P, Postfix, figh); %#ok<INUSL>
% Waveform/play - play waveform object
%   play(Dum, P) plays P.Waveform using SeqPlay. Dum is just a void
%   waveform object allowing Play to be a Waveform method. P is the
%   struct created by stimulus generators like makestimFS. P must contain
%   the fields
%         Waveform: Ncond x Nchan  waveform object
%       Experiment: Experiment object containing generic stimulus settings
%      Attenuation: instructions for attenuator settings
%     Presentation: struct containing  info on presentation order, etc.
%
%   See makestimFS, toneStim, Experiment, sortConditions.

if nargin<3, Postfix = ''; end
if nargin<4, figh = []; end

if isempty(P.Waveform), return; end

% set attenuators to max
SetAttenuators(P.Experiment,'max');

% Initialize RPvdS circuit
Dev = P.Experiment.Hardware.DAC;
[CI, Recycled]=seqplayinit(P.Waveform(1).Fsam/1e3, Dev, Postfix, 1); % 1 means recycle circuit if possible

% Expand the play list: W has multiple conditions, each containing multiple
% segments. SeqplayList does not care, it only needs to know the segment
% indices and Nreps in the grand pool of waveform segments.
[iWav, Nrep, ConditionIndex]=local_expand_Playlist(P.Presentation, P.Waveform);

% upload waveforms
[Ncond, Nchan] = size(P.Waveform);
Scale = P.Attenuation.NumScale; % scale factors per element of W
Scale = local_expand_scaleFactors(Scale, P.Waveform); % now per segment making up the elements of W
if Nchan==1,
    switch P.Waveform(1).DAchan,
        case 'L',
            seqplayupload([P.Waveform(:,1).Samples], {}, Scale{1});
            seqplaylist(iWav{1}, Nrep{1});
        case 'R',
            seqplayupload({}, [P.Waveform(:,1).Samples], 1, Scale{1});
            seqplaylist([],[], iWav{1}, Nrep{1});
    end
else, % dual channel play
    seqplayupload([P.Waveform(:,1).Samples], [P.Waveform(:,2).Samples], Scale{:});
    seqplaylist(iWav{1}, Nrep{1}, iWav{2}, Nrep{2});
end
% set attenuators & GO
SetAttenuators(P.Experiment, P.Attenuation.AnaAtten);
seqplayGo;

%============================================================
%============================================================
function [iWav, Nrep, iCond, nsam]=local_expand_Playlist(Pres, W);
for ichan = 1:size(W,2),
    iwaveOffset = cumsum([0 W(1:end-1,ichan).Nwav]); % offsets per condition in the order of storage in W (and as uploaded)
    iwaveOffset = iwaveOffset(Pres.iCond); % ditto, but now in the order of presentation
    %disp('========')
    Nwav = [W(Pres.iCond,ichan).Nwav]; % wave counts of each presentation
    iw = arrayfun(@(v,n)(v+(1:n)), iwaveOffset(:), Nwav(:), 'UniformOutput', false);
    ic = arrayfun(@(c,n)(c*ones(1,n)), Pres.iCond(:), Nwav(:), 'UniformOutput', false);
    iWav{ichan} = [iw{:}]; 
    iCond{ichan} = [ic{:}];
    Nrep{ichan} = [W(Pres.iCond,ichan).Nrep];
end

function S = local_expand_scaleFactors(Scale, W);
for ichan = 1:size(W,2),
    Nwav = [W(:,ichan).Nwav]; % wave counts of each condition
    qq = arrayfun(@(c,n)(c*ones(1,n)), Scale(:,ichan).', Nwav, 'UniformOutput', false); 
    S{ichan} = [qq{:}];
end


