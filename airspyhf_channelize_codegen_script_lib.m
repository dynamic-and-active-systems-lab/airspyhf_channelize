% AIRSPYHF_CHANNELIZE_CODEGEN_SCRIPT_LIB   Generate executable airspyhf_channelize
%  from airspyhf_channelize.
% 
% Script generated from project 'airspyhf_channelize.prj' on 06-Jun-2022.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

curr_dir = pwd;
current_folder_name = curr_dir(find(curr_dir=='/',1,'last')+1:end);
if ~strcmp(current_folder_name,'airspyhf_channelize')
    error('This function must be run in the airspyhf_channelize root directory. Navigate to <repo location>/airspyhf_channelize and run again.')
end

%% Create configuration object of class 'coder.CodeConfig'.
cfg = coder.config('lib','ecoder',false);
cfg.CustomInclude = [curr_dir,'/CustomMains'];
cfg.CustomSource  = [curr_dir,'/CustomMains/main.c'];
cfg.GenCodeOnly = true;
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'airspyhf_channelize'.
ARGS = cell(1,1);
ARGS{1} = cell(2,1);
ARGS{1}{1} = coder.typeof(0);
ARGS{1}{2} = coder.typeof(0);

%% Invoke MATLAB Coder.
%cd('/home/dasl/airspyhf_channelize');
tic
codegen -config cfg airspyhf_channelize -args ARGS{1}
toc
cd([curr_dir,'/codegen/lib/airspyhf_channelize'])
[makestatus,makecmdout] = system('make -f airspyhf_channelize_rtw.mk');
disp('Make complete.')
load buildInfo.mat
packNGo(buildInfo,'packType','flat','fileName','portairspyhf_channelize')
disp('Zip complete.')
cd(curr_dir)
[mkdirstatus, mkdircmdout] = system('mkdir ~/Desktop/portairspyhf_channelize');
[mvzipstatus, mvzipcmdout] = system('mv portairspyhf_channelize.zip ~/Desktop/portairspyhf_channelize/portairspyhf_channelize.zip');
disp('Zip transfer complete.')
cd('~/Desktop/portairspyhf_channelize')
[unzipstatus, unzipcmdout] = system('unzip portairspyhf_channelize');
disp('Unzip complete.')
[cp1status,cp1cmdout] = system('cp /usr/lib/x86_64-linux-gnu/libdl.so ~/Desktop/portairspyhf_channelize/libdl.so');
systemcopycommand = ['cp ',matlabroot,'/sys/os/glnxa64/libiomp5.so ~/Desktop/portairspyhf_channelize/libiomp5.so'];
[cp2status,cp2cmdout] = system(systemcopycommand);
[exprtstatus, exprtcmdout] = system('export LD_LIBRARY_PATH=~/Desktop/portairspyhf_channelize');
disp('Library transfers complete')
[cmplstatus, cmplcmdout] = system('gcc main.c *.a *.so -o airspyhf_channelize');
if cmplstatus==0
    disp('Process complete. Executable generated.')
else
    disp(['Compile failed with output: ',cmplcmdout])
end

