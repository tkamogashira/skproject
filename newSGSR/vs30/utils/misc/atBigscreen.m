function iu=atBigScreen;
% ATBACKSCREEN - returns true if computer is Bigscreen or Oog
iu = isequal(7,exist('C:\USR\Marcel\FromUtrecht')) ...
    | isequal(2,exist('C:\Program Files\thisIsOOG.txt'));
