function cic_init(Hm,varargin)
%CIC_INIT Initialization utility used in CIC concrete classes.

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

error(nargchk(1,6,nargin,'struct'));

% Set to true so that we avoid quantizing the states (and therefore
% creating FIs & FIMATHs) during the object initialization.  See either
% fixedcicfilterq/quantizestates or fixedcicinterpfilterq/quantizestates 
fq = Hm.filterquantizer;
fq.Initializing = true;

if nargin >= 2, set(Hm,'DifferentialDelay',varargin{1}); end
if nargin >= 3, set(Hm,'NumberOfSections',varargin{2}); end

% update internal settings  only ONCE during object initialization after
% R,D,N have been set
fq.Initializing = false;

% Update the internal settings of the filter PRIOR to quantizing states
updatefilterinternals(Hm);

if nargin >= 4, set(Hm,'InputWordLength',varargin{3}); end
if nargin >= 5, set(Hm,'FilterInternals','MinWordLengths',...
        'OutputWordLength',varargin{4}); end
if nargin >= 6, 
    set(Hm,'FilterInternals','SpecifyWordLengths',...
        'SectionWordLengths',varargin{5});
end


% Quantize states only ONCE during initialization
validatestates(Hm);



% [EOF]
