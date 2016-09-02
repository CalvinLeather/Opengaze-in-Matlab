function [ output_args ] = getState(obj, command)
%GETSTATE This function gets the state of a particular opengaze variable
fprintf(obj.client_socket, ['<GET ID="',command,'" />']);
safeRead(obj)
end
