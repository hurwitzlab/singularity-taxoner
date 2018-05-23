BootStrap: debootstrap
OSVersion: trusty
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%environment
    #need to put /usr/local/bin first so it doesnt use perl 5.18
    export PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin"
    export PATH="/media/miniconda/bin:$PATH"

%runscript
    exec /usr/local/bin/taxoner64 "$@"


%post
    echo "Hello from inside the container"
    sed -i 's/$/ universe/' /etc/apt/sources.list
    
    #essential stuff
    apt update
    apt -y --force-yes remove perl
    apt -y --force-yes install git sudo man vim build-essential wget
    #maybe dont need, add later if do:
    #curl autoconf libtool 

    #setting up taxoner
#    git clone https://github.com/scottdaniel/scotts-fortune.git
#    tar -xzf /scotts-fortune/src/taxoner64_version1.4.tar.gz
    cd ~
    git clone https://github.com/hurwitzlab/taxoner.git
    cd taxoner/taxoner64v1.4/
    bash make.sh
    mv ./taxoner64 /usr/local/bin

    cd ../PATRIC_dbCreator
    sudo chmod +x *.pl
    mv *.pl /usr/local/bin
#    rm -rf taxoner64

    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p /media/miniconda
    PATH="/media/miniconda/bin:$PATH"
    conda install -y -c bioconda bowtie2

    #get perl 5.22.1
    wget http://www.cpan.org/src/5.0/perl-5.22.1.tar.gz
    tar xvfz perl-5.22.1.tar.gz
    cd perl-5.22.1 && ./Configure -Duseithreads -des && make && make test && make install
    /usr/local/bin/cpan -u

    # Can't bind directories anymore on TACC or UAHPC due to security constraints #
#    #create a directory to work in
#    mkdir /work
#    #directory to map bt2 db to
#    mkdir /bt2
#    #directory to map metadata to
#    mkdir /metadata
#    #directory to map scripts / script settings just in case needed
#    #as in that "extra_commands.txt" for taxoner
#    mkdir /scripts

    # Set bind points
    mkdir -p /extra
    mkdir -p /xdisk
    mkdir -p /rsgrps
    mkdir -p /cm/shared
    #so we dont get those stupid perl warnings
    locale-gen en_US.UTF-8

%test
    taxoner64 -h
