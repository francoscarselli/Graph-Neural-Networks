%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function test_learning(experiment)

global dynamicSystem learning testing dataSet


dname=['experiments/' experiment.name '/' experiment.class ];
runlog=[dname '/exp_' experiment.run_prefix '.mat'];

if exist(runlog)
	load(runlog, 'explog')
else
	err(0, 'experiment log not found');
end

accuracies.validation=[];
accuracies.test=[];
accuracies.train=[];

for i=[1:explog.next-1]

	fname=[dname '/exp_' experiment.run_prefix '_' int2str(i)];
	
	disp(sprintf('\n\n******'))
	disp(['** Experiment >>' int2str(i) '<<'])
	disp(['**   file: -  ' fname ' - '])
	
	
	load(fname);
	test
	accuracies.validation(end+1)=testing.optimal.validationSet.accuracy;
	accuracies.test(end+1)=testing.optimal.testSet.accuracy;
	accuracies.train(end+1)=testing.optimal.trainSet.accuracy;
	
end

header='';
msgVa='';
msgTr='';
msgTe='';

for i=[1:explog.next-1]
	header=sprintf('%s%21s', header, ['exp_' experiment.run_prefix '_' num2str(i)]); 
	msgVa=sprintf('%s%20.2s%%', msgVa, num2str(accuracies.validation(i)*100));
	msgTr=sprintf('%s%20.2s%%', msgTr, num2str(accuracies.train(i)*100));
	msgTe=sprintf('%s%20.2s%%', msgTe, num2str(accuracies.test(i)*100));
end

disp(header);
disp(msgVa);
disp(msgTr);
disp(msgTe);


best.validation=find(accuracies.validation==max(accuracies.validation));
best.test=find(accuracies.test==max(accuracies.test));
best.train=find(accuracies.train==max(accuracies.train));

disp(['The best performing model on validation:' num2str(best.validation)] );
disp(['The best performing model on train:' num2str(best.train)] );
disp(['The best performing model on test:' num2str(best.test)] );

