function Func_FrameShow(frame, p, str)
%   Image show a frame with options
%   options = "normal", "contrast", "reverse"
    figure;
text(4, 2,'Title')
    subplot(1,3,1)
    frame_to_show = frame + 0.5;
    imshow(frame_to_show, 'InitialMagnification', 800);
    xlabel("Spatial")
    ylabel("Temporal")
    subplot(1,3,2)
    frame_to_show = 10 * (frame - mean(frame, [1 2]));
    frame_to_show = frame_to_show + 0.5;
    imshow(frame_to_show, 'InitialMagnification', 800);
    xlabel("Spatial")
    ylabel("Temporal")
    frame_to_show = 1 - p;
    subplot(1,3,3)
    imshow(frame_to_show, 'InitialMagnification', 800);
    xlabel("Spatial")
    ylabel("Temporal")
end

