%FCFWRITE   Write a filter coefficient file.
%   FCFWRITE(H) writes a filter coefficient ASCII-file.  H may be a single 
%   filter object or a vector of objects. A dialog box is displayed to 
%   fill in a file name. The default file name is 'untitled.fcf'. 
%
%   FCFWRITE(H,FILENAME) writes the file to a disk file called
%   FILENAME in the present working directory.
%
%   FCFWRITE(...,FMT) writes the coefficients in the format FMT. Valid FMT 
%   values are 'hex' for hexadecimal, 'dec' for decimal, or 'bin' for 
%   binary representation.
%
%   The extension '.fcf' will be added to FILENAME if it doesn't already
%   have an extension.

%   Copyright 2005 The MathWorks, Inc.

% [EOF]
