%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function plotTrainingResults
global learning

if isfield(learning.history, 'saturationCoefficient')
    figure('Name','Saturation Coefficients','NumberTitle','off');
    i=1;
    color=['b','r','k'];
    leg=cell(1,1);
    hold on
    for it = fieldnames(learning.history.saturationCoefficient)'
        plot([1:size(learning.history.saturationCoefficient.(char(it)),2)],learning.history.saturationCoefficient.(char(it)),color(i));
        leg{i} = char(it);
        i = i+1;
    end
    hold off;
    title('Saturation Coefficients');
    legend(char(leg));
end

if isfield(learning.history, 'forwardItHistory')
    figure('Name','Forward and backward iterations','NumberTitle','off');
    plot([1:size(learning.history.forwardItHistory,2)],learning.history.forwardItHistory,'b');
    hold on
    plot([1:size(learning.history.backwardItHistory,2)],learning.history.backwardItHistory,'g');
    hold off
    title('Forward and backward iterations');
    legend('Forward iterations', 'Backward iterations');
end

if isfield(learning.history, 'stabilityCoefficientHistory')
    figure('Name','Stability Coefficient History','NumberTitle','off');
    plot([1:size(learning.history.stabilityCoefficientHistory,2)],learning.history.stabilityCoefficientHistory);
    title('Stability Coefficient History');
end

if isfield(learning.history, 'jacobianHistory')
    figure('Name','Jacobian Error History','NumberTitle','off');
    plot([1:size(learning.history.jacobianHistory,2)],learning.history.jacobianHistory);
    title('Jacobian Error History');
end

if isfield(learning.history, 'jacobianHistoryComplete')
    figure('Name','Jacobian History','NumberTitle','off');
    plot([1:size(learning.history.jacobianHistoryComplete,2)],learning.history.jacobianHistoryComplete);
    title('Jacobian History');
end

if isfield(learning.history,'trainErrorHistory')
    figure('Name','Learning results','NumberTitle','off');
    plot([1:size(learning.history.trainErrorHistory,2)],learning.history.trainErrorHistory,'k');
    hold on
    t=[learning.config.stepsForValidation:learning.config.stepsForValidation:...
        learning.config.stepsForValidation*(size(learning.history.validationErrorHistory,2))];
    t(end)=learning.current.nSteps-1;
    plot(t, learning.history.validationErrorHistory,'r');
    hold off
    title('Learning results');
    legend('learning error', 'validation error');
end