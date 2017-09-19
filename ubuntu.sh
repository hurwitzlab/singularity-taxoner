BootStrap: debootstrap
OSVersion: trusty
MirrorURL: http://us.archive.ubuntu.com/ubuntu/


%runscript
    exec /usr/bin/taxoner64 "$@"


%post
    echo "Hello from inside the container"
    sed -i 's/$/ universe/' /etc/apt/sources.list
    
    #essential stuff
    apt -y --force-yes install git sudo man vim build-essential perl
    
    #maybe dont need, add later if do:
    #curl autoconf libtool wget

    #setting up taxoner
#    git clone https://github.com/scottdaniel/scotts-fortune.git
#    tar -xzf /scotts-fortune/src/taxoner64_version1.4.tar.gz
    cd ~
    git clone https://github.com/hurwitzlab/taxoner.git
    cd taxoner/taxoner64v1.4/
    bash make.sh
    mv ./taxoner64 /usr/bin

    cd ../PATRIC_dbCreator
    sudo chmod +x *.pl
    mv *.pl /usr/bin
#    rm -rf taxoner64

    #create a directory to work in
    mkdir /work
    #directory to map bt2 db to
    mkdir /bt2

    #so we dont get those stupid worning on hpc/pbs
    mkdir /extra
    mkdir /xdisk
    #so we dont get those stupid perl warnings
    locale-gen en_US.UTF-8
%test
    taxoner64 -h
