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