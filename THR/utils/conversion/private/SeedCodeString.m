function Str = SeedCodeString;
% SeedCodeString - 61-char long string containing all alphanumeric 
% chars exxept '0'
% Auxiliary function to seed2Str and Str2Seed.

% manual implementation because ascii order might be platform-dependent:

Str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
