function [avgTemp, maxChangePoint] = analyzePlate(initialPlate, finalPlate)
    avgTemp = sum(finalPlate, 1:2) / (size(finalPlate, 1) * size(finalPlate, 1));

    plateChange = abs(initialPlate - finalPlate);
    maxD1 = max(plateChange, [], 1);        % Get the maximum in every column
    maxD2 = max(plateChange, [], 2);        % Get the maximum in every rows
    [~,i_c] = max(maxD1);               % Find the maximum number in the column and store it column index in i_c 
    [~,i_r] = max(maxD2);               % Find the maximum number int the row and store it row index in i_r

    maxChangePoint = [i_r, i_c];
end