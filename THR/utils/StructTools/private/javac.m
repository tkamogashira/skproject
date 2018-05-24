function javac(varargin)
%JAVAC compile java source code
%   JAVAC(FileName1, ...) compiles java source code files into bytecode.

%B. Van de Sande 15-07-2003

JavaDir = 'C:\Program Files\JAVA 2 SDK 1.4.2\';       %Directory waar JAVA SDK geinstalleerd is ...
UsrDir  = ['C:\USR\' UserName '\mfiles\General\JavaClasses\']; %User specifieke directory met java-classes ...

if ~iscellstr(varargin), error('Input arguments should be JAVA source code files.'); end

idx = setdiff(1:nargin, strfindcell(varargin, '.java'));
for n = 1:length(idx), varargin{idx} = [varargin{idx} '.java']; end

cwd = pwd; cd(UsrDir);

%Opties voor de JAVA command line compiler:
%   -target 1.1                              : comipleren naar bytecode voor VM versie 1.1 die compatibel is met de 
%                                              JRE van MATLAB
%   -classpath C:\USR\<UserName>\JavaClasses : directory waar alle user-gedefinieerde classen kunnen gevonden worden
%   -d C:\USR\<UserName>\JavaClasses         : directory waar de java bytecode terecht moet komen
JavaOpt = ['-target 1.1 -classpath ' UsrDir ' -d ' UsrDir ];

cmd = ['!"' JavaDir 'bin\javac" ' JavaOpt ' ' varargin{:}]; eval(cmd);

cd(cwd);