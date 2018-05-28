function [result, chronicConnection] = saccadesHappened( chronicConnection )
%SACCADESHAPPENED Summary of this function goes here
%   Detailed explanation goes here

result = length(chronicConnection.saccadeQueue);