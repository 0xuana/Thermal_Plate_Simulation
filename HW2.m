% Initialize the plate
n = 50; % Size of the plate
plate = initializePlate(n);

% Visualize and save the initial temperature distribution
figure;
imagesc(plate);
axis equal tight;
colormap("cool");
colorbar;
title('Initial Temperature Distribution');
saveas(gcf, 'initial_temperature.png');

% % Add value into the block
% for i = 1:size(plate,1)
%     for j = 1:size(plate,2)
%         text(j, i, num2str(plate(i,j)), 'HorizontalAlignment', 'center', ...
%             'Color', 'k', 'FontSize', 8);
%     end
% end

% Iteratively update the temperature distribution
threshold = 0.01;
maxChange = Inf;
initialPlate = plate;
iteration = 0;

% For movie creation
F(n) = struct('cdata',[],'colormap',[]);
while maxChange > threshold
    updatedPlate = updateTemperature(plate);
    maxChange = max(max(abs(updatedPlate - plate)));
    plate = updatedPlate;
    iteration = iteration + 1;
    % Visualize the current temperature distribution
    imagesc(plate);
    axis equal tight;
    title(['Iteration ', num2str(iteration)]);
    % For movie creation
    frame = getframe(gcf);
    
    % Check and pad frame to have even dimensions if necessary
    [height, width, ~] = size(frame.cdata);
    
    if mod(width, 2) == 1
        frame.cdata = cat(2, frame.cdata, frame.cdata(:, end, :));  % pad last column
    end
    if mod(height, 2) == 1
        frame.cdata = cat(1, frame.cdata, frame.cdata(end, :, :));  % pad last row
    end

    F(iteration) = frame;
end

% Save the movie in MP4 format
v = VideoWriter('temperature_evolution', 'MPEG-4'); % Specify MPEG-4 format
v.Quality = 95; % Set quality (0-100). Higher value gives better quality.
v.FrameRate = 60; % Set frame rate. Adjust as needed.
open(v);
writeVideo(v, F);
close(v);

% Analyze the plate
[avgTemp, maxChangePoint] = analyzePlate(initialPlate, plate);

% Plot the temperature distribution along the diagonal
figure;
plot(diag(plate));
title('Temperature Distribution Along the Diagonal');
xlabel('Position Along Diagonal');
ylabel('Temperature (°C)');
saveas(gcf, 'diagonal_temperature.png');





% Function generate the initial plate
function matrix = initializePlate(n)
    matrix = initializePlate_All(n, 25, 100, 50, 0, 75);
end

% Function that generate any customize initial plate
function matrix = initializePlate_All(n, base_temp, top_temp, bottom_temp, left_temp, right_temp)
    re = ones(n) * base_temp;
    % use array(x,:) setup row
    re(1,:) = top_temp;
    re(n,:) = bottom_temp;
    % use array(:,x) setup column
    re(:,1) = left_temp;
    re(:,n) = right_temp;
    
    % Set up corner.
    re(1,1) = (top_temp + left_temp) / 2;
    re(1,n) = (top_temp + right_temp) / 2;
    re(n,1) = (bottom_temp + left_temp) / 2;
    re(n,n) = (bottom_temp + right_temp) / 2;
    
    matrix = re;
end

function matrix = updateTemperature(input)
    re = input;
    for r = 2 : (size(input, 1) - 1)
        for c= 2 : (size(input, 2) - 1)
            re(r,c) = (input(r+1,c) + input(r-1,c) + input(r,c+1) + input(r,c-1)) / 4;
        end
    end
    matrix = re;
end

function [avgTemp, maxChangePoint] = analyzePlate(initialPlate, finalPlate)
    avgTemp = sum(finalPlate, 1:2) / (size(finalPlate, 1) * size(finalPlate, 1));
    plateChange = abs(initialPlate - finalPlate);
   
    maxD1 = max(plateChange, [], 1);        % Get the maximum in every column
    maxD2 = max(plateChange, [], 2);        % Get the maximum in every rows
    [~,i_c] = max(maxD1);               % Find the maximum number in the column and store it column index in i_c 
    [~,i_r] = max(maxD2);               % Find the maximum number int the row and store it row index in i_r

    maxChangePoint = [i_r, i_c];
end