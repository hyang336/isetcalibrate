function val = icalPR650WaitForData(pr,mx)
% Wait for data on the pr serial line
%
% Default waits for 30 sec
%
%

if notDefined('mx'), mx = 30; end

val = false;   % No data

tic;
while toc < mx
    % Wait up to mx sec for num bytes to be positive

    if pr.NumBytesAvailable > 0
        val = true;
        return;
    else
        %pause(0.050);
        %!%HY debug
        pause(0.5);
        disp(['byte: ',num2str(pr.NumBytesAvailable)])
        disp(['toc: ',num2str(toc)])
        %!%
    end
end

end

