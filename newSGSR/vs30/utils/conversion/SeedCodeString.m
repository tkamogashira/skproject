function Str = SeedCodeString;

% SeedCodeString - 61-char long string containing all alphanumeric chars exxept '0'
% aux function for seedToStr and StrToSeed

% manual because ascii order might be platform-dependent:

Str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
