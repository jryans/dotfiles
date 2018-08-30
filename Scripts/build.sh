## Build commands from various projects

# KLEE
alias klee-build='cmake -D LLVM_CONFIG_BINARY=/usr/local/opt/llvm34/bin/llvm-config-3.4 -D LLVMCC=/usr/local/opt/llvm34/bin/clang-3.4 -D LLVMCXX=/usr/local/opt/llvm34/bin/clang++-3.4 -D ENABLE_SOLVER_Z3=ON -D ENABLE_SYSTEM_TESTS=OFF -D ENABLE_UNIT_TESTS=OFF'

# LLVM for Rust / WASM
alias llvm-wasm-build="mkdir -p ${PROJPATH}/llvm-project/build-for-wasm && "\
"cd ${PROJPATH}/llvm-project/build-for-wasm && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly "\
"../llvm"

# LLVM for JFS
alias llvm-jfs-build="mkdir -p ${PROJPATH}/llvm-project/build-for-jfs && "\
"cd ${PROJPATH}/llvm-project/build-for-jfs && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_OPTIMIZED_TABLEGEN=ON "\
"-D LLVM_CCACHE_BUILD=ON "\
"-D LLVM_ENABLE_PROJECTS='clang;compiler-rt;libcxx;libcxxabi' "\
"-D LLVM_TARGETS_TO_BUILD=X86 "\
"-D LLVM_ENABLE_RTTI=OFF "\
"-D LLVM_ENABLE_EH=OFF "\
"-D LLVM_ENABLE_LTO=OFF "\
"-D LLVM_BUILD_LLVM_DYLIB=OFF "\
"-D BUILD_SHARED_LIBS=OFF "\
"../llvm"

# Z3 for JFS
# "-D OpenMP_CXX_FLAGS=-fopenmp=libomp "\
# "-D CMAKE_CXX_COMPILER=/Users/jryans/Projects/llvm-project/build/bin/clang++ "\
alias z3-jfs-build="cd ${PROJPATH}/z3/build && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D USE_OPENMP=OFF "\
"-D USE_LIB_GMP=ON "\
"-D BUILD_LIBZ3_SHARED=OFF "\
".."

# JFS
alias jfs-build="mkdir -p ${PROJPATH}/jfs/build && "\
"cd ${PROJPATH}/jfs/build && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_DIR=${PROJPATH}/llvm-project/build-for-jfs/lib/cmake/llvm "\
"-D Z3_DIR=${PROJPATH}/z3/build "\
"-D ENABLE_JFS_ASSERTS=ON "\
".."

# sharpSAT
alias sharpSAT-build="mkdir -p ${PROJPATH}/sharpSAT/build && "\
"cd ${PROJPATH}/sharpSAT/build && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
".."

# ApproxMC
alias approxmc-configure='CC="/usr/local/opt/gcc/bin/gcc-7" CXX="/usr/local/opt/gcc/bin/g++-7" ../configure'
alias approxmc-run="./build/approxmc --epsilon=0.8 --delta=0.2 --gaussuntil=400 "\
"--verbosity=1 ../../jfs-experiments/experiments/4/benchmark_extremes_cnf/qf_fp/div.c.3.cnf | "\
"tee ../../jfs-experiments/experiments/4/benchmark_extremes_cnf/qf_fp/div.c.3.count.log"

# Tor
alias tor-conf='CC=clang ./configure --enable-fatal-warnings --with-openssl-dir=/usr/local/opt/openssl'
export STEM_SOURCE_DIR="/Users/jryans/Projects/tor/stem"

# RISC-V
export RISCV="/Users/jryans/Projects/boom-template/rocket-chip/riscv-tools/target"
export PATH="${RISCV}/bin:${PATH}"
