function matrix = updateTemperature(input)
    re = input;
    for r = 2 : (size(input, 1) - 1)
        for c= 2 : (size(input, 2) - 1)
            re(r,c) = (input(r+1,c) + input(r-1,c) + input(r,c+1) + input(r,c-1)) / 4;
        end
    end
    matrix = re;
end