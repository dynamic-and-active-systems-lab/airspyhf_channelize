# airspyhf_channelize
This code allows incoming SDR data to be channelized and provided to other processes via UDP. 

The initial goal of this development was to enable complex IQ data streaming from an AirspyHF+ SDR to be brought into Matlab for processing. The resulting code should work though for any process that needs to receive channelized data streams. This software sits between the incoming high sample rate data and processes running on a machine that might want access to one or more channels at a lower sample rate. This code was developed in Matlab and converted to C using Matlab Coder. Some of the Matlab functions developed here has some interesting methods necessitated by the restrictions on system objects in Matlab when using Matlab Coder. 

The development of this code was funded via [National Science Foundation grant no. 2104570](https://nsf.gov/awardsearch/showAward?AWD_ID=2104570&HistoricalAwards=false).

## Pre-reqs
- [Airspyhf](https://airspy.com/airspy-hf-discovery/): Details on the install can be seen at this link or at the bottom of this readme. 
- Netcat must be installed on your machine to move data from airspyhf_rx to the channelizer via UDP.
- Running either of the the `airspyhf_channelize_codegen_script_***` scripts requires that [Matlab Coder](https://www.mathworks.com/products/matlab-coder.html) be installed with your Matlab install. This requires an installed compiler on your machine. More information on Coder requirements can be found [here](https://www.mathworks.com/help/coder/gs/installing-prerequisite-products.html). For macOS, XCode should be installed (don't forget to [accept the license agreement](https://stackoverflow.com/questions/31384994/how-to-accept-xcode-license) or you might get errors). For Linux systems, you need to have the `build-essentials` package installed. Additionally, the Matlab DSP toolbox must be installed, as the channelizer uses DSP objects. Note that if you generate an executable using Coder or gcc, the resulting executable does not depend on the Matlab install. Matlab is only needed at the time of code generation. 

## Setup
### Setup for running in Matlab
After cloning this repo, the airspyhf_channelize.m function can be run directly in Matlab. No additional setup should be needed.
### Setup for building a compiled executable 
The `airspyhf_channelize` function can be converted to an executable using Matlab Coder. In this way the channelizer will not require Matlab to run. The scripts to do the code generation are `airspyhf_channelize_codegen_script_***.m`. 
#### Executable for macOS
We provide two of these scripts. One (`airspyhf_channelize_codegen_script_exe.m`) can be used to generate the executable directly. We have tested this on macOS and it generates a executable that can be run in terminal. 
#### Executable for Linux
When testing `airspyhf_channelize_codegen_script_exe.m` for executable generation on Linux though (Ubuntu 20.04), Matlab Coder failed. In order to generate an executable for Linux, additional steps are needed and listed below. 
1. After cloning this repo run `airspyhf_channelize_codegen_script_lib.m` in Matlab. This may take a long time to run. See the note below. 
2. Coder will generate a `codegen` directory within the repo directory. Navigate to the `codegen/lib/airspyhf_channelize/` directory in a new terminal window and use the resulting make file (`airspyhf_channelize_rtw.mk`) to generate the static library (`*.a`) file. To do this, run `$ make -f airspyhf_channelize_rtw.mk` in terminal.
3. We now need to package all of the dependencies to simplify the compiling that is about to come. Go back to Matlab be sure you are in the repo directory. Run the following in Matlab to package all the dependencies into a single .zip file called `portairspyhf_channelize.zip`.
    - Run `>> load buildInfo.mat`
   - Run `>> packNGo(buildInfo, 'packType','flat','filename','portairspyhf_channelize')`
4. Move the `portairspyhf_channelize.zip` file to a new location on your system and unzip. 
5. Unfortunately, we have found that two dependencies aren't included with the packNGo functionality and must now be copied manually into the unzipped directory. 
    - Find the `libdl.so`  library symbolic link on your machine. For a typical install it should be in `/usr/lib/x86_64-linux-gnu`. Copy the symbolic link to the unzipped directory. 
    - Find the `libiomp5.so` library in your Matlab root directory. For a typical install of Matlab R2022a it should be in `/<MATLAB_ROOT>/sys/os/glnxa64`. Copy `libiomp5.so` to the unzipped directory. 
6. Open a terminal in the directory of the unzipped files and run `$ export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:<PATH TO THE UNZIPPED FILES>"`.
7. In this terminal, run `gcc main.c *.a *.so -o airspyhf_channelize`
8. The executable should be generated. To run this on a linux machine `./` needs to precede the `airspyhf_channelize` commands listed below in Basic Operation. ie. `./airspyhf_channelize 192000 48`. IMPORTANT: On subsequent calls of the program or in other terminal windows, you'll need to re-run `$ export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:<PATH TO THE UNZIPPED FILES>"` prior to calling airspyhf_channelizer. 

**Note:** Due to code generation restrictions within Matlab, each decimation factor for the channelizer required its own function. As such, the `airspyhf_channelize_codegen_script.m` may may take a long time to complete (up to a few hours). If you only need a subset of the decimation factor provided in this repo, it is highly recommended to modify the `airspyhf_channelize.m` function to limit the number of decimation/channel options so that the function compiles faster. 

## Basic Operation
### Starting the program
When compiled to an executable two arguments are needed: raw sample rate (from the SDR) and the desired decimation factor. The raw sample rate must be a supported sample rate from the AirspyHF+: 192, 256, 384, 456, 768, or 912 KSPS. Supported decimation factors are 2, 4, 10, 12, 16, 24, 32, 48, 64, 80, 96, 100, 120, 128, 192, and 256. These were selected, as they are a subset of the unique divisors of the supported sample rates. An example call in terminal to start this program would be 

`airspyhf_channelize 912000 4`

This would setup the program for incoming data and 912 KSPS that will be decimated by 4 to a sample rate of 228 KSPS. The output data will be served on local ports starting at 20000 and ending at one less than the number of channels (decimation factor). Once started, the program sits in an idle mode until it is commanded (see below) to begin processing data. It is critical that this program is started starting the stream of incoming data, otherwise 'Connection refused' messages will appear after the next step. We are using 912 KSPS with 4 channels so that the channel bandwidth in thie example is large enough to receive a US standard FM broadcast. The demo receiver code provided will demodulate this and play it back for testing. 

### Starting the incoming SDR data
The data coming into the channelizer progra  should be served on local port 10000. For example after starting the channelizer program, the folling terminal command would be issued. Note that you might want to change the center frequency in the command from 91.7 to a local FM station for tester purposes. 

`/usr/local/bin/airspyhf_rx -f 91.7 -m on -a 912000 -r stdout -g on -l high -t 0 | netcat -u localhost 10000`

This requires the installation of [airspyhf](https://github.com/airspy/airspyhf). Installation instructions for this can be found [below](https://github.com/dynamic-and-active-systems-lab/airspyhf_channelize#installing-airspyhf_rx). This pipes data from airspyhf_rx to netcat, which then sends the data via UDP to port 10000. The `airspyhf_channelize` function requires single precision complex data with frame lengths of 128 complex samples.

### Controlling operation
After running these two commands the program will start up but will initially be in an idle stat. There are three states of operation: 1) Idle/Pause 2) Running 3) Dead/Killed. The program accepts commands to transition between states from local port 10001. Transmitting a 1 will start the channelization and output. Transmitting a 0 will pause the operation and put the program into a idle state. Transmitting a -1 will terminate the program. In a separate terminal window, transmit the start, pause, or kill commands with commands: 

Start: `echo -e -n '\x01'| netcat -u -c localhost 10001`

Pause: `echo -e -n '\x00'| netcat -u -c localhost 10001`

Kill:  `echo -e -n '\xFF'| netcat -u -c localhost 10001`

### Receiving channelized data

Because the channelized data is served via UDP ports, the outputs can be used by any program capable of UDP data. A demo program to receive channelized data  written in Matlab and provided in the repo. Note that this function is pulls data from the first channel of the decimated output. This corresponds to the center frequency of the raw incoming radio data. Also, this function has a maximum receive message size of 1025, which is the IQ message length (1024) plus the frame timestamp (1). In the while loop, the time stamp is extracted and converted with the custom Matlab function singlecomplex2double().

Note about channel frequencies: Matlab provides the centerFrequencies function that accepts a channelizer object and a sample rate, and then specifies the center frequencies of the associated channel. This list however is centered at zero and provides negative frequencies. For example a channelizer with Fs = 48000 and a decimation factor of 3 would report center frequencies [-24000 -12000 0 12000]. If the fvtool is used on this channelizer (with the legend turned on) the center frequencies would be [0 12000 -24000 -12000] for filteres 1-4. The shifting here reflects a inconsistency in Matlab's channel reporting. The channelizer outputs follow the latter order, and as such, so to do the UDP port outputs in this function. Because the  number of chanels and the decimation are the same, the frequency of these channels are `-Fs/nc*floor(nc/2)<fc<Fs/2`, (where nc is the number of channels), if nc is odd. For even nc, `-Fs/2 < fc < Fs/2-Fs/nc`. In both cases the frequency steps are `Fs/nc`. This was determined by using the centerFrequencies.m function on example channelizer objects. If using the centerFrequencies output the circshift command can be used to get the correct order of channel frequency. For example: `circshift(centerFrequencies(channizerObject,48000),ceil(numChannels/2)).`


## Installing airspyhf_rx
[Airspyhf](https://airspy.com/airspy-hf-discovery/) is useful for manual control of the [AirspyHF+ Dual Port](https://airspy.com/airspy-hf-plus/) and [AirspyHF+ Discovery](https://airspy.com/airspy-hf-discovery/) software defined radios. 

#### Linux installation 

The instrunctions for installing airspyhf on Linux can be found in the airspyhf repo under "[How to build the host software on Linux](https://github.com/airspy/airspyhf#how-to-build-the-host-software-on-linux)". This will include the dependencies necessary for the installation and use of airspyhf. 

#### macOS installation 

To install this on macOS, you'll need to do a few things first:

1. [Ensure homebrew is installed](https://brew.sh/) and run brew doctor to see if any errors come up 
2. Ensure homebrew is updated by running the following command in a terminal window brew update 
3. Need wget: run the following command in a terminal window brew install wget 
4. Need cmake: run the following command in a terminal window brew install cmake 
5. Need libusb: run the following command in a terminal window brew install libusb

To install airspyhf, open a terminal directory where you want airspyhf-master directory downloaded to. You don't need to keep this directory after installing. Now, run the commands below for building and installing. 
```
wget https://github.com/airspy/airspyhf/archive/master.zip
unzip master.zip
cd airspyhf-master
mkdir build
cd build
export CMAKE_PREFIX_PATH=/usr/local/Cellar/libusb/1.0.24/include/libusb-1.0
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
```
That's it. It should be installed. 

All of the instructions here are the same as those found in the repo under "[How to build the host software on Linux](https://github.com/airspy/airspyhf#how-to-build-the-host-software-on-linux)" except for the export command. CMake doesn't know how to find libusb, so we run the export command to tell it where it is. It's a temp fix in that if you run CMake for this build process again, you'll have to do the same thing. But you would only need to run CMake once theoretically, since we are building/installing and then leaving it be. 
