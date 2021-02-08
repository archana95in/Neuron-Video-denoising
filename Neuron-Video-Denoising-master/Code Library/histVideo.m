%% Define Video Histogram Function
% Inputs:
%   video_array: an array of grayscale images(intensities: [0-255])

function [mu, std_dev] = histVideo(video_array,hist_ymin,hist_ymax,parameter_yscale)
    [numframes, height, width] = size(video_array);
    array = uint8(zeros(1, numframes * width * height));
    array(:) = 100; %DEBUG: trying to prevent error
   
    i=1;
    
    for j= 1: numframes
        frame = getFrame(video_array, j);
        for row = 1: height
             for column = 1: width
                 array(i) = frame(row,column);
                 i = i+1;
             end
        end
    end
    
    histogram(array)
    ylim([hist_ymin hist_ymax])
    set(gca,'YScale',parameter_yscale)
    
    mu = mean(array);
    std_dev = std(double(array));
end