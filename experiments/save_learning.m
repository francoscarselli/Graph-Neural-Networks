%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function save_learning(experiment)

global dynamicSystem learning testing


dname=['experiments/' experiment.name '/' experiment.class ];
runlog=[dname '/exp_' experiment.run_prefix '.mat'];

if exist(runlog)
	load(runlog, 'explog')
else
	if ~exist(dname)
		if ~exist(['experiments/' experiment.name] )
			mkdir (['experiments/' experiment.name ])
		end
		mkdir (dname)
	end
	explog={};
	explog.next=1;
	explog.best=1;
	explog.best_err=9999999;
	explog.experiment=experiment;
end

fname=[dname '/exp_' experiment.run_prefix '_' int2str(explog.next)];

curr_idx=explog.next;

if isfield( dynamicSystem, 'savedTo' )
	fname=dynamicSystem.savedTo;
	curr_idx=dynamicSystem.savedToIdx;
else
	dynamicSystem.savedTo=fname;
	dynamicSystem.savedToIdx=explog.next;
	explog.next=explog.next+1;
end

if (explog.best_err>learning.current.bestErrorOnValidation) 
	explog.best_err=learning.current.bestErrorOnValidation;
	explog.best=curr_idx;
end

disp(['saving to: -  ' fname ' - '])
save(fname, 'dynamicSystem','learning','testing');
save(runlog, 'explog');

