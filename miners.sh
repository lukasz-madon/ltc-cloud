#!/bin/sh
# setup
sudo yum -y groupinstall "Development Tools"
sudo yum -y install git libcurl-devel python-devel screen rsync yasm numpy openssl-devel
wget http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/cuda_5.5.22_linux_64.run
sudo sh cuda_5.5.22_linux_64.run  silent -toolkit -driver creates=/usr/local/cuda-5.5
# CudaMiner
git clone https://github.com/cbuchner1/CudaMiner
git reset -–hard 88c6da6d5c2b798d1de7031e8dbcc2678f635e4b
cd CudaMiner
./configure
PATH=/usr/local/cuda-5.5/bin:$PATH make
nohup sh -c "/usr/bin/env LD_LIBRARY_PATH=/usr/local/cuda-5.5/lib64 ./cudaminer -o stratum+tcp://us3.wemineltc.com:3333 -u lukasgt.gpu3 -p gpu3 -C 1 &"
# proxy
cd ~
git clone https://github.com/bandroidx/stratum-mining-proxy
cd stratum-mining-proxy/
sudo python distribute_setup.py
cd litecoin_scrypt/
sudo python setup.py install
cd ..
sudo python setup.py develop
chmod +x mining_proxy.py
nohup sh -c "./mining_proxy.py -o stratum2.wemineltc.com -p 3333 &" 
# CPU miner
cd ~
git clone https://github.com/pooler/cpuminer
cd cpuminer/
./autogen.sh
./configure CFLAGS="-O3"
make
nohup sh -c "./minerd -o http://127.0.0.1:8332 -u lukasgt.cpu3 -p cpu3 -t 6 &"