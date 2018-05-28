function disabled = isDisabled(expression)
%isDisabled returns true if the given breakpoint expression is disabled.
    wrappingFalse = 'false&&(';
    disabled = strcmp(expression, 'false') ...
        || strncmp(expression, wrappingFalse, length(wrappingFalse));
    
end