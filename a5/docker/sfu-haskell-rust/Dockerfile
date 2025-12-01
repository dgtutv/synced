FROM ubuntu:22.04

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y python3 \
  && apt-get install -y curl \
  && apt-get install -y ca-certificates \
  && apt-get install -y build-essential \
  && apt-get install -y libffi-dev \
  && apt-get install -y libffi8 \
  && apt-get install -y libgmp-dev \
  && apt-get install -y libgmp10 \
  && apt-get install -y libncurses-dev \
  && apt-get install -y libtinfo5 \
  && apt-get install -y pkg-config \
  && apt-get install -y locales \
  && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

RUN useradd -ms /bin/bash apprunner

USER apprunner

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

RUN echo 'export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"' >> ~/.bashrc 
RUN echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN . ~/.bashrc

RUN /home/apprunner/.ghcup/bin/ghcup install hls
RUN /home/apprunner/.ghcup/bin/ghcup install ghc 9.6.7
RUN /home/apprunner/.ghcup/bin/ghcup set ghc 9.6.7

RUN echo 'allow-different-user: true' >> ~/.stack/config.yaml 

# RUN /home/apprunner/.ghcup/bin/stack install hlint

CMD ["perl","-MPOSIX","-e","pause"]

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

ENV PATH="/root/.cargo/bin:${PATH}"
