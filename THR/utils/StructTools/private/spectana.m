function varargout = spectana(T, S, varargin)
%SPECTANA spectrum analysis of digital signal with DFT
%   S = SPECTANA(X, Y, ...) analyses spectrum of digital signal given by vectors X and Y, where X is 
%   a linear spaced time-axis (in millisec) and Y is the amplitude of the signal. This function returns 
%   a structure S with fields :
%
%   S.Freq          : frequency in Hz 
%   S.Magn.A        : amplitudo spectrum         | matrix with first row containing the original spectrum
%   S.Magn.P        : power spectrum             | and the second row the running average on the spectrum
%   S.Magn.dB       : dB spectrum                |   
%   S.DF            : dominant frequency in Hz
%   S.BW            : bandwidth in Hz
%   S.Ph.Rad        : phase spectrum in radians  
%   S.Ph.Cyc        : phase spectrun in cycles   
%   S.GD            : group delay in ms
%   S.AccFrac       : fraction of variance accounted for linear fit of phase spectrum
%   S.FsD           : delay of fine structure in radians    
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'list' as only property.
%
%   The old interface is still implemented and is invoked if there is more than one output argument:
%   [XS, YS, YSRunAv, DF] = SPECTANA(X, Y) analyses spectrum of digital signal given by vectors X and Y, where X
%   is a linear spaced time-axis(in millisec) and Y is de amplitude of the signal. This function returns the spectrum
%   as 2 vectors: XS is the frequency-axis(in Hz), YS is de ampiltude of each given frequency in the signal given in
%   dB(maximum A is reference, thus maximum is at 0 dB). The dominant frequency in the signal is given in DF.
%
%   [XS, YS, YSRunAv, DF] = SPECTANA(X, Y, RunAvRange) does the same analysis, but uses a running average of range
%   RunAvRange in Hz, which is returned as the vector YSRunAv, to calculated the DF.

%B. Van de Sande 29-09-2003

if nargout > 1, %OLD VERSION ...
    [X, Y] = deal(T, S); if ~isempty(varargin), RunAvRange = varargin{1}; else RunAvRange = []; end
    
    if ~any(nargin == [2,3]), error('Wrong number of input arguments.'); end
    if ~any(size(X) == 1) | ~any(size(Y) == 1) | ~isequal(length(X), length(Y)), error('First two inputs should be vectors of same size.'); end
    if nargin == 2, RunAvRange = 0; end
    
    if size(Y, 1) == 1, Y = Y'; iscol = logical(0); end
    
    %Discrete fourier transformatie in dB ...
    NBin = length(X);
    dt = X(2)-X(1); %BinWidth
    HanFilter = hanning(NBin);
    Zeros = zeros(2^(2+nextpow2(NBin))-NBin, 1);
    NSamples = length(Zeros)+NBin;
    Tmax = (NSamples) * dt; 
    df = 1000/Tmax;
    RunAvN = RunAvRange / df;
    
    A = abs(fft([HanFilter.*Y; Zeros]));
    YS = local_A2dB(A, max(A));
    YSRunAv = runav(YS, RunAvN);
    XS = (0:length(YS)-1)' * df;
    
    %Het achterhalen van de dominante frequentie ...
    DF = getmaxloc(XS, YSRunAv, 0, [0, max(XS)/2]);
    if (DF < 10), DF = getmaxloc(XS, YSRunAv, 0, [50, max(XS)/2]); end %Waarschijnlijk DC aanwezig in signaal ... vanaf 50Hz zoeken naar maximum ...
    
    if ~iscol, [XS, YS, YSRunAv] = deal(XS', YS', YSRunAv'); end
    
    [varargout{1:4}] = deal(XS, YS, YSRunAv, DF);
else, %NEW EXTENDED VERSION ...
    %Default parameters ...
    DefParam.RunAvUnit  = '#';   %'#' or 'Hz' ...
    DefParam.RunAvRange = 0;
    DefParam.TimeUnit   = 1e-3;  %milliseconds ...
    DefParam.BWCutOff   = -10;   %in dB ...
    DefParam.GDrange    = 100;   %in % ...
    
    if nargin < 2, error('Wrong number of input arguments.'); end
    if ~any(size(T) == 1) | ~any(size(S) == 1) | ~isequal(length(T), length(S)), error('First two inputs should be vectors of same size.'); end
    
    Param = checkproplist(DefParam, varargin{:});
    
    if ~any(strncmpi(Param.runavunit, {'#', 'h'}, 1)), error('Invalid value for property runavunit.'); end
    if ~isnumeric(Param.runavrange) | (length(Param.runavrange) ~= 1) | (Param.runavrange < 0), error('Invalid value for property runavrange.'); end
    if ~isnumeric(Param.timeunit) | (length(Param.timeunit) ~= 1) | (Param.timeunit <= 0), error('Invalid value for property timeunit.'); end
    if ~isnumeric(Param.bwcutoff) | (length(Param.bwcutoff) ~= 1) | (Param.bwcutoff >= 0), error('Invalid value for property bwcutoff.'); end
    if ~isnumeric(Param.gdrange) | (length(Param.gdrange) ~= 1) | (Param.gdrange <= 0), error('Invalid value for property gdrange.'); end
    
    if size(S, 1) == 1, S = S'; end
    
    %Discrete Fourier Transformation (DFT) ...
    N = length(T); dt = T(2)-T(1);
    
    HanWin = hanning(N);
    Zeros = zeros(2^(2+nextpow2(N))-N, 1);
    NSamples = length(Zeros) + N; %Extra sample punten toevoegen komt neer op interpoleren in frequentie-spectrum ...
    Tmax = NSamples * dt; 
    df = 1/(Param.timeunit*Tmax);
    
    Vec = [HanWin.*S; Zeros]; %Om phase spectrum juist te kunnen interpreteren moet eerste element overeenkomen met
    Zidx = min(find(T >= 0)); %nul op de tijdsas ...
    Vec = [Vec(Zidx:end); Vec(1:Zidx)];
    
    c = fft(Vec);
    A = abs(c)'; Ph = angle(c)';
    f = (0:length(c)-1) * df;
    
    D.Freq = f;
    
    %Bijkomende informatie berekenen ... 
    if strncmpi(Param.runavunit, 'h', 1), RunAvN = Param.runavrange / df;
    else, RunAvN = Param.runavrange; end    
    
    %Dominante Frequentie (DF) en BandBreedte (BW) halen uit magnitude spectrum ...
    D.Magn.A      = [A; runav(A, RunAvN)];
    D.Magn.P      = [A.^2; runav(A.^2, RunAvN)];
    D.Magn.dB     = [local_A2dB(A, max(A)); runav(local_A2dB(A, max(A)), RunAvN)];
    
    DF = getmaxloc(f, A, RunAvN, [0, max(f)/2]);
    if (DF < 10), DF = getmaxloc(f, A, RunAvN, [50, max(f)/2]); end %if DC in signal then discard first 50Hz of spectrum ...
    fEdges = cintersect(f, D.Magn.dB(2, :), Param.bwcutoff);
    BW = diff(fEdges);
    
    D.DF          = DF;     %in Hz ...
    D.BW          = BW;     %in Hz ...
    D.BWedges     = fEdges; %in Hz ...
    
    %Group Delay (GD) en delay van fijnstructuur (FsD) halen uit phase spectrum ...
    DFidx = find(f == DF);
    Ph = unwrap(Ph);
    PhOrig = Ph(DFidx);
    PhNew = mod(PhOrig+pi, 2*pi)-pi; %Phase terugbrengen naar interval [-pi,+pi[ ...
    Ph = Ph - PhOrig + PhNew;
    
    NBW = round((BW * Param.gdrange/100)/df/2)*2; 
    if ~isnan(BW) & ((DFidx - NBW/2) > 0),
        W = zeros(size(f)); W(DFidx - NBW/2) = 1; 
        W = conv(W, hanning(NBW)); W = W(1:end-NBW+1);
        P = linregfit(f, Ph, W); GD = P(1) * 1000 /2 /pi;
        
        Variance = sum(W.*(mean(Ph) - Ph).^2);
        Residual = sum(W.*((P(1)*f + P(2))- Ph).^2);
        
        AccFrac = 1 - (Residual/Variance);
    else, [GD, AccFrac] = deal(NaN); end
    
    D.Ph.Rad  = Ph;
    D.Ph.Cyc  = Ph /2/pi;
    D.GD      = GD;      %in ms ...
    D.AccFrac = AccFrac; %in % ...
    D.FsD     = PhNew;  %in rad ...
    
    D.Params = Param;
    
    if nargout == 1, varargout{1} = D; end
end

%-----------------------------------------------locals---------------------------------------------------
function dB = local_A2dB(A, RefA)

dB = 20.*log10(A/RefA); %On amplitude, not on power ...