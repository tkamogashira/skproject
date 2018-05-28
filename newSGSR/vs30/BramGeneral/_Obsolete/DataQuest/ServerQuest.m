function varargout = ServerQuest(varargin)
%SERVERQUEST    search for datasets using database on SGSR server.
%   SERVERQUEST searches for datasets by stimulus parameters using database
%   on SGSR server. This program is just a shell around DATAQUEST.M. See this
%   file for information on syntax.
%
%   See also DATAQUEST

%B. Van de Sande 28-07-2004

if strcmpi(compuname, 'KIWI'), ServerDir = 'c:\sgsrserver\expdata\dataquest';
else, ServerDir = 's:\expdata\dataquest'; end
if ~exist(ServerDir, 'dir'), error('Could not find DATAQUEST database on SGSR server.'); end

idx = find(cellfun('isclass', varargin, 'char'));
if any(strcmpi(varargin(idx), 'datadir')), error('Property datadir cannot be used with SERVERQUEST.'); end

if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    dataquest('factory');
    fprintf('Property datadir is set to ''%s'' by SERVERQUEST.\n', ServerDir);
else, [varargout{1:nargout}] = DataQuest(varargin{:}, 'datadir', ServerDir); end