function outStruct = flatStruct(inStruct)
% FLATSTRUCT Flattens a structure
%
% struct outStruct = flatStrut(struct inStruct)
% Takes a structure inStruct, and returns a flat version of it.
%
%    inStruct: a structure, typically with different levels. Of course, for
%              this function to work, fieldnames should be unique.
%   outStruct: the same structure, but with one level.
%
% Example:
%    >> A.a.b = 17;
%    >> A.a.c = 33;
%    >> A.d = 'test'
%    A = 
%        a: [1x1 struct]
%        d: 'test'
%    >> flatStruct(A)
%    ans = 
%        b: 17
%        c: 33
%        d: 'test'

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

outStruct = [];

inFields = fieldnames(inStruct);
for i = 1:size(inFields)
    if isstruct(inStruct.(inFields{i}))
        % field is a struct: recursively flatten it
        inStruct = setfield(inStruct, inFields{i}, ...
            flatStruct( inStruct.(inFields{i})));
        % now the studied field is a flat structure. Move all fields ("deep
        % fields") up by one level
        deepFields = fieldnames(inStruct.(inFields{i}));
        for j= 1:size(deepFields)
            % if the fieldname already exists in the higher level, that is
            % a problem...
            if strmatch(deepFields{j}, inFields, 'exact')
                error('Cannot flatten fields: fieldnames are not unique!');
            end
            outStruct = setfield(outStruct, deepFields{j}, ...
                inStruct.(inFields{i}).(deepFields{j}));
        end
    else % if field is not a struct, there is nothing to do
        outStruct = setfield(outStruct, inFields{i}, inStruct.(inFields{i}));
    end
end
