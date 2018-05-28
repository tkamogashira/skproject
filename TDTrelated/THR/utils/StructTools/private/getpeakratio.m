function [Ratio, Xp, Yp] = getpeakratio(varargin)
%GETPEAKRATIO   get ratio of peaks in oscillatory function
%   R = GETPEAKRATIO(PP) gives the ratio R of the secundary to the primary peak of the oscillatory function
%   defined by the cubic spline PP. The primary peak is the maximum closest to zero, the secondary peak
%   is the second closest.
%
%   [R, Xp, Yp] = GETPEAKRATIO(PP) gives the coordinates of the peaks in the two-element vectors Xp and Yp.
%
%   [R, Xp, Yp] = GETPEAKRATIO(X, Y) gives the ratio R and the coordinates of the peaks in the two-element 
%   vectors Xp and Yp of the oscillatory function defined by the vectors X and Y. 

%B. Van de Sande 19-05-2004

%After TOM C.T. YIN, JOSEPH C.K. CHAN and DEXTER R.F. IRVINE "Effects of Time Delays of Noise Stimuli
%on Low-Frquency Cells in the Cat's Inferior Colliculus. I. Responses to Wideband Noise" JOURNAL OF
%NEUROPHYSIOLOGY Vol 55, February 1986

%-------------------------------------implementatie-------------------------------------
%   Volgens artikel moet de piek-ratio berekend worden door de hoogte van de twee 
%   pieken die dichtst bij nul liggen te vergelijken. Hierbij wordt steeds de piek verst
%   van nul gedeeld door de piek dichtst bij nul ...
%---------------------------------------------------------------------------------------

if (nargin == 1) & isPP(varargin{1}), %CUBIC SPLINE ...
    %Deze manier van gebruik mag niet meer gebruikt worden ...
    warning('Old version of GETPEAKRATIO is being used.');
    
    PP = varargin{1};
    
    %DC-waarde berekenen ...
    Breaks = unmkpp(PP);
    DC = mean(ppval(PP, Breaks));
    
    %Eerste afgeleide berekenen om maxima te kunnen bepalen ...
    PPD = ppder(PP);
    Roots = pproots(PPD);
    
    %Maxima van minima onderscheiden ...
    Values = ppval(PP, Roots);
    idx = find(Values > DC);
    Maxima = Roots(idx); 
    Values = Values(idx);
    
    %Twee maxima dichtst bij nulpunt behouden ...
    [Dummy, idx] = unique(abs(Maxima));
    if length(idx) >= 2,
        Xp = Roots(idx(1:2));
        Yp = Values(idx(1:2));
        %Ratio = min(Yp)/max(Yp);
        Ratio = Yp(2)/Yp(1);
    else Ratio = NaN; [Xp,Yp] = deal([NaN, NaN]); end
elseif any(nargin == [2,3]) & isequal(size(varargin{1}), size(varargin{2})),
    [X, Y]  = deal(varargin{1:2});
    if (nargin == 3), DomFreq = varargin{3}; else, DomFreq = []; end
    
    %Periodiciteit in signaal nagaan ...
    if isempty(DomFreq), 
        FFT = SpectAna(X, detrend(Y, 'constant')); %DC-shift verwijderen ...
        DomFreq = FFT.DF;
    end
    if (DomFreq ~= 0) & ~isnan(DomFreq), 
        DomPer = 1000/DomFreq;
        
        %De primaire en secundaire piek liggen zeker in een range van 2 perioden rond
        %de nullijn ...
        [Xp, Yp] = deal(zeros(1, 3));
        idx = find((X >= -DomPer) & (X <= DomPer)); 
        [Xp(1), Yp(1)] = GetMaxLoc(X(idx), Y(idx)); %Maximum piek ...
        %De maximum peak mag natuurlijk niet op de rand liggen van het interval, indien
        %dit wel het geval is dan moet het interval waarin gezocht wordt naar de piek
        %aangepast worden ...
        idx = find(Xp(1) == X);
        if isequal(idx, length(X)) | ((X(idx) > 0) & (Y(idx+1) >  Y(idx))),
            idx = find((X >= -DomPer) & (X <= DomPer/2)); 
            [Xp(1), Yp(1)] = GetMaxLoc(X(idx), Y(idx)); %Nieuwe maximum piek ...
        elseif isequal(idx, 1) | ((X(idx) < 0) & (Y(idx-1) >  Y(idx))), 
            idx = find((X >= -DomPer/2) & (X <= DomPer)); 
            [Xp(1), Yp(1)] = GetMaxLoc(X(idx), Y(idx)); %Nieuwe maximum piek ...
        end
        
        %Zoeken naar tweede piek rond deze piek in de juiste richting ...
        if (Xp(1) == 0), %Geen richting geweten ...
            idx = find(X > (Xp(1) - DomPer*5/4) & X < (Xp(1) - DomPer*3/4));
            if ~isempty(idx), [Xp(2), Yp(2)] = GetMaxLoc(X(idx), Y(idx));
            else [Xp(2), Yp(2)] = deal(NaN); end    
            
            idx = find(X > (Xp(1) + DomPer*3/4) & X < (Xp(1) + DomPer*5/4));
            if ~isempty(idx), [Xp(3), Yp(3)] = GetMaxLoc(X(idx), Y(idx));
            else [Xp(3), Yp(3)] = deal(NaN); end
        elseif (Xp(1) > 0), %Zoeken links van de nullijn ...   
            idx = find(X > (Xp(1) - DomPer*5/4) & X < (Xp(1) - DomPer*3/4));
            if ~isempty(idx), [Xp(2), Yp(2)] = GetMaxLoc(X(idx), Y(idx));
            else [Xp(2), Yp(2)] = deal(NaN); end 
            [Xp(3), Yp(3)] = deal(NaN);
        else, %Zoeken rechts van de nullijn ...
            idx = find(X > (Xp(1) + DomPer*3/4) & X < (Xp(1) + DomPer*5/4));
            if ~isempty(idx), [Xp(2), Yp(2)] = GetMaxLoc(X(idx), Y(idx));
            else [Xp(2), Yp(2)] = deal(NaN); end
            [Xp(3), Yp(3)] = deal(NaN);
        end
        %Plaatsen van pieken in de juiste volgorde, dus afhankelijk van afstand
        %tot de nullijn ... 
        [dummy, idx] = sort(abs(Xp));
        Xp = Xp(idx(1:2)); Yp = Yp(idx(1:2));
                
        %Ratio wordt gegeven door de peak verst van nul te delen door de piek
        %dichtst bij nul ...
        Ratio = Yp(2)/Yp(1);
    else, [Xp, Yp] = deal([NaN NaN]); Ratio = NaN; end;
else, error('Wrong input arguments.'); end    