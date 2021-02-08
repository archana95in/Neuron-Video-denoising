%% Define Spike Histogram Function
% Inputs:
%   video_array: an array of grayscale images(intensities: [0-255])

function spikeHist(video_array)
    [numframes, height, width] = size(video_array);
    array = uint8(zeros(1, numframes * width * height));
   
    count_valid = 0;
    
    %get num valid pixels
    for j= 1: numframes
        frame = getFrame(video_array, j);
        for row = 1: height
             for column = 1: width
                 if frame(row, column) > 0
                     count_valid = count_valid + 1;
                 end
             end
        end
    end
    
    %create array to be filled
    array = zeros(1, count_valid);
    
    index = 1;
    
    %fill array
    for j= 1: numframes
        frame = getFrame(video_array, j);
        for row = 1: height
             for column = 1: width
                 if frame(row, column) > 0
                     array(index) = frame(row, column);
                     index = index + 1;
                 end
             end
        end
    end
    
    %divide by F0
    array = array ./ 44.44444;
    
    histogram(array)
end