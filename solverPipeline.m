%This pipeline is for computing the amplitude and rate of the first-order
%exponential function a*(1-exp(-k*x)) where a is amplitude, k is the rate,
%and x is time.

function solverPipeline(input,x,output)     %'input.fileextension', [1;2;3;4;n], 'output.fileextension'
    warning('off','all')    %Turns off all warnings.
    input_data = readtable(input)   %Read the input file as a table.
    raw = table2array(input_data)   %Converts the input table to an array.
    %r = size(raw,1)        %Computes number of rows in the dataset. For
    %debugging.
    c = size(raw,2)         %Compute number of columns in dataset. Establishes the end point for the for loop.
    %x = [2;7;20;60;180];    %Timepoints from dataset. 
    z = fittype( @(a,k,x) a*(1-exp(-k*x)), 'independent', {'x'});   %Creates the equation and coefficients we want fitted.
    %coeffnames(z) %For debugging.
    zo = fitoptions(z)  %Creates var for fitoptions.
    zo.Upper = [1 +Inf]     %Sets upper bound for amplitude as it can't be over 1.
    zo.Lower = [0 0]        %Sets lower bound for amplitude and rate as they can't be lower than 0.
    zo.MaxFunEvals = 1000   %Raises maximum amount of evaluations before stopping fitting. Reduces error rate.
    text = fopen(output, 'w+')   %Creates a new file for storing fitted values.

        for n = 1:1:c   %n is the current column of values the code is fitting. This iteration increases until it reaches the last column.
            y = raw(:,n);   %y is the array of values in a specific column. Uses all the rows.
            f = fit(x,y,z);     %Fits x and y using function z.
            f.a     %Prints amplitude.
            f.k     %Prints rate.
            fprintf(text, '%g %g\n', [f.a,f.k])     %Creates a two column table of amplitudes and rates. Saves to file.
        end
end