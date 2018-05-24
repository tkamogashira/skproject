% paramequalizer_codegen
%
% Run this script to generate a standalone executable for the
% paramequalizer demo algorithm.

% Copyright 2011-2013 The MathWorks, Inc.

[fname pname] = uigetfile('*.*',  'Select an audio file');
if fname ~= 0
    audiofile = coder.newtype('constant',[pname, fname]);   
    disp('Generating standalone executable ...');        
    cfg =  coder.config('exe');
    cfg.CustomSource = 'paramequalizer_main.c';
    cfg.CustomInclude = fullfile((matlabroot), 'toolbox', 'dsp', 'dspdemos');   
    codegen -config cfg -report paramequalizer -args {audiofile} -o paramequalizer_executable
end
