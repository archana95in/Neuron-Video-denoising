%% Define Get Valid Neighbors Function
% Returns a list of the neighbors of a given pixel that are within the
% boundaries of the images

% Format is [[a;b], [c;d], [e;f]...]
% (this was chosen in order to work with the java.util.LinkedList
% data structure

function ret = getValidNeighbors(row_val, col_val, im)
    [height, width] = size(im);
    
    %create matrix of [[-1;-1], [-1;-1], ...]
    possible_neighbors = repmat(-1, 2, 8);
    
    num_valid = 0;
    
    %check upper left
    if (row_val -  1) >= 1 && (row_val - 1) <= height
        if (col_val -  1) >= 1 && (col_val - 1) <= width
            possible_neighbors(:,1) = [row_val - 1; col_val - 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check upper
    if (row_val -  1) >= 1 && (row_val - 1) <= height
        if col_val >= 1 && col_val <= width
            possible_neighbors(:,2) = [row_val - 1; col_val];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check upper right
    if (row_val -  1) >= 1 && (row_val - 1) <= height
        if (col_val +  1) >= 1 && (col_val + 1) <= width
            possible_neighbors(:,3) = [row_val - 1; col_val + 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check left
    if row_val >= 1 && row_val <= height
        if (col_val -  1) >= 1 && (col_val - 1) <= width
            possible_neighbors(:,4) = [row_val; col_val - 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check right
    if row_val >= 1 && row_val <= height
        if (col_val +  1) >= 1 && (col_val + 1) <= width
            possible_neighbors(:,5) = [row_val; col_val + 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check lower left
    if (row_val +  1) >= 1 && (row_val + 1) <= height
        if (col_val -  1) >= 1 && (col_val - 1) <= width
            possible_neighbors(:,6) = [row_val + 1; col_val - 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check lower
    if (row_val +  1) >= 1 && (row_val + 1) <= height
        if col_val >= 1 && col_val <= width
            possible_neighbors(:,7) = [row_val + 1; col_val];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %check lower right
    if (row_val +  1) >= 1 && (row_val + 1) <= height
        if (col_val +  1) >= 1 && (col_val + 1) <= width
            possible_neighbors(:,8) = [row_val + 1; col_val + 1];
            num_valid = num_valid + 1; %increment num_valid
        end
    end
    
    %if no valid or invalid inputs, don't return anything
    if (num_valid == 0) || (row_val < 1) || (col_val < 1)
        ret = [];
    else
        ret = zeros(2,num_valid);
        index_possibles = 1;
        index_ret = 1;
    
        while index_ret <= num_valid
            %if valid coordinates, add them to ret
            if possible_neighbors(:,index_possibles) ~= [-1;-1]
                ret(:,index_ret) = possible_neighbors(:,index_possibles);
                index_ret = index_ret + 1;
            end
            %increment index_possibles
            index_possibles = index_possibles + 1;
        end
    end    
end