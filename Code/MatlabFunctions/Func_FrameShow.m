function Func_FrameShow(frame, p, str)
%   Image show a frame with options
    figure;
    subplot(1,3,1)
    frame_to_show = frame + 0.5;
    imshow(frame_to_show, 'InitialMagnification', 800);
    xlabel("Spatial")
    ylabel("Temporal")
    title("STA", 'Interpreter', 'latex');
    subplot(1,3,2)
    frame_to_show = 10 * (frame - mean(frame, [1 2]));
    frame_to_show = frame_to_show + 0.5;
    imshow(frame_to_show, 'InitialMagnification', 800);
    xlabel("Spatial")
    ylabel("Temporal")
    title("STA Contrast", 'Interpreter', 'latex');
    frame_to_show = 1 - p;
    subplot(1,3,3)
    imshow(frame_to_show, 'InitialMagnification', 800);
    %sgtitle(str, 'Interpreter', 'latex');
    xlabel("Spatial")
    ylabel("Temporal")
    title("p-Value", 'Interpreter', 'latex');
    x0=10;
    y0=10;
    width=500;
    height=450;
    set(gcf,'position',[x0,y0,width,height])
end

