function string=implode(pieces,delimiter)
%IMPLODE    Joins strings with delimiter in between.
%   IMPLODE(PIECES,DELIMITER) returns a string containing all the
%   strings in PIECES joined with the DELIMITER string in between.
%
%   Input arguments:
%      PIECES - the pieces of string to join (cell array), each cell is a piece
%      DELIMITER - the delimiter string to put between the pieces (string)
%   Output arguments:
%      STRING - all the pieces joined with the delimiter in between (string)
%
%   Example:
%      PIECES = {'ab','c','d','e fgh'}
%      DELIMITER = '->'
%      STRING = IMPLODE(PIECES,DELIMITER)
%      STRING = ab->c->d->e fgh
%
%   See also EXPLODE, STRCAT
%
%   Created: Sara Silva (sara@itqb.unl.pt) - 2002.08.25
%   Modified: Sara Silva (sara@dei.uc.pt) - 2005.03.11
%       - implode did not work if the delimiter was whitespace, so
%         line 36 was replaced by line 37.
%       - thank you to Matthew Davidson for pointing this out
%         (and providing the solution!)
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


if isempty(pieces) % no pieces to join, return empty string
   string='';
   
else % no need for delimiters yet, so far there's only one piece
   string=pieces{1};   
end

l=length(pieces);
p=1;
while p<l % more than one piece to join with the delimiter, the interesting case
   p=p+1;
	%string=strcat(string,delimiter,pieces{p});
    string=[string delimiter pieces{p}];
end
