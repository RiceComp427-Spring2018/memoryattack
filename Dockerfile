# From the Kali linux base image
FROM kalilinux/kali-linux-docker

# Update and apt install programs
RUN apt-get update && apt-get install -y \
# exploitdb \
# exploitdb-bin-sploits \
 binutils \
 git \
 gdb \
# gobuster \
# hashcat \
# hydra \
# man-db \
# minicom \
 metasploit-framework \
 nasm \
 python \
 python-pip \
 vim
# nmap \
# sqlmap \
# sslscan \
# wordlists

# Create known_hosts for git cloning
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
# Add host keys
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone git repos
#RUN git clone https://github.com/danielmiessler/SecLists.git /opt/seclists
#RUN git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/powersploit

# Other installs
#RUN pip install pwntools

# Setup ROPPER
RUN git clone https://github.com/sashs/Ropper.git /opt/ropper
RUN pip install capstone filebytes keystone-engine
RUN cd /opt/ropper && python setup.py install


# Update ENV
#ENV PATH=$PATH:/opt/powersploit

# Set entrypoint and working directory
WORKDIR /427hax/

# Copy the contents of this dir to the working dir

# Update ENV
#ENV PATH=$PATH:/opt/powersploit

# Set entrypoint and working directory
WORKDIR /427hax/

# Copy the contents of this dir to the working dir
COPY . /427hax/

RUN cd stacksmash && make

# Source the peda gdb stubs
RUN echo "source /427hax/peda/peda.py" >> ~/.gdbinit
