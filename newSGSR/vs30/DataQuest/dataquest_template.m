%-----------------------------------------------------------------
%          DATAQUEST - Specific Parameters Template
%-----------------------------------------------------------------
function S = DataQuestSchema(ds)
%The specific stimulus parameters for a given dataset must be defined
%by the user in different schemata. Each schemata is a MATLAB function
%which returns a structure array S and must accept a dataset as first
%and only input argument. 

%The structure returned must always have the same fieldnames and in
%the same order. The function STRUCTTEMPLATE.M can be used to achieve
%this requirement. If nothing no specific stimulus parameters are present
%for a dataset then the function should return the empty structure.

%Squeezing of stimulus parameters to most economical size can be
%done with the function SQUEEZEPARAM.M. This is completely optional, 
%but the same function is applied to the common stimulus parameters
%by DATAQUEST.M.

%The script can return one warning which is captured by DATAQUEST.M
%and is logged accordingly.

%Attention! For SGSR datasets, there are sometimes multiple versions
%of the same stimulus type. The script for an SGSR stimulus type must
%make sure that whatever the version the returned structure is the
%same. It is a good idea to do a version check in this function and
%warn the user about new version for which the function wasn't intended.
%Example code:
VERSION = 1.0; VerFieldName = 'version';
if ~isfield(ds.StimParam, VerFieldName), 
    warning(sprintf('Failed to do version check on dataset %s.', ds.title));
elseif (getfield(ds.StimParam, VerFieldName) > VERSION), 
    warning(sprintf('Dataset %s found that has newer version than script was intended for.', ds.title)); 
end

%-----------------------------------------------------------------