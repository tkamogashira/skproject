function [split,numpieces]=explode(string,delimiters)
%EXPLODE    Splits string into pieces.
%   EXPLODE(STRING,DELIMITERS) returns a cell array with the pieces
%   of STRING found between any of the characters in DELIMITERS.
%
%   [SPLIT,NUMPIECES] = EXPLODE(STRING,DELIMITERS) also returns the
%   number of pieces found in STRING.
%
%   Input arguments:
%      STRING - the string to split (string)
%      DELIMITERS - the delimiter characters (string)
%   Output arguments:
%      SPLIT - the split string (cell array), each cell is a piece
%      NUMPIECES - the number of pieces found (integer)
%
%   Example:
%      STRING = 'ab_c,d,e fgh'
%      DELIMITERS = '_,'
%      [SPLIT,NUMPIECES] = EXPLODE(STRING,DELIMITERS)
%      SPLIT = 'ab'    'c'    'd'    'e fgh'
%      NUMPIECES = 4
%
%   See also IMPLODE, STRTOK
%
%   Created: Sara Silva (sara@itqb.unl.pt) - 2002.04.30
% Copyright (c) 2007, Sara Silva
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.


if isempty(string) % empty string, return empty and 0 pieces
   split{1}='';
   numpieces=0;
   
elseif isempty(delimiters) % no delimiters, return whole string in 1 piece
   split{1}=string;
   numpieces=1;
   
else % non-empty string and delimiters, the correct case
   
   remainder=string;
   i=0;
   
	while ~isempty(remainder)
   	[piece,remainder]=strtok(remainder,delimiters);
   	i=i+1;
   	split{i}=piece;
	end
   numpieces=i;
   
end
