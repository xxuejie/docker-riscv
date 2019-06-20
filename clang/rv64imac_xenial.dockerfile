# GNU toolchain is leveraged here for libc and binutils
FROM xxuejie/riscv-gnu-toolchain-rv64imac:xenial as builder
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN git clone https://github.com/llvm/llvm-project.git /root/source
RUN cd /root/source && git rev-parse HEAD > /root/LLVM_REVISION

RUN mkdir /root/source/build && cd /root/source/build && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_INSTALL_PREFIX="/riscv" -DLLVM_OPTIMIZED_TABLEGEN=True -DLLVM_BUILD_TESTS=False -DDEFAULT_SYSROOT="/riscv/riscv64-unknown-elf" -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf" -DLLVM_TARGETS_TO_BUILD="" -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV" ../llvm && make -j$(nproc) install

FROM xxuejie/riscv-gnu-toolchain-rv64imac:xenial
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>
COPY --from=builder /riscv /riscv
COPY --from=builder /root/LLVM_REVISION /riscv/LLVM_REVISION
ENV RISCV /riscv
ENV PATH "${PATH}:${RISCV}/bin"
CMD ["clang", "--version"]
