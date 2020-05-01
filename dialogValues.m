function values = dialogValues(names, defaultvalues, existingvalues, title)

% Prompt user for values using a dialog box
dims = [1 40];
numparams = size(names, 2);
definput = cell(1,numparams);
definput(:) = {num2str(defaultvalues)};

if (isa(existingvalues, 'cell'))
    for i = 1:numparams
        definput(i) = {num2str(existingvalues{i})};
    end
end

% Values of thiele small parameters
values = inputdlg(names,title,dims,definput);

% Convert parameters from strings to doubles
for i = 1:numparams
    values{i} = str2double(values{i});         % 
end

end