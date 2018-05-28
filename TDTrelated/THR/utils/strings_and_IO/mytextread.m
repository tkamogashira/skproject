function C = mytextread(FN);
% mytextread - read text file into char string
%    C = mytextread('foo.txt') reads text file foo.txt into cellstring C.

C = {};
fid=fopen(FN, 'rt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    C{end+1,1} = tline;
end
fclose(fid);