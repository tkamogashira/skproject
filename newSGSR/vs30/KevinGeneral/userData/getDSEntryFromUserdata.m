function argOut =  getDSEntryFromUserdata( varargin )

argOut = [];
lookUp =  varargin{end};
UDArgs = varargin{1:end-1};

try
	UD = getuserdata(UDArgs);
catch UDError
	warning('SGSR:Info', 'Unable to retrieve userdata information: %s', UDError.message);
	return;
end

%No userdata entry
if isempty(UD)
	return;
end

%Check to see if an entry was made specifically for the dataset, otherwise
%inherit the values for the experiment and return.
gotCellInfo = ~isempty(UD.CellInfo);
if gotCellInfo && ~isempty(UD.CellInfo.(lookUp))
	argOut = UD.CellInfo.(lookUp);
elseif ~isempty(UD.Experiment.(lookUp))
	argOut = UD.Experiment.(lookUp);
end

end
