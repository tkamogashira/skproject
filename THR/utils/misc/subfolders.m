function [D, DD] = subfolders(D);
% subfolders - list subfolders of a directory
%   subfolders('..\Foo') lists all subdirectories of directory Foo.
%   
%   L = subfolders('..\Foo') suppresses listing to the screen and returns
%   the list in cell string L instead.
%
%   See also fullFileName.

DD = dir(D);
DD = DD([DD.isdir]);
D = {DD.name};
% remove ritual .\ and ..\
irem1 = strmatch('.', D, 'exact');
irem2 = strmatch('..', D, 'exact');
D([irem1 irem2]) = [];
DD([irem1 irem2]) = [];





