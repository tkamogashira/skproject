function boolean = ispp(PP)

boolean = isstruct(PP) & isfield(PP, 'form') & strcmpi(PP.form, 'pp');