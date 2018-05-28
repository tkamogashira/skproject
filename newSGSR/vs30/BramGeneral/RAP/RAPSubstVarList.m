%----------------------------------------------------------------------
%                RAP SUBSTITUTION VARIABLE EXTENSION LIST
%----------------------------------------------------------------------
%
%Every line contains a new substitution variable. First specify the 
%variable name, followed by the type of substitution variable ('double' or
%'char') and the name of the field in the dataset structure to which this
%new substitution variable refers. The variable name and the type are
%case-insensitive, but the fieldname is not ...
%Comments can always be supplied using the standard MATLAB style.
%
%----------------------------------------------------------------------
%VarName    Type        DS fieldname
%----------------------------------------------------------------------
CHAN        DOUBLE      Stimulus.Special.ActiveChan     %Number of active channels
NTDRHO      DOUBLE      Stimulus.StimParam.Rho          %NTD correlation
NRHOVER     DOUBLE      Stimulus.StimParam.NRHOversion  %NRHO dataset version number
AKVER       DOUBLE      Stimulus.StimParam.AKversion    %ARMIN dataset version number
AKPOLLOW    DOUBLE      Stimulus.StimParam.polalow      %ARMIN dataset low polarity
AKPOLHIGH   DOUBLE      Stimulus.StimParam.polahigh     %ARMIN dataset high polarity
AKPOLCON    DOUBLE      Stimulus.StimParam.polaconst    %ARMIN dataset polarity of contralat. ear