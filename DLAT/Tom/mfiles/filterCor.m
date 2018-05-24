function ArgOut = filterCor(varargin)
% filterCor.
% model tool to study the influence of phase differences on correlation
%
% output argument is a struct array with fields 'freq', 'ampl', 'phase1', 'phase2',
% each row stands for a frequency component of stimulus 1 and stimulus 2
%
% stimulus 1 and 2's frequency domains can have different slopes or different cf's, but the same frequency components, cf-amplitude etc
%
% Example: filtercor('cf', 3000, 'ampcf', 10, 'leftslope', 10, 'rightslope', 5, ...
% 'nroffreqs', 9, 'phasediffdc', pi/2, 'phasediffslope', pi/8, 'maxlag',1);
% 
% Example with manual frequency-entry (variables freqsleft,freqsright,phases are saved in the files freqsused.m and phasesused.m)
% filtercor('cf1', 660, 'cf2', 20, 'ampcf', 19.3, 'leftslope1', 31.09,'nroffreqs',3, ...
% 'rightslope1', 53.73,'rightslope2', 60,'leftslope2', 50,'phasediffdc', pi/2, ...
% 'phasediffslope',2*pi*0.02, 'maxtime', 1, 'randfreq', 'no', 'randphase','no','freqsleft',round(freqsleft),...
% 'freqsright',round(freqsright),'phases',phases)
%
% see code for units properties are expressed in
%
% use 'factory' as only input argument to see the properties and their default values
% 
%
% TF 15/09/2005

%PROPERTIES: default values-----------------------------------------------------------------------------------------------------------
DefProps.cf1              = 1000;    %frequency component of stimulus 1 with the largest magnitude
DefProps.cf2              = 0;    %frequency component of stimulus 2 with the largest magnitude, 
% specified as a positive integer, i.e. the how maniest frequency component after cf1 is taken!
DefProps.ampcf           = 20;       %magnitude of this frequency component in dB
DefProps.leftslope1       = 0;       %slope of frequency-magnitude-curve for stimulus 1 for frequencies lower than cf1 (in dB/octave)
DefProps.rightslope1      = 0;       %slope of frequency-magnitude-curve for stimulus 1 for frequencies higher than cf1 (in dB/octave)
DefProps.leftslope2       = 0;       %slope of frequency-magnitude-curve for stimulus 2 for frequencies lower than cf1 (in dB/octave)
DefProps.rightslope2      = 0;       %slope of frequency-magnitude-curve for stimulus 2 for frequencies higher than cf1 (in dB/octave)
DefProps.nroffreqs       = 1;        %number of frequency components used (an odd integer)
DefProps.randfreq        = 'yes';    %whether or not frequencies should be chosen randomly (in an interval defined by DefProps.cf1,
% DefProps.ampcf, DefProps.beginratio, DefProps.endratio, DefProps.leftslope1, DefProps.rightslope1)
DefProps.phasediffdc     = [];        %phase difference of DC-component (stimulus 2 with respect to stimulus 1)
DefProps.phasediffslope  = 0;        %slope of phase-frequency-curve (in radians/Hz, is equal to timedelay(in s)x 2pi radians)
DefProps.randphase       = 'yes';    %whether or not each frequency component of stimulus 1 gets a random phase
DefProps.beginratio      = 0.1;      %this is the percentage of the amplitude of the lowest frequency component used with respect to the cf1's amplitude
DefProps.endratio        = 0.1;      %this is the percentage of the amplitude of the highest frequency component used with respect to the cf1's amplitude
DefProps.maxtime         = 1;      %defines the end of the time-interval (in seconds), sinusoids are computed from time 0s to time 'maxtime' s)
DefProps.nsamples        = 10000;    %number of samples in this time-interval
DefProps.maxlag          = 1;        %maxlag for crosscorrelation (in seconds);
DefProps.freqsleft       = [];       %a column vector of frequency components below cf1 that are to be used
DefProps.freqsright      = [];       %a column vector of frequency components above cf1 that are to be used
DefProps.phases          = [];       %if phase is not added randomly to stimulus1-components, this column vector specifies which phases are added to the components
DefProps.displaysins     = 'no';     %if yes, a figure is plotted with the sinusoid-components of stimulus 1 and stimulus 2
DefProps.stimshownp      = 10;       %this scalar determines how many periods of cf1 are displayed in the stimulus-time domain-plots
DefProps.corrshownp      = 40;        %this even scalar determines how many periods of cf1 are displayed in the correlogram
DefProps.delay           = [];       %instead of a phase difference between stimulus 2 and stimulus 1, 
% this property can be used to specify a time delay of 2 vs. 1 (in seconds)

%Evaluate input arguments------------------------------------------------------------------------------------------------------------
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); 
    disp(DefProps);
    return;
else, Props = ParseArgs(DefProps, varargin{:}); end


%CALCULATIONS------------------------------------------------------------------------------------------------------------------------
% generate frequencies
if Props.nroffreqs ~=1,
    if isequal(Props.randfreq, 'yes'),
        beginfreq = 2^(log2(Props.cf1) - (1-Props.beginratio)*(Props.ampcf/Props.leftslope1)); % the frequency of the lowest sinusoid (stim 1)
        endfreq = 2^(log2(Props.cf1) + (1-Props.endratio)*(Props.ampcf/Props.rightslope1)); % the frequency of the highest sinusoid
        % generate random frequencies in between (random numbers between 0 and 1 and rescale to frequency interval)
        freqsleft = rand((Props.nroffreqs-3)/2,1);
        freqsleft = freqsleft*(log2(Props.cf1)-log2(beginfreq)) + log2(beginfreq);
        freqsleft = sort(2.^freqsleft);
        freqsleft = [beginfreq; freqsleft];
        freqsright = rand((Props.nroffreqs-3)/2,1);
        freqsright = freqsright*(log2(endfreq)-log2(Props.cf1)) + log2(Props.cf1);
        freqsright = sort(2.^freqsright);
        freqsright = [freqsright; endfreq];
    freqs = [freqsleft;Props.cf1;freqsright];
    else,
        freqsleft = Props.freqsleft;
        freqsright = Props.freqsright;
    freqs = [freqsleft;Props.cf1;freqsright];
    Props.nroffreqs = numel(freqs);
    end
    
% compute magnitudes
    beginmagn = Props.beginratio*Props.ampcf;
    endmagn = Props.endratio*Props.ampcf;
    magnsleft = Props.ampcf - Props.leftslope1*(log2(Props.cf1)-log2(freqsleft));
    magnsright = Props.ampcf - Props.rightslope1*(log2(freqsright)-log2(Props.cf1));
magns1 = [magnsleft;Props.ampcf;magnsright];
    if Props.cf2~=0, %if there are different cf's for stimulus 1 and 2, slopes are adjusted so that each stimulus has the same frequency components
        Props.cf2 = freqs(find(freqs==Props.cf1)+Props.cf2);
        Props.leftslope2 = (Props.ampcf - magns1(1))/(log2(Props.cf2)-log2(freqs(1))); 
        Props.rightslope2 = abs((Props.ampcf - magns1(numel(magns1)))/(log2(Props.cf2)-log2(freqs(numel(freqs)))));
    else,
        Props.cf2 = Props.cf1;
    end
    magnsleft = Props.ampcf - Props.leftslope2*(log2(Props.cf2)-log2(freqs(find(freqs<Props.cf2))));
    magnsright = Props.ampcf - Props.rightslope2*(log2(freqs(find(freqs>Props.cf2)))-log2(Props.cf2));
magns2 = [magnsleft;Props.ampcf;magnsright];

else,
    freqs = Props.cf1;
    magns1 = Props.ampcf;
    magns2 = Props.ampcf;
end

% generate phases 
if isequal(Props.randphase,'yes'),    
    phases1 = rand(Props.nroffreqs,1);
    phases1 = phases1*(2*pi);
else
    phases1 = Props.phases;
end
% generate phasedifferences (stimulus 2 with respect to stimulus 1)
if ~isempty(Props.phasediffdc),    
    phases2 = phases1 + (Props.phasediffdc + freqs*Props.phasediffslope);
elseif ~isempty(Props.delay)
      phases2 = phases1 + 2*pi*freqs*Props.delay;
end

phasediffs = phases2 - phases1;

% compute values of sinusoids in time-domain
stepsize = Props.maxtime/(Props.nsamples-1);
times = [0:stepsize:Props.maxtime];
sins1 = zeros(Props.nroffreqs,Props.nsamples);
for i=1:Props.nroffreqs
    sins1(i,:) = magns1(i)*cos((2*pi*freqs(i)*times) + phases1(i));
end
sins2 = zeros(Props.nroffreqs,Props.nsamples);
for i=1:Props.nroffreqs
    sins2(i,:) = magns2(i)*cos((2*pi*freqs(i)*times) + phases2(i));
end

% build struct arrays for stimulus 1 and stimulus 2, each row corresponds with a sinusoid, fields are 'freq', 'ampl', 'phase', 'times', 'yvals'
S1 = struct('freq', num2cell(freqs,2), 'amplit1', num2cell(magns1,2), 'phase', num2cell(phases1,2), 'times', num2cell(times,2), 'yvals', num2cell(sins1,2));
S2 = struct('freq', num2cell(freqs,2), 'amplit2', num2cell(magns2,2), 'phase', num2cell(phases2,2), 'times', num2cell(times,2), 'yvals', num2cell(sins2,2));
%sum sinusoids and add result to struct arrays
if numel(S1)~=1, s1sum = sum(structfield(S1,'yvals')); else, s1sum = structfield(S1,'yvals'); end
if numel(S2)~=1, s2sum = sum(structfield(S2,'yvals')); else, s2sum = structfield(S2,'yvals'); end
S1(numel(S1)+1) = struct('freq', NaN, 'amplit1', NaN, 'phase', NaN,'times', num2cell(times,2), 'yvals', num2cell(s1sum,2));
S2(numel(S2)+1) = struct('freq', NaN, 'amplit2', NaN, 'phase', NaN,'times', num2cell(times,2), 'yvals', num2cell(s2sum,2));

% compute correlation
[corryvals,lags] = xcorr(S1(numel(S1)).yvals,S2(numel(S2)).yvals,round(Props.maxlag/stepsize));
lags = lags * stepsize; %rescale lags

ArgOut = struct('freq', num2cell(structfield(S1(1:(numel(S1)-1)), 'freq')), 'amplit1', num2cell(structfield(S1(1:(numel(S1)-1)), 'amplit1')),'amplit2', num2cell(structfield(S2(1:(numel(S2)-1)), 'amplit2')), 'phase1', num2cell(structfield(S1(1:(numel(S1)-1)), 'phase')), ... 
   'phase2', num2cell(structfield(S2(1:(numel(S2)-1)), 'phase')));

%PLOTS------------------------------------------------------------------------------------------------------------------
fig=figure('Name','FilterCor: changes in correlation related to phase differences',...
'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0 0.025 1 0.975]);

corrax = subplot(3,2,[5 6]);
stim1ax = subplot(3,2,3); stim2ax = subplot(3,2,4);
ampax = subplot(3,2,1); phasediffax = subplot(3,2,2);

% show frequency-magnitude-plot
axes(ampax);
stim1=stem(freqs,magns1);
set(stim1,'color','b');
hold on;
stim2=stem(freqs,magns2);
set(stim2,'color','r','marker','*');
if (numel(freqs)>1), set(ampax, 'XScale','log','xlim',[freqs(1) freqs(numel(freqs))]);
elseif (numel(freqs)==1), set(ampax, 'XScale', 'log');
end
l=line([freqs(1) Props.cf1], [(Props.ampcf - Props.leftslope1*(log2(Props.cf1) - log2(freqs(1)))) Props.ampcf]);
set(l,'LineStyle','--','Color',[0 0 0]);
l=line([Props.cf1 freqs(numel(freqs))], [Props.ampcf (Props.ampcf - Props.rightslope1*(log2(freqs(numel(freqs)))-log2(Props.cf1)))]);
set(l,'LineStyle','--','Color',[0 0 0]);
l=line([freqs(1) Props.cf2], [(Props.ampcf - Props.leftslope2*(log2(Props.cf2) - log2(freqs(1)))) Props.ampcf]);
set(l,'LineStyle','--','Color',[0 0 0]);
l=line([Props.cf2 freqs(numel(freqs))], [Props.ampcf (Props.ampcf - Props.rightslope2*(log2(freqs(numel(freqs)))-log2(Props.cf2)))]);
set(l,'LineStyle','--','Color',[0 0 0]);
xlabel('Freq (Hz)'); ylabel('Magnitude (dB)');
t=title(sprintf('Frequency domain: magnitudes\no: stimulus 1\n*: stimulus 2'));
set(t,'FontWeight','bold');
hold off;


% show frequency-phase difference-plot
axes(phasediffax);
l=line(freqs,phasediffs);
set(l,'Marker','o','MarkerEdgeColor','b','Color',[0 0 0], 'LineStyle', '--');
p = polyfit(freqs,phasediffs,1);
l = line(0,p(2));
set(l,'Marker','*','Color','r');
try, set(phasediffax, 'xlim',[0 freqs(numel(freqs))], 'ylim', [0 phasediffs(numel(phasediffs))]); end %try necesseray to handle a situation with zero phasedifference slope
xlabel('Freq (Hz)'); ylabel('Phase difference(radians)');
% try-catch used to handle situations with only one frequency component
try, slope = (phasediffs(numel(phasediffs)) - phasediffs(1))/(freqs(numel(freqs)) - freqs(1));
catch, slope = NaN;
end
t=title(sprintf(['Frequency domain: phase difference (stimulus 2 - stimulus 1)\nSlope: ' num2str((slope/(2*pi)*1000),'%1.2d') ' ms x 2 pi radians']));
set(t,'FontWeight','bold');


% add plots of left and right filtered stimulus (time-domain)
    %Stimulus 1
    axes(stim1ax);
    set(stim1ax, 'XLim', [0 Props.stimshownp/Props.cf1]);
    line(S1(numel(S1)).times,S1(numel(S1)).yvals);
    xlabel('Time (s)'); ylabel('Amplitude');
    %Calculate sizes of current axis ...
    XRng = XLim(gca); YRng = YLim(gca);
    Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
    %Find coordinates of higher left corner ...
    [Xhlc, Yhlc] = deal(XRng(1) + 0.04*Xsize, YRng(2) - 0.04*Ysize);
    t=text(Xhlc,Yhlc,'Stimulus 1: time domain');
    set(t,'FontWeight','bold');
    
    %Stimulus 2
    axes(stim2ax);
    set(stim2ax, 'XLim', [0 Props.stimshownp/Props.cf1]);
    line(S2(numel(S2)).times,S2(numel(S2)).yvals);
    xlabel('Time (s)'); ylabel('Amplitude');
    %Calculate sizes of current axis ...
    XRng = XLim(gca); YRng = YLim(gca);
    Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
    %Find coordinates of higher left corner ...
    [Xhlc, Yhlc] = deal(XRng(1) + 0.04*Xsize, YRng(2) - 0.04*Ysize);
    t=text(Xhlc,Yhlc,'Stimulus 2: time domain');
    set(t,'FontWeight','bold');

% add correlogram
axes(corrax);
set(corrax, 'XLim', [(-0.5)*(Props.corrshownp/Props.cf1) 0.5*(Props.corrshownp/Props.cf1)]);
line(lags,corryvals);
xlabel('Delay (s)');
ylabel('Number of correlations');
    %Calculate sizes of current axis ...
    XRng = XLim(gca); YRng = YLim(gca);
    Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
    %Find coordinates of higher left corner ...
    [Xhlc, Yhlc] = deal(XRng(1) + 0.02*Xsize, YRng(2) - 0.04*Ysize);
    %Find coordinates of lower right corner ...
    [Xlrc, Ylrc] = deal(XRng(2) - 0.25*Xsize, YRng(1) + 0.05*Ysize);
t=text(Xhlc,Yhlc,'Crosscorrelation of stimulus 1 with stimulus 2');
set(t,'FontWeight','bold');
t=text(Xlrc,Ylrc,['Delay at max: ' num2str(lags(find(corryvals == max(corryvals)))*1000) ' ms']);
set(t,'FontWeight','normal');

% make figure with sinusoid components of stimulus 1 and stimulus 2 if requested
if isequal(Props.displaysins,'yes'),
    figsins = figure;
    axes1 = subplot(2,1,1);
    set(axes1, 'XLim', [0 Props.stimshownp/Props.cf1]);
    axes2 = subplot(2,1,2);
    set(axes2, 'XLim', [0 Props.stimshownp/Props.cf1]);
    
    axes(axes1);
    hold on;
    
    %choose colors for the different components so that they can be maximally discerned
    colorarray=colormap;
    carows=size(colorarray,1);
    colors = [];
    if carows>(numel(S1)-1), 
        colorsidx = floor(carows/(numel(S1)-1));
        for i=1:colorsidx:carows
            colors = [colors;colorarray(i,:)];
            if size(colors, 1) >= (numel(S1)-1), break; end
        end        
    else, colors = colorarray;
    end
    
    for i=1:(numel(S1)-1) %the last row in S1 is the sum of the sinusoids
        l=line(S1(i).times, S1(i).yvals);
        set(l,'Color',colors(mod(i,numel(colorarray)),:));
    end
    xlabel('Time (s)'); ylabel('Amplitude');
    t=title('Frequency components of stimulus 1');
    set(t,'FontWeight','bold');
    
    aliasborder = 1/(2*stepsize);
    
    %Calculate sizes of current axis ...
    XRng = XLim(gca); YRng = YLim(gca);
    Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
    %Find coordinates of a point above the higher left corner ...
    [Xhlc, Yhlc] = deal(XRng(1) + 0.02*Xsize, YRng(2) + 0.04*Ysize);
    
    text(Xhlc, Yhlc,['Watch out: aliasing starting at: ' num2str(aliasborder) ' Hz']);
    
    hold off;
    
    axes(axes2);
    hold on;
    for i=1:(numel(S2)-1) %the last row in S1 is the sum of the sinusoids
        l=line(S2(i).times, S2(i).yvals);
        set(l,'Color',colors(mod(i,numel(colorarray)),:));
    end
    xlabel('Time (s)'); ylabel('Amplitude');
    t=title('Frequency components of stimulus 2');
    set(t,'FontWeight','bold');
    hold off;
end

%LOCAL FUNCTIONS---------------------------------------------------------------------------------------------------------
function Props = ParseArgs(DefProps, varargin)

%Check properties ...
Props = CheckPropList(DefProps, varargin{:});
Props = CheckProps(Props);
%------------------------------------------------------------------------------------------------------------------------
function Props = CheckProps(Props)

%Frequency component selection properties ...
if ~isnumeric(Props.cf1) | (Props.cf1<0) | isempty(Props.cf1), 
    error('Property ''cf1'' must be a positive scalar'); 
end
if ~isnumeric(Props.ampcf) | isempty(Props.ampcf) | ...
        (Props.ampcf < 0), 
    error('Property ''ampcf'' must be a positive scalar'); 
end
if ~isnumeric(Props.leftslope1) | isempty(Props.leftslope1) | ...
        (Props.leftslope1 < 0), 
    error('Property ''leftslope1'' must be a positive scalar'); 
end
if ~isnumeric(Props.rightslope1) | isempty(Props.rightslope1) | ...
        (Props.rightslope1 < 0), 
    error('Property ''rightslope1'' must be a positive scalar'); 
end
if ~strcmpi(Props.randfreq, 'yes') & ~strcmpi(Props.randfreq, 'no'), 
    error('Property ''randfreq'' must be ''yes'' or ''no'''); 
end
if ~isnumeric(Props.freqsleft) | ~isnumeric(Props.freqsright), 
    error('Properties ''freqsleft'' and ''freqsright'' must be numeric column vectors'); 
end
if numel(Props.freqsleft)~=numel(Props.freqsright), 
    error('Properties ''freqsleft'' and ''freqsright'' must be column vectors of the same size'); 
end
if strcmpi(Props.randfreq, 'no')&((isempty(Props.freqsright) | isempty(Props.freqsleft))), 
    error(['If you want non-random chosen frequencies, you must give numeric column vectors for the values of the ' ...
    'properties ''freqsleft'' and ''freqsright''.']);
elseif strcmpi(Props.randfreq, 'no'), Props.nroffreqs = 2*numel(Props.freqsleft) + 1;
end
if ~isnumeric(Props.nroffreqs) | ~(mod(Props.nroffreqs,2)==1) | ...
        (Props.nroffreqs <= 0) | isempty(Props.nroffreqs), 
    error('Property ''nroffreqs'' must be a positive odd integer'); 
end

%Phase & time properties ... 
if ~isnumeric(Props.phasediffdc) & ~isempty(Props.phasediffdc), 
    error('Property ''phasediffdc'' must be numeric'); 
end
if ~isnumeric(Props.phasediffslope) | (isempty(Props.phasediffslope)), 
    error('Property ''phasediffslope'' must be numeric'); 
end
if ~strcmpi(Props.randphase, 'yes') & ~strcmpi(Props.randphase, 'no'), 
    error('Property ''randphase'' must be ''yes'' or ''no'''); 
end
if strcmpi(Props.randphase, 'no') & isempty(Props.phases), 
    error('If you want no random phases, you must specify a column vector with phases for property ''phases'', with length equal to property ''nroffreqs'''); 
end
if (isempty(Props.phasediffdc) & isempty(Props.delay)) | (~isempty(Props.phasediffdc) & ~isempty(Props.delay))
    error('Exactly one of the properties ''delay'' and ''phasediffdc'' must be given a value');
end
if ~isnumeric(Props.phases) & ~isempty(Props.phases), 
    error('Property ''phase'' must be numeric'); 
end
if ~isnumeric(Props.delay) & ~isempty(Props.delay), 
    error('Property ''delay'' must be numeric'); 
end

%Calculation properties ...
if ~isnumeric(Props.beginratio) | (Props.beginratio < 0) | (Props.beginratio > 1)...
        | isempty(Props.beginratio), 
    error('Property ''beginratio'' must be a scalar between 0 and 1'); 
end
if ~isnumeric(Props.endratio) | (Props.endratio < 0) | (Props.endratio > 1)...
        | isempty(Props.endratio), 
    error('Property ''endratio'' must be a scalar between 0 and 1'); 
end
if ~isnumeric(Props.maxtime) | (Props.maxtime < 0)...
        | isempty(Props.maxtime), 
    error('Property ''maxtime'' must be a positive scalar'); 
end
if ~isnumeric(Props.nsamples) | (Props.nsamples < 0)...
        | isempty(Props.nsamples), 
    error('Property ''nsamples'' must be a positive scalar'); 
end

%Correlation properties...
if ~isnumeric(Props.maxlag) | (Props.maxlag < 0)...
        | isempty(Props.maxlag), 
    error('Property ''nsamples'' must be a positive scalar'); 
end

%Plot properties...
if ~strcmpi(Props.displaysins, 'yes') & ~strcmpi(Props.displaysins, 'no'), 
    error('Property ''displaysins'' must be ''yes'' or ''no'''); 
end
if ~isnumeric(Props.stimshownp) | isempty(Props.stimshownp) | ...
        (Props.stimshownp < 0), 
    error('Property ''stimshownp'' must be a positive scalar'); 
end
if ~isnumeric(Props.corrshownp) | isempty(Props.corrshownp) | ...
        (Props.corrshownp < 0), 
    error('Property ''corrshownp'' must be a positive scalar'); 
end