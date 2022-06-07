% AIRSPYHF_CHANNELIZE_CODEGEN_SCRIPT_EXE   Generate executable airspyhf_channelize
%  from airspyhf_channelize.
% 
% Script generated from project 'airspyhf_channelize.prj' on 06-Jun-2022.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.CodeConfig'.
cfg = coder.config('exe','ecoder',false);
cfg.CustomInclude = '/home/dasl/airspyhf_channelize/CustomMains';
cfg.CustomSource = '/home/dasl/airspyhf_channelize/CustomMains/main.c';
cfg.GenCodeOnly = true;
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'airspyhf_channelize'.
ARGS = cell(1,1);
ARGS{1} = cell(2,1);
ARGS{1}{1} = coder.typeof(0);
ARGS{1}{2} = coder.typeof(0);

%% Invoke MATLAB Coder.
cd('/home/dasl/airspyhf_channelize');
codegen -config cfg airspyhf_channelize -args ARGS{1}
