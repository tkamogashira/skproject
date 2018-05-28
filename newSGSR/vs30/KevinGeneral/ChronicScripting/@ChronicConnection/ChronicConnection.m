function newChronicConnection = ChronicConnection(varargin)
% Created by: Kevin Spiritus
% Last edited: October 18th, 2007

%% standard properties
newChronicConnection.JavaAlias      = 'ChronicJava';
newChronicConnection.MatlabAlias    = 'ChronicMatlab';
newChronicConnection.sendPort       = 4000;
newChronicConnection.rcvPort        = 4001;
newChronicConnection.rspPort        = 4002; % immediate responses to urgent requests
newChronicConnection.timeOut        = 1;
newChronicConnection.connected      = 0;
newChronicConnection.msgQueue       = {};
newChronicConnection.saccadeQueue   = [];
newChronicConnection.currWindow     = NaN;
%newChronicConnection.verbose        = 0;

%% set the Alias; Java will set it's own alias.
SetKMailAlias(newChronicConnection.MatlabAlias);

%% construct
newChronicConnection = class(newChronicConnection, 'ChronicConnection');