function L = iskeyword(s)
%ISKEYWORD Check if input is a keyword.
%   ISKEYWORD(S) returns one if S is a MATLAB keyword,
%   and 0 otherwise.  MATLAB keywords cannot be used 
%   as variable names.
%
%   ISKEYWORD used without any inputs returns a cell array containing
%   the MATLAB keywords.
%
%   See also ISVARNAME.

%   $Revision: 1.2 $  $Date: 2001/01/17 19:39:31 $
%   Copyright 1984-2001 The MathWorks, Inc.

L = {...
    'break',
    'case',
    'catch',
    'continue',
    'else',
    'elseif',
    'end',
    'for',
    'function',
    'global',
    'if',
    'otherwise',
    'persistent',
    'return',
    'switch',
    'try',
    'while',
    };

if nargin==0
%  Return the list only
  return
else
  L = any(strcmp(s,L));
end
