% make script for SPTCORR utilities.

%How to recompile the accompanied C-code to a usable MEX-function?
%   1)Make sure MATLAB was configured for compiling MEX-files. The MATLAB package
%     always comes with a free C-compiler, LCC. To configure MATLAB so that it uses
%     this compiler run MEX -SETUP and let this setup program locate MATLAB compatible
%     C compiler for you. Next choose the LCC compiler as the one to be used.
%   2)To recompile a MEX-function just go to the directory where the source code is
%     located and type MEX FOO.C where FOO.C is the C source file to be compiled.
%     A DLL-file should be created in the same directory.

echo on;

%Make sptcorrmex.dll

%Making object file for the miscellaneous functions.
mex -c miscfnc.c;

%Making object file for the vector functions.
mex -c vectorfnc.c;

%Making mex file for sptcorrmex utility.
mex sptcorrmex.c vectorfnc.obj miscfnc.obj;

echo off