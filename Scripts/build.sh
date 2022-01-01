## Build commands from various projects

# KLEE uClibc for Vigor
alias klee-uclibc-vigor-configure="./configure "\
"--make-llvm-lib "\
"--with-llvm-config=${PROJPATH}/LLVM/llvm/build-for-vigor/bin/llvm-config "\
"--with-cc=${PROJPATH}/LLVM/llvm/build-for-vigor/bin/clang && "\
"cp ${PROJPATH}/vigor-verified-network/install/klee-uclibc.config .config"

# KLEE
alias klee-configure="cmake "\
"-D LLVM_CONFIG_BINARY=/usr/local/opt/llvm34/bin/llvm-config-3.4 "\
"-D LLVMCC=/usr/local/opt/llvm34/bin/clang-3.4 "\
"-D LLVMCXX=/usr/local/opt/llvm34/bin/clang++-3.4 "\
"-D ENABLE_SOLVER_Z3=ON "\
"-D ENABLE_SYSTEM_TESTS=OFF "\
"-D ENABLE_UNIT_TESTS=OFF"

# KLEE for Vigor
alias klee-vigor-configure="mkdir -p ${PROJPATH}/klee/build-for-vigor && "\
"cd ${PROJPATH}/klee/build-for-vigor && "\
"cmake -G Ninja "\
"-D CMAKE_PREFIX_PATH=${PROJPATH}/z3/build-for-vigor "\
"-D CMAKE_INCLUDE_PATH=${PROJPATH}/z3/build-for-vigor/include "\
"-D CMAKE_CXX_FLAGS='-fno-rtti' "\
"-D LLVM_CONFIG_BINARY=${PROJPATH}/LLVM/llvm/build-for-vigor/bin/llvm-config "\
"-D LLVMCC=${PROJPATH}/LLVM/llvm/build-for-vigor/bin/clang "\
"-D LLVMCXX=${PROJPATH}/LLVM/llvm/build-for-vigor/bin/clang++ "\
"-D KLEE_UCLIBC_PATH=${PROJPATH}/klee-uclibc "\
"-D BUILD_SHARED_LIBS=OFF "\
"-D ENABLE_KLEE_ASSERTS=ON "\
"-D ENABLE_KLEE_UCLIBC=ON "\
"-D ENABLE_POSIX_RUNTIME=ON "\
"-D ENABLE_SOLVER_Z3=ON "\
"-D ENABLE_SYSTEM_TESTS=OFF "\
"-D ENABLE_UNIT_TESTS=OFF "\
".."
#    CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" \

# LLVM for Rust / WASM
alias llvm-wasm-configure="mkdir -p ${PROJPATH}/LLVM/llvm/build-for-wasm && "\
"cd ${PROJPATH}/LLVM/llvm/build-for-wasm && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly "\
"../llvm"

# LLVM for JFS
alias llvm-jfs-configure="mkdir -p ${PROJPATH}/LLVM/llvm/build-for-jfs && "\
"cd ${PROJPATH}/LLVM/llvm/build-for-jfs && "\
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

# LLVM for Vigor
# TODO: Assert correct LLVM version
# Projects clang;compiler-rt;libcxx enabled via symlinks
# "-D CMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=0' "\
alias llvm-vigor-configure="mkdir -p ${PROJPATH}/LLVM/llvm/build-for-vigor && "\
"cd ${PROJPATH}/LLVM/llvm/build-for-vigor && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_TARGETS_TO_BUILD=X86 "\
"../llvm"

# Z3 for JFS
alias z3-jfs-configure="mkdir -p ${PROJPATH}/z3/build-for-jfs && "\
"cd ${PROJPATH}/z3/build-for-jfs && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D USE_OPENMP=OFF "\
"-D USE_LIB_GMP=ON "\
"-D BUILD_LIBZ3_SHARED=OFF "\
".."

# Z3 for Vigor
# TODO: Assert correct Z3 version
alias z3-vigor-configure="mkdir -p ${PROJPATH}/z3/build-for-vigor && "\
"cd ${PROJPATH}/z3 && "\
"python scripts/mk_make.py --ml -b build-for-vigor -p ${PROJPATH}/z3/build-for-vigor && "\
"cd build-for-vigor"

# JFS
alias jfs-configure="mkdir -p ${PROJPATH}/jfs/build && "\
"cd ${PROJPATH}/jfs/build && "\
"cmake -G Ninja "\
"-D CMAKE_BUILD_TYPE=Release "\
"-D LLVM_DIR=${PROJPATH}/LLVM/llvm/build-for-jfs/lib/cmake/llvm "\
"-D Z3_DIR=${PROJPATH}/z3/build-for-jfs "\
"-D ENABLE_JFS_ASSERTS=ON "\
".."

# sharpSAT
alias sharpSAT-configure="mkdir -p ${PROJPATH}/sharpSAT/build && "\
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

# Electron
# cd electron-project
# gclient sync
# gn gen out/Testing --args="import(\"//electron/build/args/testing.gn\")"
# gn args out/Testing --list | less
# ninja -C out/Testing electron
# out/Testing/Electron.app/Contents/MacOS/Electron ../../vscode
