%% Define In Bounds Function
% Return 1 if (x,y) is inside of im
% Return 0 otherwise

function ret = inBounds(row, col, im)
    [height, width] = size(im);
    
    %if in bounds, return 1
    if (row >= 1 && row <= height) && (col >= 1 && col <= width)
        ret = true;
    else
        ret = false;
end