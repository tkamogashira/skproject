function [p, MSerror, DF] = signlinreg(P, X, Y, W)
%SIGNLINREG significance of linear regression
%   p = SIGNLINREG(P, X, Y) gives the probability p that the linear regression, given by the first order 
%   polynomial P, isn't a good fit for the sampled data represented by vectors X and Y. 
%
%   p = SIGNLINREG(P, X, Y, W) gives the probability p that the linear regression with weigths given by the
%   vector W isn't a good fit. 
%
%   [p, MSerror, DF] = SIGNLINREG(P, X, Y) returns the mean square error MSerror = sum{(Y - polyval(P,X)).^2}/DF, 
%   and the degrees of freedom DF.
%
%   See also POLYFIT, POLYVAL

%B. Van de Sande 20-02-2004

%After TOM C. T. YIN and SHIGEYUKI KUWADA, "Binaural Interaction in Low-Frequency Neurons in Inferior Colliculus
%of the Cat III. Effects of Changing Frequency", JOURNAL OF NEUROPHYSIOLOGY Vol.50, No.4, October 1983
%and SHIGEYUKI KUWADA, TERRENCE R. STANFORD and RANJAN BATRA, "Interaural Phase-Sensitive Units in the Inferior
%Colliculus of the Unanesthetized Rabbit: Effects of Changing Frequency.", JOURNAL OF  NEUROPHYSILOGY Vol 57,
%No. 5, May 1987

if (nargin == 1) & ischar(P) & strcmpi(P, 'calc'), localGetCDF('redo'); return; end

if ~any(nargin == [3, 4]), error('Wrong number of input arguments.'); end
if nargin == 3, W = repmat(1, length(X), 1); end
if ~isequal(length(X),length(Y),length(W)), error('Arguments must be vectors with same length.'); end

[X, Y, W] = deal(X(:), Y(:), W(:));

NSamples = length(Y);
Order = length(P) - 1; if Order ~= 1, error('Order of polynomial should be one.'); end
DF = NSamples - (Order+1);

%Two datapoints always give an exact linear fit ...
if DF == 0,
    warning('Only two datapoints, MSerror cannot be calculated.');
    p = 0; MSerror = NaN; return; 
end

%Mean Square Error MSerror...
SS = (sum(W.*(Y - polyval(P,X)).^2) * NSamples)/sum(W);
MSerror = SS/DF;

%Cumulative distribution function (c.d.f.) ...
CDF = localGetCDF;

MaxDF = length(CDF.DF) - 1;
if DF > MaxDF, DFr = MaxDF + 1; 
else DFr = DF; end

Col1 = max(find(CDF.MSerror <= MSerror)); 
Col2 = Col1 + 1;

%Significance p for given MSerror ...
p = interp1(CDF.MSerror([Col1,Col2]), CDF.Table(DFr, [Col1,Col2]), MSerror, 'linear');

%-------------locals------------------
function CDF = localGetCDF(Mode)

FileName = [ mfilename '.cdf'];

if (nargin == 1) & ischar(Mode) & strcmpi(Mode, 'redo') & exist(FileName, 'file'), 
    Path = fileparts(which(mfilename));
    delete([Path filesep FileName]);
end

if exist(FileName, 'file'), load(FileName, 'CDF', '-mat');
else,
    warning(sprintf('Calculating cumulative distribution function(c.d.f.), this will take a while.\nAfterwards, invoking of %s.m won''t take as long, because distribution function is cached.', mfilename));
    
    PhaseRange = 1 - eps; %Phase is wrapped around at 0 or 1
    MSerrorAcc = 1000;
    MSerrorMax = 0.50;
    DFs        = [1:30, 1000];
    NDF        = length(DFs);
    N          = 100000;
    
    MSerror = zeros(NDF, N);
    
    %Generate distribution function by calculating MSerror N times for uniform distribution of phase for 
    %each degree of freedom ...
    for i = 1:NDF
        DF = DFs(i);
        NSamples = DF + 2;
        X = 1:NSamples;
        
        for n = 1:N
            YRand = unwrap(rand(1, NSamples) * PhaseRange *2*pi)/2/pi;
            PRand = polyfit(X, YRand, 1);
            MSerror(i, n) = sum((YRand - polyval(PRand, X)).^2)/DF;
        end

        XMSerror = linspace(0, MSerrorMax, MSerrorAcc);
        H = histc(MSerror(i, :), XMSerror); H(end) = []; 
        XMSerror = XMSerror + (XMSerror(2) - XMSerror(1))/2; XMSerror(end) = [];
        %Probability density function (p.d.f.)
        PDF(i,:) = H / N;
        %Cumulative distribution function (c.d.f.)
        CDF(i,:) = cumsum(H) / N;
    end
    
    %Assembly of table ...
    DF = DFs;
    MSerror = XMSerror;
    Table = PDF;
    PDF = CollectInStruct(DF, MSerror, Table);

    DF = [DFs(1:end-1) Inf];
    MSerror = [0 XMSerror(1:end-1) Inf];
    Table = [repmat(0, NDF, 1), CDF];
    CDF = CollectInStruct(DF, MSerror, Table);
    
    %Saving table to disk ...
    Path = fileparts(which(mfilename));
    save([Path filesep FileName], 'PDF', 'CDF', '-mat');    
end