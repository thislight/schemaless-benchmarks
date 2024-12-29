FROM fedora:41

VOLUME [ "/opt" ]

RUN dnf install -y zig make git coreutils && dnf clean all

ADD . /src
WORKDIR /src

RUN zig build --fetch

ENTRYPOINT [ "/src/tools/container-exec.sh" ]
