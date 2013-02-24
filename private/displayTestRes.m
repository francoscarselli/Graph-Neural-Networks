%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function displayTestRes
% displays results
global testing dataSet learning VisualMode
if VisualMode == 1
    if isfield(testing.current.trainSet, 'accuracyOnGraphs')
        TestFigH=DisplayTestC(testing.current.trainSet.error,testing.current.trainSet.accuracy,...
            testing.optimal.trainSet.error,testing.optimal.trainSet.accuracy,...
            testing.current.testSet.error,testing.current.testSet.accuracy,...
            testing.optimal.testSet.error,testing.optimal.testSet.accuracy,...
            testing.current.trainSet.accuracyOnGraphs, testing.optimal.trainSet.accuracyOnGraphs,...
            testing.current.testSet.accuracyOnGraphs, testing.optimal.testSet.accuracyOnGraphs);
    else
        TestFigH=DisplayTestC(testing.current.trainSet.error, testing.current.trainSet.accuracy,...
            testing.optimal.trainSet.error, testing.optimal.trainSet.accuracy,...
            testing.current.testSet.error,testing.current.testSet.accuracy,...
            testing.optimal.testSet.error,testing.optimal.testSet.accuracy);
    end
    
else
    header='';
    line='';
    accuracies.optimal='';
    accuracies.current='';
    errors=accuracies;

    fmtH='%s%20s';
    fmtA='%s%19.2f%%';
    fmtE='%s%20.5f';
    for set={'trainSet', 'validationSet', 'testSet'}
        if isfield(dataSet, set)
            header=sprintf(fmtH, header, set{:});
            accuracies.optimal=sprintf(fmtA,accuracies.optimal,testing.optimal.(set{:}).accuracy*100);
            accuracies.current=sprintf(fmtA,accuracies.current,testing.current.(set{:}).accuracy*100);
            errors.optimal=sprintf(fmtE,errors.optimal,testing.optimal.(set{:}).error);
            errors.current=sprintf(fmtE,errors.current,testing.current.(set{:}).error);
            line(end+1:end+20)='-'; 
        end
    end

    %message(sprintf('\n\t\t\tTESTSET\t\t\t\t\t\tTRAINSET'));
    message(['                 |' header]);
    message(['-----------------|' line]);
    message(['OPTIMAL ACCURACY |' accuracies.optimal ]);
    message(['OPTIMAL ERROR    |' errors.optimal     ]);
    message( '                 |' );
    message(['CURRENT ACCURACY |' accuracies.current ]);
    message(['CURRENT ERROR    |' errors.current     ]);
    message(['-----------------|' line]);
end
