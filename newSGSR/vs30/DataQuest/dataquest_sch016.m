%-----------------------------------------------------------------
%     DATAQUEST - Specific Parameters for SCH016 datasets
%-----------------------------------------------------------------
function S = DataQuestSchema(ds)

%Schemata SCH006, SCH012 and SCH016 all have the same organisation
%of the StimParam-field ...
S = dataquest_sch012(ds);

%-----------------------------------------------------------------