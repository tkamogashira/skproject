function structOut = blowStruct(structIn, tempStruct)
% STRUCTOUT gives a flat structure structIn the same format as tempStruct
%
% struct structOut = blowStruct(structIn, tempStruct)
% Takes a flat structure structIn, and a template structure tempStruct with
% the same leafs, typically with multiple levels.
%
%     structIn: a flat structure that we want to get in shape.
%    structOut: a template with the same leafs, but with the formatting we
%               want. The values of this structure are ignored.
% 
%      returns: structIn, with the formatting of structOut
% 
% Example:
%    >> structIn.a = 5;
%    >> structIn.b = 7;
%    >> structIn.c = 9;
%    >> tempStruct.a = 'dummy';
%    >> tempStruct.t.b = 'dummy';
%    >> tempStruct.s.c = 'dummy';
%    >> B = blowStruct(structIn, tempStruct)
%    B = 
%        a: 5
%        t: [1x1 struct]
%        s: [1x1 struct]
%    >> B.t
%    ans = 
%        b: 7
%    >> B.s
%    ans = 
%        c: 9

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

if ~isFlat(structIn)
    error(['Can only blow up flat structures. ' ...
        'Type ''help blowStruct'' for more information.']);
end

inFields = fieldnames(structIn);

if ~isequal( sort(inFields), sort(fieldnames(flatStruct(tempStruct))) )
    error(['Structure and template must contain the same leafs. ' ...
        'Type ''help blowStruct'' for more information.']);
end

structOut = fillStruct(tempStruct, structIn);
